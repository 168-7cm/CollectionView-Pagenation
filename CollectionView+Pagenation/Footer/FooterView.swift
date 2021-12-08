//
//  ActivityFooterView.swift
//  Bish
//
//  Created by kou yamamoto on 2021/11/24.
//

import UIKit
import RxSwift

final class FooterView: UICollectionReusableView {

    var disposeBag = DisposeBag()

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

    func bind(observable: Observable<Bool>) {

        // 動いてない時は表示しない
        activityIndicator.hidesWhenStopped = true

//        // 次のインスタンスをBindする時に、前のインスタンスを破棄する
//        self.disposeBag = DisposeBag()

        // ViewControllerからの入力を受け取り、アニメーションを開始 / 停止する
        observable.withUnretained(self).subscribe(onNext: { owner, isLoading in
            isLoading ? owner.activityIndicator.startAnimating() : owner.activityIndicator.stopAnimating()
        }).disposed(by: disposeBag)
    }
}
