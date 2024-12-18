//
//  ViewController.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/18/24.
//

import UIKit

class ViewController: UIViewController {
    
    let ds = PhotoDataSource()
    
    let backgroundOperationQueue = OperationQueue()
    let mainOperationQueue = OperationQueue.main

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        imageCollectionView.collectionViewLayout = layout
    }

    @IBAction func runProcess(_ sender: UIBarButtonItem) {
        
        var backgroundOperations = [Operation]()
        var mainOperations = [Operation]()
        
        let reloadOp = ReloadOperation(collectionView: imageCollectionView)
        mainOperations.append(reloadOp)
        
        for index in 0 ..< 20 {
            let data = ds.list[index]
            
            let downloadOp = DownloadOperation(target: data)
            reloadOp.addDependency(downloadOp)
            backgroundOperations.append(downloadOp)
            
            let filterOp = FilterOperation(target: data)
            filterOp.addDependency(downloadOp)
            backgroundOperations.append(filterOp)
            
            let reloadItemOp = ReloadOperation(collectionView: imageCollectionView, indexPath: IndexPath(item: index, section: 0))
            reloadItemOp.addDependency(filterOp)
            mainOperations.append(reloadItemOp)
        }
        
        backgroundOperationQueue.addOperations(backgroundOperations, waitUntilFinished: false)
        mainOperationQueue.addOperations(mainOperations, waitUntilFinished: false)
    }
    
    @IBAction func cancelProcess(_ sender: UIBarButtonItem) {
        backgroundOperationQueue.cancelAllOperations()
        mainOperationQueue.cancelAllOperations()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ds.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self), for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = ds.list[indexPath.item].data
        cell.backgroundColor = .systemYellow
        return cell
    }
}


