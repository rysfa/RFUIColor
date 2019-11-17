//
//  RFViewModel.swift
//  RFUIColor_Example
//
//  Created by Richard Fa on 2019-10-02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RFUIColor

fileprivate let maxColorValue: CGFloat = 255.0

protocol RFViewModelDelegate: class {

    func viewModel(_ viewModel: RFViewModel, didFinishDownloadingColors success: Bool, withError error: Error?)
    func viewModel(_ viewModel: RFViewModel, didFinishDownloadingSegments success: Bool, withError error: Error?)
    func viewModel(_ viewModel: RFViewModel, didUpdateSelectedColor selectedColor: UIColor, withClosestMatch closestMatchIndex: Int)
}

class RFViewModel {

    weak var delegate: RFViewModelDelegate?

    var numberOfColors: Int {
        return RFColorLibrary.main.colors.count
    }

    fileprivate var selectedColor = UIColor.red
    fileprivate var closestMatchIndex: Int = 0

    func downloadSampleColorsAndSegments() {
        RFColorLibrary.main.downloadSampleColorsAndSegments(withColors: { [weak self] (success: Bool, error: Error?) in
            if let self = self {
                self.delegate?.viewModel(self, didFinishDownloadingColors: success, withError: error)
            }
        }) { [weak self] (success: Bool, error: Error?) in
            if let self = self {
                self.delegate?.viewModel(self, didFinishDownloadingSegments: success, withError: error)
            }
        }
    }

    func updateColor(withRed redValue: CGFloat, withGreen greenValue: CGFloat, withBlue blueValue: CGFloat) {
        selectedColor = UIColor(red: redValue * maxColorValue,
                                green: greenValue * maxColorValue,
                                blue: blueValue * maxColorValue,
                                alpha: 1.0)
        closestMatchIndex = selectedColor.indexForBestMatch(in: RFColorLibrary.main.colors)
        delegate?.viewModel(self, didUpdateSelectedColor: selectedColor, withClosestMatch: closestMatchIndex)
    }

    func colorCellData(for index: Int) -> RFTableViewCellData? {
        let colorHexValue = RFColorLibrary.main.colors[index]
        guard let color = colorHexValue.color, let name = RFColorLibrary.main.rawColors[colorHexValue] else {
            return nil
        }
        return RFTableViewCellData(color: color, name: name,
                                   textColor: color.brightness > 0.5 ? UIColor.black : UIColor.white,
                                   isSelected: index == closestMatchIndex)
    }
}
