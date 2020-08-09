//
//  RFViewModel.swift
//  RFUIColor_Example
//
//  Created by Richard Fa on 2019-10-02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RFUIColor

protocol RFViewModelDelegate: class {
    func viewModel(_ viewModel: RFViewModel, didFinishDownloadingColors success: Bool, withError error: Error?)
}

struct RFColorInfo {
    var color: UIColor
    var name: String
    var textColor: UIColor
}

class RFViewModel {

    weak var delegate: RFViewModelDelegate?

    var numberOfColors: Int {
        return RFColorLibrary.main.colors.count
    }

    fileprivate var selectedColor = UIColor.red
    fileprivate var closestMatchIndex: Int = 0

    func downloadSampleColorsAndSegments() {
        RFColorLibrary.main.downloadSampleColorsAndSegments(withColors: { [weak self] (success, error) in
            if let self = self {
                self.delegate?.viewModel(self, didFinishDownloadingColors: success, withError: error)
            }
        }, withSegments: nil)
    }

    func colorInfo(for index: Int) -> RFColorInfo? {
        let colorHexValue = RFColorLibrary.main.colors[index]
        guard let color = colorHexValue.color, let name = RFColorLibrary.main.rawColors[colorHexValue] else {
            return nil
        }
        let textColor = color.brightness > 0.5 ? UIColor.black : UIColor.white
        return RFColorInfo(color: color, name: name, textColor: textColor)
    }

    func indexForBestMatch(for color: UIColor) -> Int {
        return color.indexForBestMatch(in: RFColorLibrary.main.colors)
    }
}
