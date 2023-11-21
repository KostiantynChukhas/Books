//
//  MainViewController.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: MainViewModelType!
    
    private var currentIndex = 0
    private let buffer = 1000
    private var totalElements: Int = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindData()
        setupTimer()
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoscroll), userInfo: nil, repeats: true)
    }
    
    private func setupCollectionView() {
        
        collectionView.register([MainCollectionViewCell.identifier,
                                 BannerCollectionViewCell.identifier])
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func bindData() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func handleCellTap() {
        let totalItemCount = viewModel.section.first?.topBannerSlides?.count ?? 0
        if currentIndex == totalItemCount {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc private func autoscroll() {
        handleCellTap()
    }
    
    deinit {
        printDeinit(self)
        timer?.invalidate()
        timer = nil
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.section.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            totalElements = buffer + (viewModel.section.first?.topBannerSlides?.count ?? 0)
            return totalElements
        default: return viewModel.section[section - 1].items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeue(id: BannerCollectionViewCell.self, for: indexPath)
            let totalPageCount = viewModel.section.first?.topBannerSlides?.count ?? 0
            if totalPageCount != 0 {
                let currentIndex = indexPath.row % totalPageCount
                let model = viewModel.section[indexPath.section].topBannerSlides?[currentIndex]
                cell.configure(with: model, currentPage: currentIndex, totalPageCount: totalPageCount)
            }
            return cell
        default:
            let cell = collectionView.dequeue(id: MainCollectionViewCell.self, for: indexPath)
            let model = viewModel.section[indexPath.section - 1].items[indexPath.row]
            cell.configure(with: model)
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let totalPageCount = viewModel.section.first?.topBannerSlides?.count ?? 0
            let currentIndex = indexPath.row % totalPageCount
            let model = viewModel.section[indexPath.section].topBannerSlides?[currentIndex]
            viewModel.makeSelected(with: model?.bookID ?? 0)
        default:
            let model = viewModel.section[indexPath.section - 1].items[indexPath.row]
            viewModel.makeSelected(with: model.id ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        self.timer?.invalidate()
        self.setupTimer()
        self.currentIndex = indexPath.row + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
            let model = viewModel.section[indexPath.section - 1]
            headerView.configure(title: model.title)
            return headerView
        }
        return UICollectionReusableView()
    }
}


extension MainViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 16
                item.contentInsets.leading = 16
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(167)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: 25, trailing: .zero)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                return section
            } else {
                let inset: CGFloat = 8
                
                // Items
                let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
                smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: .zero, bottom: inset, trailing: inset)
                
                // Calculate the fractional width for nestedGroup based on itemCount
                let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1))
                let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [smallItem])
                
                // Outer Group
                let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(220))
                let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [nestedGroup])
                
                // Section
                let section = NSCollectionLayoutSection(group: outerGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 16, bottom: .zero, trailing: 16)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                // Supplementary Item
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
            }
            
        }
        return compositionalLayout
    }
    
    
}
