//
//  ViewController.swift
//  RFUIColor
//
//  Created by rysfa on 09/02/2019.
//  Copyright (c) 2019 rysfa. All rights reserved.
//

import UIKit
import RFUIColor

class ViewController: UIViewController {

    @IBOutlet weak var colorLibraryCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RFColorLibrary.main.downloadSampleColorsAndSegments { [weak self] in
            self?.colorLibraryCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RFColorLibrary.main.colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RFColorLibraryCollectionViewCell", for: indexPath)
        let colorHexValue = RFColorLibrary.main.colors[indexPath.item]
        if let color = colorHexValue.color {
            cell.backgroundColor = color
        }
        return cell
    }
}
