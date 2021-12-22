//
//  MainViewModel.swift
//  CollectionView+Pagenation
//
//  Created by kou yamamoto on 2021/12/08.
//

import Foundation
import RxCocoa
import RxSwift

protocol MainViewModelInputs {
    func fetch(shouldRefrech: Bool)
}

protocol MainViewModelOutputs {
    var items: Observable<[MainCustomData]> { get }
    var loading: Observable<Bool> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

final class MainViewModel: MainViewModelInputs, MainViewModelOutputs, MainViewModelType {

    private let model = TwitterRepository()
    private let disposeBag = DisposeBag()

    var inputs: MainViewModelInputs { return self }
    var outputs: MainViewModelOutputs { return self }

    private let loadingRelay = PublishRelay<Bool>()
    var loading: Observable<Bool> { return loadingRelay.asObservable() }

    private let itemsRelay = BehaviorRelay<[MainCustomData]>(value: [])
    var items: Observable<[MainCustomData]> { return itemsRelay.asObservable() }

    func fetch(shouldRefrech: Bool) {
        loadingRelay.accept(true)
        model.fetchMediaTweet(shouldRefresh: shouldRefrech, query: "BiSH", filter: "images").subscribe(
            onSuccess: { [weak self] mediaTweet in
                guard let self = self else { return }
                self.loadingRelay.accept(false)
                let tweet = mediaTweet.statuses.compactMap { tweet in tweet.extended_entities?.media.map { CustomMediaTweet(tweet: tweet, media: $0 ) } }.flatMap { $0 }
                switch shouldRefrech {
                case true:
                    let media = MainCustomData(items: tweet)
                    self.itemsRelay.accept([media])
                case false:
                    let items = self.itemsRelay.value[0].items
                    let media = MainCustomData(items: items + tweet)
                    self.itemsRelay.accept([media])
                }
            },
            onFailure: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
}
