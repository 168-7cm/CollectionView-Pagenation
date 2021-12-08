//
//  ViewController.swift
//  CollectionView+Pagenation
//
//  Created by kou yamamoto on 2021/12/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MainViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModelType = MainViewModel()

    private let dataSource = RxCollectionViewSectionedReloadDataSource<MainCustomData>(
        configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCustomCell(with: MainCell.self, indexPath: indexPath)
            cell.configure(str: item.tweet.full_text)
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let footerView = collectionView.dequeueReusableCustomFooterView(with: FooterView.self, kind: kind, indexPath: indexPath)
            return footerView
        })
    
    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setup()
        viewModel.inputs.fetch(shouldRefrech: true)
    }

    private func setup() {
        collectionView.registerCustomCell(MainCell.self)
        collectionView.registerCustomFooterView(FooterView.self, kind: UICollectionView.elementKindSectionFooter)
        collectionView.collectionViewLayout = layout()
    }

    private func bind() {

        viewModel.outputs.items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        collectionView.rx.willDisplaySupplementaryView.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            let supplementaryView = result.supplementaryView
            switch supplementaryView {
            case let footerView as FooterView:
                footerView.bind(observable: self.viewModel.outputs.loading)
                self.viewModel.inputs.fetch(shouldRefrech: false)
            default:
                return
            }
        }).disposed(by: disposeBag)
    }

    private func layout() -> UICollectionViewCompositionalLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8.0, leading: 4.0, bottom: 8.0, trailing: 4.0)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [sectionFooter]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

