//
//  MainCell.swift
//  CollectionView+Pagenation
//
//  Created by kou yamamoto on 2021/12/08.
//

import UIKit

final class MainCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel!

    func configure(str: String) {
        label.text = str
    }
}
