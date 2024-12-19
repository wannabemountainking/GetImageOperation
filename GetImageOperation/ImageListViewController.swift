//
//  ImageListViewController.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/18/24.
//

import UIKit

class ImageListViewController: UIViewController {
    
    let ds = PhotoDataSource()

    @IBOutlet weak var imageCollectionview: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        imageCollectionview.collectionViewLayout = layout
    }
    
    @IBAction func cancelOperation(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func runOperation(_ sender: UIBarButtonItem) {
    }
    
}

extension ImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ds.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionview.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self), for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = ds.list[indexPath.item].data
        cell.backgroundColor = .systemCyan
        return cell
    }
    
    
    
}
