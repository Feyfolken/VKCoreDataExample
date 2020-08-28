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
    @IBOutlet weak var addNoteButton: UIButton!
    
    var output: MainScreenViewOutput!
    private var collapseExpandViewDelegate: CollapseExpandViewDelegate!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
    }
    
    // MARK: IBActions
    @IBAction func didTapAddNoteButton(_ sender: Any) {
        output.didTapAddNoteButton()
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
        collapseExpandViewDelegate.listener = self
        
        collectionView.delegate = collapseExpandViewDelegate
        collectionView.dataSource = self
        
        collectionView.frame.origin.y = headerView.frame.maxY + 50
    }
}

// MARK: MainScreenViewInput
extension MainScreenViewController: MainScreenViewInput {
    
    func setupInitialState() {
        self.title = "Notes"
        
        setupCounterViewInitialState()
        setupCollectionViewInitialState()
        setupCounterDescriptionLabelInitialState()
        
        headerView.backgroundColor = .dc_AsphaltGray
    }
    
    func presentAlertController(_ alertController: UIAlertController, animated: Bool) {
        present(alertController, animated: animated, completion: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: UIScreen.main.bounds.width, height: 130)
    }
}

// MARK: UICollectionViewDelegate
extension MainScreenViewController: CollapseExpandViewDelegateListener {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.didSelectCell(at: indexPath)
    }
}
