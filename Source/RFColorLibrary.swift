//
//  RFColorLibrary.swift
//  RFUIColor
//
//  Created by Richard on 2018-04-15.
//

import UIKit

enum RFColorLibrarySortBy {
    case segment
    case hue
    case brightness
}

class RFColorLibrary {

    static let main = RFColorLibrary()

    var colors: [String] {
        return sortColors()
    }

    var sort: RFColorLibrarySortBy = .segment
    var ascending: Bool = true

    var colorDictionary = [String : String]() {
        didSet {
            sortedColorsTable.removeAll()
        }
    }

    var colorSegments = [String]() {
        didSet {
            sortedColorsTable.removeAll()
        }
    }

    func addSampleColors() {
        let sampleColors = [
            "#000000" : "Black",
            "#555555" : "Dark Gray",
            "#AAAAAA" : "Light Gray",
            "#FFFFFF" : "White",
            "#808080" : "Gray",
            "#FF0000" : "Red",
            "#00FF00" : "Green",
            "#0000FF" : "Blue",
            "#00FFFF" : "Cyan",
            "#FFFF00" : "Yellow",
            "#FF00FF" : "Magenta",
            "#FF8000" : "Orange",
            "#800080" : "Purple",
            "#996633" : "Brown"]

        sampleColors.forEach { (tuple) in
            let (hexValue, name) = tuple
            if colorDictionary[hexValue] == nil {
                colorDictionary[hexValue] = name
            }
        }
    }

    func addSampleSegments() {
        let sampleSegments = [
            "#FF0000" /* Red */,
            "#FF8000" /* Orange */,
            "#FFFF00" /* Yellow */,
            "#00FF00" /* Green */,
            "#0000FF" /* Blue */,
            "#800080" /* Purple */,
            "#996633" /* Brown */,
            "#FFFFFF" /* White */,
            "#808080" /* Gray */,
            "#000000" /* Black */]

        sampleSegments.forEach { (string) in
            let hexValue = string as String
            if !colorSegments.contains(hexValue) {
                colorSegments.append(hexValue)
            }
        }
    }

    fileprivate var sortedColorsTable = [RFColorLibrarySortBy : [String]]()

    fileprivate func sortColors() -> [String] {
        if let sortedColors = sortedColorsTable[sort] {
            return sortedColors
        }
        let allColors: [String] = Array(colorDictionary.keys)
        let sortedColors = UIColor.sort(hexValues: allColors, into: colorSegments, ascending: ascending)
        sortedColorsTable[sort] = sortedColors
        return sortedColors
    }

    func downloadFromServer(withCompletion completion: (() -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        downloadColors {
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        downloadSegments {
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }

    func downloadColors(withCompletion completion: (() -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        //        guard let url = URL(string: "https://raw.githubusercontent.com/rysfa/ColorMixer/master/ColorMixer/colors.json") else {
        guard let path = Bundle.main.path(forResource: "colors", ofType: "json", inDirectory: nil, forLocalization: nil) else {
            completion?()
            return
        }

        let dataTask = session.dataTask(with: URL(fileURLWithPath: path)) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                completion?()
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] else {
                completion?()
                return
            }

            json.forEach { (tuple) in
                let (hexValue, name) = tuple
                if self?.colorDictionary[hexValue] == nil {
                    self?.colorDictionary[hexValue] = name
                }
            }

            completion?()
        }
        dataTask.resume()
    }

    func downloadSegments(withCompletion completion: (() -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        //        guard let url = URL(string: "https://raw.githubusercontent.com/rysfa/ColorMixer/master/ColorMixer/colors.json") else {
        guard let path = Bundle.main.path(forResource: "segments", ofType: "json", inDirectory: nil, forLocalization: nil) else {
            completion?()
            return
        }

        let dataTask = session.dataTask(with: URL(fileURLWithPath: path)) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                completion?()
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else {
                completion?()
                return
            }

            self?.colorSegments = json
            completion?()
        }
        dataTask.resume()
    }
}
