//
//  MainDataSource.swift
//  CollectionView+Pagenation
//
//  Created by kou yamamoto on 2021/12/08.
//

import Foundation
import RxDataSources

struct MainCustomData {
    var items: [CustomMediaTweet]
}

extension MainCustomData: SectionModelType {

    typealias Item = CustomMediaTweet

    init(original: MainCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

