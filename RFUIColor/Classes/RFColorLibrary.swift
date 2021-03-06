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

    func sortColorsBy() -> RFSortColorsBy? {
        switch self {
        case .hue:
            return RFSortColorsBy.hue
        case .brightness:
            return RFSortColorsBy.brightness
        default:
            return nil
        }
    }
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
            sortedColorsTable.removeColors(ofSort: .segment)
        }
    }

    // MARK: Functions

    /// Updates the `rawColors` and `rawSegments` values from downloading the `colorsURL` and `segmentsURL` parameters.
    ///
    /// - Parameters:
    ///   - colorsURL:                  The `URL` for downloading the `colors`.
    ///   - segmentsURL:                The `URL` for downloading the `segments`.
    ///   - downloadColorsCompletion:   The completion block called after the colors have been updated. `success` returns whether the request was successful. `error` returns the optional error object from the response from downloading colors.
    ///   - downloadSegmentsCompletion: The completion block called after the segments have been updated. `success` returns whether the request was successful. `error` returns the optional error object from the response from downloading segments.
    public func download(colors colorsURL: URL?,
                         segments segmentsURL: URL?,
                         withColors downloadColorsCompletion: ((_ success: Bool, _ error: Error?) -> Void)? = nil,
                         withSegments downloadSegmentsCompletion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {
        if let colorsURL = colorsURL {
            downloadColors(from: colorsURL) { (success: Bool, error: Error?) in
                downloadColorsCompletion?(success, error)
            }
        } else {
            downloadColorsCompletion?(false, nil)
        }

        if let segmentsURL = segmentsURL {
            downloadSegments(from: segmentsURL) { (success: Bool, error: Error?) in
                downloadSegmentsCompletion?(success, error)
            }
        } else {
            downloadSegmentsCompletion?(false, nil)
        }
    }

    /// Updates the `rawColors` and `rawSegments` values from downloading the sample colors and segments.
    ///
    /// - Parameters:
    ///   - downloadColorsCompletion:   The completion block called after the colors have been updated. `success` returns whether the request was successful. `error` returns the optional error object from the response from downloading colors.
    ///   - downloadSegmentsCompletion: The completion block called after the segments have been updated. `success` returns whether the request was successful. `error` returns the optional error object from the response from downloading segments.
    public func downloadSampleColorsAndSegments(withColors downloadColorsCompletion: ((_ success: Bool, _ error: Error?) -> Void)? = nil,
                                                withSegments downloadSegmentsCompletion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {
        download(colors: URL(string: RFSampleFolderPath + RFSampleColorsWithNamesFileName),
                 segments: URL(string: RFSampleFolderPath + RFSampleSegmentsFileName), withColors: { (success: Bool, error: Error?) in
                    downloadColorsCompletion?(success, error)
        }) { (success: Bool, error: Error?) in
            downloadSegmentsCompletion?(success, error)
        }
    }

    /// Updates the `rawColors` values from downloading the `url` parameter.
    ///
    /// - Parameters:
    ///   - url:        The `URL` for downloading the `colors`.
    ///   - completion: The completion block called after the colors have been updated. `success` returns whether `rawColors` was successfully updated. `error` returns the optional error object from the response.
    public func downloadColors(from url: URL,
                               with completion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {
        fetch(from: url) { [weak self] (data: Any?, error: Error?) in
            guard let data = data else {
                completion?(false, error)
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
                completion?(true, error)
                return
            }

            if let json = data as? [String] {
                self?.rawColors.removeAll()
                self?.sortedColorsTable.removeAll()
                json.forEach { (value) in
                    if value.isValidHexValue && self?.rawColors[value] == nil {
                        self?.rawColors[value] = value
                    }
                }
                completion?(true, error)
                return
            }

            completion?(false, error)
        }
    }

    /// Updates the `rawSegments` values from downloading the `url` parameter.
    ///
    /// - Parameters:
    ///   - url:        The `URL` for downloading the `segments`.
    ///   - completion: The completion block called after the segments have been updated. `success` returns whether `rawColors` was successfully updated. `error` returns the optional error object from the response.
    public func downloadSegments(from url: URL,
                                 with completion: ((_ success: Bool, _ error: Error?) -> Void)? = nil) {
        fetch(from: url) { [weak self] (data: Any?, error: Error?) in
            guard let data = data else {
                completion?(false, error)
                return
            }

            if let json = data as? [String : String] {
                self?.rawSegments.removeAll()
                self?.sortedColorsTable.removeColors(ofSort: .segment)
                json.forEach { (tuple) in
                    let (value, _) = tuple
                    if value.isValidHexValue {
                        self?.rawSegments.append(value)
                    }
                }
                completion?(true, error)
                return
            }

            if let json = data as? [String] {
                self?.rawSegments.removeAll()
                self?.sortedColorsTable.removeColors(ofSort: .segment)
                json.forEach { (value) in
                    if value.isValidHexValue {
                        self?.rawSegments.append(value)
                    }
                }
                completion?(true, error)
                return
            }

            completion?(false, error)
        }
    }

    // MARK: Private Variables

    fileprivate var sortedColorsTable = RFSortedColorsTable()

    // MARK: Private Functions

    fileprivate func sortColors() -> [String] {
        if let sortedColors = sortedColorsTable.retrieveColors(for: sortBy, ascending: ascending) {
            return sortedColors
        }
        let allColors: [String] = Array(rawColors.keys)

        var sortedColors = [String]()
        if let sortColorsBy = sortBy.sortColorsBy() {
            sortedColors = UIColor.sort(hexValues: allColors, sortedBy: sortColorsBy, ascending: ascending)
        } else {
            sortedColors = UIColor.sort(hexValues: allColors, into: rawSegments, ascending: ascending)
        }
        if sortedColors.count > 0 {
            sortedColorsTable.save(sortedColors, ofSort: sortBy, ascending: ascending)
        }
        return sortedColors
    }

    fileprivate func fetch(from url: URL,
                           with completion: ((_ data: Any?, _ error: Error?) -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
                completion?(nil, error)
                return
            }

            if let json = rawJSON["colors"] as? [String : String] {
                completion?(json, error)
                return
            }

            if let json = rawJSON["colors"] as? [String] {
                completion?(json, error)
                return
            }

            completion?(nil, error)
        }
        dataTask.resume()
    }
}

fileprivate class RFSortedColorsTable {

    fileprivate func retrieveColors(for sortBy: RFColorLibrarySortBy, ascending: Bool) -> [String]? {
        let sortedColorsTableForSort = sortedColorsForSort(by: ascending)
        guard let sortedColors = sortedColorsTableForSort[sortBy] else {
            return nil
        }
        return sortedColors
    }

    fileprivate func save(_ colors: [String], ofSort sortBy: RFColorLibrarySortBy, ascending: Bool) {
        if ascending {
            ascSortedColorsTable[sortBy] = colors
        } else {
            desSortedColorsTable[sortBy] = colors
        }
    }

    fileprivate func removeColors(ofSort sort: RFColorLibrarySortBy) {
        ascSortedColorsTable.removeValue(forKey: sort)
        desSortedColorsTable.removeValue(forKey: sort)
    }

    fileprivate func removeAll() {
        ascSortedColorsTable.removeAll()
        desSortedColorsTable.removeAll()
    }

    private func sortedColorsForSort(by ascending: Bool) -> [RFColorLibrarySortBy : [String]] {
        return ascending ? ascSortedColorsTable : desSortedColorsTable
    }

    private var ascSortedColorsTable = [RFColorLibrarySortBy : [String]]()
    private var desSortedColorsTable = [RFColorLibrarySortBy : [String]]()
}
