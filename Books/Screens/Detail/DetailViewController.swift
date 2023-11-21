//
//  DetailViewController.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var likeCollectionView: UICollectionView!
    @IBOutlet weak var caruselCollectionView: UICollectionView!
    @IBOutlet weak var readersLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var quotesLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var readNowButton: UIButton!
    @IBOutlet weak var descriptionView: UIView!
    
    var centerFlowLayout: CenterFlowLayout = CenterFlowLayout()
    var viewModel: DetailViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }
    
    private func bindData() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.caruselCollectionView.reloadData()
                self?.likeCollectionView.reloadData()
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        if let index = viewModel.caruselItems.firstIndex(where: {$0.id == viewModel.selectedModel.bookId}) {
            self.caruselCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        if let model = viewModel.caruselItems.first(where: {$0.id == viewModel.selectedModel.bookId}) {
            readersLabel.text = model.views
            likesLabel.text = model.likes
            quotesLabel.text = model.quotes
            genreLabel.text = model.genre
            summaryLabel.text = model.summary
        }
    }
    
    private func setupUI() {
        setupCaruselCollection()
        setupLikeCollectionView()
        readNowButton.layer.cornerRadius = 25
        descriptionView.clipsToBounds = true
        descriptionView.layer.cornerRadius = 25
        descriptionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func setupCaruselCollection() {
        caruselCollectionView.dataSource = self
        caruselCollectionView.delegate = self
        caruselCollectionView.register([CaruselDetailCollectionViewCell.identifier])
        
        centerFlowLayout.itemSize = CGSize(
            width: 200,
            height: 330
        )
        centerFlowLayout.spacingMode = .fixed(spacing: 16)
        centerFlowLayout.scrollDirection = .horizontal
        centerFlowLayout.animationMode = .scale(sideItemScale: 0.8, sideItemAlpha: 1, sideItemShift: 0.0)
        caruselCollectionView.collectionViewLayout = centerFlowLayout
        caruselCollectionView.isScrollEnabled = true
    }
    
    private func setupLikeCollectionView() {
        
        likeCollectionView.register([MainCollectionViewCell.identifier])
        likeCollectionView.collectionViewLayout = createLayout()
        
        likeCollectionView.dataSource = self
        likeCollectionView.delegate = self
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        viewModel.route(to: .back)
    }
    
    deinit {
        printDeinit(self)
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case caruselCollectionView: return viewModel.caruselItems.count
        default: return viewModel.likedBooks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case caruselCollectionView:
            let cell: CaruselDetailCollectionViewCell = collectionView.dequeue(id: CaruselDetailCollectionViewCell.self, for: indexPath)
            let model = viewModel.caruselItems[indexPath.row]
            cell.configure(with: model)
            return cell
        default:
            let cell: MainCollectionViewCell = collectionView.dequeue(id: MainCollectionViewCell.self, for: indexPath)
            let model = viewModel.likedBooks[indexPath.row]
            cell.configure(with: model)
            cell.descriptionLabel.textColor = .black
            return cell
        }
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === caruselCollectionView {
            if let page = centerFlowLayout.currentCenteredPage {
                
                let model = viewModel.caruselItems[page]
                readersLabel.text = model.views
                likesLabel.text = model.likes
                quotesLabel.text = model.quotes
                genreLabel.text = model.genre
                summaryLabel.text = model.summary
            }
        }
    }
}

extension DetailViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let inset: CGFloat = 8
            
            // Items
            let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: .zero, bottom: inset, trailing: inset)
            
            // Calculate the fractional width for nestedGroup based on itemCount
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1))
            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [smallItem])
            
            // Section
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 16, bottom: .zero, trailing: 16)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            
            return section
            
        }
        return compositionalLayout
    }
    
    
}
