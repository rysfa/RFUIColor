//
//  RFViewController.swift
//  RFUIColor_Example
//
//  Created by Richard Fa on 2019-11-11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class RFViewController: UIViewController {

    @IBOutlet weak var tableView: RFTableView!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!

    let viewModel = RFViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.viewModel = viewModel
        viewModel.delegate = self
        viewModel.downloadSampleColorsAndSegments()
    }

    // MARK: Outlet Actions

    @IBAction func didChangeSliderValue(_ sender: UISlider) {
        viewModel.updateColor(withRed: CGFloat(redSlider.value),
                              withGreen: CGFloat(greenSlider.value),
                              withBlue: CGFloat(blueSlider.value))
    }
}

extension RFViewController: RFViewModelDelegate {

    func viewModel(_ viewModel: RFViewModel, didFinishDownloadingColors success: Bool, withError error: Error?) {
        if success {
            tableView.reloadData()
        }
    }

    func viewModel(_ viewModel: RFViewModel, didFinishDownloadingSegments success: Bool, withError error: Error?) {
    }

    func viewModel(_ viewModel: RFViewModel, didUpdateSelectedColor selectedColor: UIColor, withClosestMatch closestMatchIndex: Int) {
        tableView.scrollToRow(at: IndexPath(item: closestMatchIndex, section: 0), at: .middle, animated: true)
    }
}
