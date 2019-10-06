//
//  ViewController.swift
//  RFUIColor
//
//  Created by rysfa on 09/02/2019.
//  Copyright (c) 2019 rysfa. All rights reserved.
//

import UIKit
import RFUIColor

fileprivate let reuseIdentifier = "RFColorLibraryTableViewCell"

class ViewController: UIViewController {

    @IBOutlet weak var orderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var groupedSwitch: UISwitch!

    @IBOutlet weak var colorGradientView: UIView!
    fileprivate var colorGradientLayer = CAGradientLayer()

    @IBOutlet weak var colorLibraryTableView: UITableView!
    @IBOutlet weak var colorLibraryTopFadeView: UIView!
    @IBOutlet weak var colorLibraryBottomFadeView: UIView!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        colorLibraryTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
        groupedSwitch.isEnabled = false

        activityIndicatorView.hidesWhenStopped = true

        downloadSampleColorsAndSegments()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buildColorLibraryFades()

        colorGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        colorGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        colorGradientLayer.frame = colorGradientView.bounds
        colorGradientView.layer.insertSublayer(colorGradientLayer, at: 0)
        colorGradientView.layer.borderWidth = 1.0
        colorGradientView.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction func didChangeOrderValue(_ sender: UISegmentedControl) {
        updateColorLibrary()
    }

    @IBAction func didChangeSortByValue(_ sender: UISegmentedControl) {
        updateColorLibrary()
    }

    @IBAction func didChangeGroupedValue(_ sender: UISwitch) {
        updateColorLibrary()
    }

    fileprivate func updateColorLibrary() {
        sortBySegmentedControl.isEnabled = !groupedSwitch.isOn
        viewModel.updateColorLibrary(groupedSwitchIsOn: groupedSwitch.isOn, sortBySegmentedControlIndex: sortBySegmentedControl.selectedSegmentIndex, isAscending: orderSegmentedControl.selectedSegmentIndex == 0)
        colorLibraryTableView.reloadData()

        colorGradientLayer.colors = viewModel.gradientColors()

        colorLibraryTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        colorLibraryTopFadeView.alpha = 0.0
        colorLibraryBottomFadeView.alpha = 1.0
    }

    fileprivate func downloadSampleColorsAndSegments() {
        activityIndicatorView.startAnimating()

        viewModel.downloadSampleColorsAndSegments(downloadColorsCompletion: { [weak self] (success: Bool) in
            DispatchQueue.main.async {
                if success {
                    self?.updateColorLibrary()
                }
                self?.activityIndicatorView.stopAnimating()
            }
        }) { [weak self] (success: Bool) in
            if success {
                DispatchQueue.main.async {
                    self?.groupedSwitch.isEnabled = true
                }
            }
        }
    }

    fileprivate func buildColorLibraryFades() {
        let topFadeGradientLayer = CAGradientLayer()
        topFadeGradientLayer.frame = colorLibraryTopFadeView.bounds
        topFadeGradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        colorLibraryTopFadeView.layer.insertSublayer(topFadeGradientLayer, at: 0)

        let bottomFadeGradientLayer = CAGradientLayer()
        bottomFadeGradientLayer.frame = colorLibraryBottomFadeView.bounds
        bottomFadeGradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        colorLibraryBottomFadeView.layer.insertSublayer(bottomFadeGradientLayer, at: 0)
    }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RFColorLibrary.main.colors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let colorHexValue = RFColorLibrary.main.colors[indexPath.item]
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        if let color = colorHexValue.color {
            cell.contentView.backgroundColor = color
            cell.textLabel?.text = RFColorLibrary.main.rawColors[colorHexValue]
            cell.textLabel?.textColor = color.brightness > 0.5 ? UIColor.black : UIColor.white
        }
        return cell
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y < colorLibraryTopFadeView.bounds.height {
            colorLibraryTopFadeView.alpha = scrollView.contentOffset.y / colorLibraryTopFadeView.bounds.height
        } else {
            colorLibraryTopFadeView.alpha = 1.0
        }

        let lowerBound = scrollView.contentSize.height - scrollView.bounds.height - colorLibraryBottomFadeView.bounds.height
        if scrollView.contentOffset.y > lowerBound {
            colorLibraryBottomFadeView.alpha = 1.0 - ((scrollView.contentOffset.y - lowerBound) / colorLibraryBottomFadeView.bounds.height)
        } else {
            colorLibraryBottomFadeView.alpha = 1.0
        }
    }
}
