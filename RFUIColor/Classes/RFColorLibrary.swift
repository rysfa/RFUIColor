//
//  RFColorLibrary.swift
//  RFUIColor
//
//  Created by Richard on 2018-04-15.
//

import UIKit

fileprivate let RFSampleFolderPath: String = "https://raw.githubusercontent.com/rysfa/RFUIColor/master/Sample%20JSON%20Files/"
fileprivate let RFSampleColorsFileName: String = "Sample%20Colors.json"
fileprivate let RFSampleColorsWithNamesFileName: String = "Sample%20Colors%20with%20Names.json"
fileprivate let RFSampleSegmentsFileName: String = "Sample%20Segments.json"
fileprivate let RFSampleSegmentsWithNamesFileName: String = "Sample%20Segments%20with%20Names.json"

public enum RFColorLibrarySortBy {
    case segment
    case hue
    case brightness
}

/// An optional data manager for maintaining all list of colors, and handling the downloading, as well as the sorting and grouping of the colors.
public class RFColorLibrary {

    // MARK: Class Variables

    /// The `RFColorLibrary` shared instance, would be treated as the primary source and is globally accessible.
    public static let main = RFColorLibrary()

    // MARK: Variables

    /// The `Array` of `String` hexadecimal values of `rawColors` sorted by the `sortBy` sorting method.
    public var colors: [String] {
        return sortColors()
    }

    /// The `RFColorLibrarySortBy` sorting method that is applied to the `colors`. `segment` by default.
    public var sortBy: RFColorLibrarySortBy = .segment

    /// The `Bool` value ordering that is applied to the `colors`. `true` by default.
    public var ascending: Bool = true

    /// The `Dictionary` with a key of `String` hexadecimal value and a value of `String` color name, of all the colors.
    public var rawColors = [String : String]() {
        didSet {
            sortedColorsTable.removeAll()
        }
    }

    /// The `Array` of `String` hexadecimal values, of all the segments.
    public var rawSegments = [String]() {
        didSet {
            sortedColorsTable.removeValue(forKey: .segment)
        }
    }

    // MARK: Functions

    /// Updates the `rawColors` and `rawSegments` values from downloading the `colorsURL` and `segmentsURL` parameters.
    ///
    /// - Parameters:
    ///   - colorsURL:      The `URL` for downloading the `colors`.
    ///   - segmentsURL:    The `URL` for downloading the `segments`.
    ///   - completion:     The completion block called after both the colors and segments have been updated.
    public func download(colors colorsURL: URL?,
                         segments segmentsURL: URL?,
                         with completion: (() -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()

        if let colorsURL = colorsURL {
            dispatchGroup.enter()
            downloadColors(from: colorsURL) { (success: Bool) in
                dispatchGroup.leave()
            }
        }

        if let segmentsURL = segmentsURL {
            dispatchGroup.enter()
            downloadSegments(from: segmentsURL) { (success: Bool) in
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }

    /// Updates the `rawColors` and `rawSegments` values from downloading the sample colors and segments.
    ///
    /// - Parameters:
    ///   - completion: The completion block called after both the colors and segments have been updated.
    public func downloadSampleColorsAndSegments(with completion: (() -> Void)? = nil) {
        download(colors: URL(string: RFSampleFolderPath + RFSampleColorsFileName),
                 segments: URL(string: RFSampleFolderPath + RFSampleSegmentsFileName)) {
            completion?()
        }
    }

    /// Updates the `rawColors` values from downloading the `url` parameter.
    ///
    /// - Parameters:
    ///   - url:        The `URL` for downloading the `colors`.
    ///   - completion: The completion block called after the colors have been updated. `success` returns whether `rawColors` was successfully updated.
    public func downloadColors(from url: URL,
                               with completion: ((_ success: Bool) -> Void)? = nil) {
        fetch(from: url) { [weak self] (data: Any?) in
            guard let data = data else {
                completion?(false)
                return
            }

            if let json = data as? [String : String] {
                self?.rawColors.removeAll()
                self?.sortedColorsTable.removeAll()
                json.forEach { (tuple) in
                    let (value, name) = tuple
                    if value.isValidHexValue && self?.rawColors[value] == nil {
                        self?.rawColors[value] = name
                    }
                }
                completion?(true)
            }

            if let json = data as? [String] {
                self?.rawColors.removeAll()
                self?.sortedColorsTable.removeAll()
                json.forEach { (value) in
                    if value.isValidHexValue && self?.rawColors[value] == nil {
                        self?.rawColors[value] = value
                    }
                }
                completion?(true)
            }

            completion?(false)
        }
    }

    /// Updates the `rawSegments` values from downloading the `url` parameter.
    ///
    /// - Parameters:
    ///   - url:        The `URL` for downloading the `segments`.
    ///   - completion: The completion block called after the segments have been updated. `success` returns whether `rawColors` was successfully updated.
    public func downloadSegments(from url: URL,
                                 with completion: ((_ success: Bool) -> Void)? = nil) {
        fetch(from: url) { [weak self] (data: Any?) in
            guard let data = data else {
                completion?(false)
                return
            }

            if let json = data as? [String : String] {
                self?.rawSegments.removeAll()
                self?.sortedColorsTable.removeValue(forKey: .segment)
                json.forEach { (tuple) in
                    let (value, _) = tuple
                    if value.isValidHexValue {
                        self?.rawSegments.append(value)
                    }
                }
                completion?(true)
            }

            if let json = data as? [String] {
                self?.rawSegments.removeAll()
                self?.sortedColorsTable.removeValue(forKey: .segment)
                json.forEach { (value) in
                    if value.isValidHexValue {
                        self?.rawSegments.append(value)
                    }
                }
                completion?(true)
            }

            completion?(false)
        }
    }

    // MARK: Private Variables

    fileprivate var sortedColorsTable = [RFColorLibrarySortBy : [String]]()

    // MARK: Private Functions

    fileprivate func sortColors() -> [String] {
        if let sortedColors = sortedColorsTable[sortBy] {
            return sortedColors
        }
        let allColors: [String] = Array(rawColors.keys)
        let sortedColors = UIColor.sort(hexValues: allColors, into: rawSegments, ascending: ascending)
        sortedColorsTable[sortBy] = sortedColors
        return sortedColors
    }

    fileprivate func fetch(from url: URL,
                           with completion: ((Any?) -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                completion?(nil)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] {
                completion?(json)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                completion?(json)
                return
            }

            completion?(nil)
        }
        dataTask.resume()
    }
}
