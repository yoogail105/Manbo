//
//  CalendarViewController.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import UIKit

class CalendarViewController: UIViewController {
    static let identifier = "CalendarViewController"

    @IBOutlet weak var collectionView: UICollectionView!
    

    @IBOutlet weak var collectonView: UICollectionView!
    var headerVisible = true
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           collectionView.delegate = self
           collectionView.dataSource = self
            
           let layout = UICollectionViewFlowLayout()
           let cellSize = UIScreen.main.bounds.width / 5
           layout.itemSize = CGSize(width: cellSize,height: cellSize)
           collectionView.collectionViewLayout = layout
        
           naviItem()
           
       }
    
    func naviItem() {
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "waveform"), style: .plain, target: self, action: #selector(settingButtonClicked))
        settingButton.tintColor = UIColor.label
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    @objc func settingButtonClicked() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CustomSideMenuNavigationViewController") as? CustomSideMenuNavigationViewController else {
            return
        }
        present(controller, animated: true, completion: nil)
    
    }

   }

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        cell.dailyImage.image = UIImage(named: "manbo01")
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let collectionCellWidth = UIScreen.main.bounds.width / 8.0
//        return CGSize(width: collectionCellWidth, height: collectionCellWidth)
//    }
    
}

