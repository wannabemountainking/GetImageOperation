//
//  ImageListViewController.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/18/24.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    let ds = PhotoDataSource()
    
    let backgroundQueue = OperationQueue()
    let mainQueue = OperationQueue.main

    @IBOutlet weak var imageCollectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        backgroundQueue.maxConcurrentOperationCount = 30
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
        backgroundQueue.cancelAllOperations()
        mainQueue.cancelAllOperations()
    }
    
    @IBAction func runOperation(_ sender: UIBarButtonItem) {
        var backgroundOperations = [Operation]()
        var uiOperations = [Operation]()
        
//        let reloadOp = ReloadOperation(collectionView: imageCollectionview)
//        uiOperations.append(reloadOp)
        
        for index in 0 ..< 20 {
            let targetData = ds.list[index]
            let downloadOp = DownloadOperation(target: targetData)
//            reloadOp.addDependency(downloadOp)
            backgroundOperations.append(downloadOp)
            let filterOp = FilterOperation(target: targetData)
            filterOp.addDependency(downloadOp)
            backgroundOperations.append(filterOp)
            let reloadItemOp = ReloadOperation(collectionView: imageCollectionview, indexPath: IndexPath(item: index, section: 0))
            reloadItemOp.addDependency(filterOp)
            uiOperations.append(reloadItemOp)
        }
        
        backgroundQueue.addOperations(backgroundOperations, waitUntilFinished: false)
        mainQueue.addOperations(uiOperations, waitUntilFinished: false)
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
