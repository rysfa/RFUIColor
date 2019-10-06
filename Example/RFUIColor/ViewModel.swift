//
//  ViewModel.swift
//  RFUIColor_Example
//
//  Created by Richard Fa on 2019-10-02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RFUIColor

class ViewModel {

    func downloadSampleColorsAndSegments(downloadColorsCompletion: ((_ success: Bool) -> Void)? = nil,
                                         downloadSegmentsCompletion: ((_ success: Bool) -> Void)? = nil) {
        RFColorLibrary.main.downloadSampleColorsAndSegments(withColors: { (success: Bool, error: Error?) in
            downloadColorsCompletion?(success)
        }) { (success: Bool, error: Error?) in
            downloadSegmentsCompletion?(success)
        }
    }

    func updateColorLibrary(groupedSwitchIsOn: Bool, sortBySegmentedControlIndex: Int, isAscending: Bool) {
        if groupedSwitchIsOn {
            RFColorLibrary.main.sortBy = .segment
        } else {
            switch sortBySegmentedControlIndex {
            case 0:
                RFColorLibrary.main.sortBy = .hue
                break
            case 1:
                RFColorLibrary.main.sortBy = .brightness
                break
            default:
                break
            }
        }
        RFColorLibrary.main.ascending = isAscending
    }

    func gradientColors() -> [CGColor] {
        var gradientColors = [CGColor]()
        let allColorsInGradient = RFColorLibrary.main.sortBy == .segment ? RFColorLibrary.main.rawSegments : RFColorLibrary.main.colors
        for colorHexValue in allColorsInGradient {
            if let color = colorHexValue.color {
                gradientColors.append(color.cgColor)
            }
        }
        return gradientColors
    }
}
