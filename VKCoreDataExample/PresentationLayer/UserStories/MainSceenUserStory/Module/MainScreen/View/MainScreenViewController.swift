//
//  MainScreenViewController.swift
//  Investment
//
//  Created by Vadim on 12/12/2020.
//  Copyright © 2020 Diasoft. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var counterDescriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var output: MainScreenViewOutput!
    private var collapseExpandViewDelegate: CollapseExpandViewDelegate!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
    }
    
    // MARK: Private methods
    private func setupCounterDescriptionLabelInitialState() {
        counterDescriptionLabel.textColor = .white
    }
    
    private func setupCounterViewInitialState() {
        counterView.layer.cornerRadius =  counterView.frame.size.width / 2
        counterView.clipsToBounds = true
        counterView.backgroundColor = .dc_BrightYellow
    }
    
    private func setupCollectionViewInitialState() {
        collectionView.register(UINib(nibName: "NoteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "noteCell")
        
        collapseExpandViewDelegate = CollapseExpandViewDelegate(with: collectionView,
                                                                    headerView: headerView,
                                                                    viewController: self,
                                                                    shouldSetupRoundCorners: true)
          
        collectionView.delegate = collapseExpandViewDelegate
        collectionView.dataSource = self
    }
}

// MARK: MainScreenViewInput
extension MainScreenViewController: MainScreenViewInput {
    
    func setupInitialState() {
        setupCounterViewInitialState()
        setupCollectionViewInitialState()
        setupCounterDescriptionLabelInitialState()
        
        headerView.backgroundColor = .dc_AsphaltGray
    }
    
}

// MARK: UICollectionViewDataSource
extension MainScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCollectionViewCell
        
        cell.noteLabel.text = "  Note Note Noteote Note Noteote Note Noteote Note Noteote Note Noteote Note Noteote Note Noteote Note Noteote Note Noteote Note Noteote Note Noteote Note Noteote Note Note ote Note Note "
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: UIScreen.main.bounds.width, height: 130)
//    }
}

// MARK: UICollectionViewDelegate
extension MainScreenViewController: UICollectionViewDelegate {
    
}
