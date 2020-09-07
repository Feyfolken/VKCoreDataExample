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
    private var notesArray: [Note] = []
    
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
    }
    
    private func updateCounter() {
        counterLabel.text = "\(notesArray.count)"
    }
}

// MARK: MainScreenViewInput
extension MainScreenViewController: MainScreenViewInput {
    
    func setupInitialState() {
        self.title = "Notes"
        navigationController?.navigationBar.backgroundColor = .dc_BrightYellow
        
        updateCounter()
        setupCounterViewInitialState()
        setupCollectionViewInitialState()
        setupCounterDescriptionLabelInitialState()
        
        headerView.backgroundColor = .dc_AsphaltGray
    }
    
    func presentAlertController(_ alertController: UIAlertController, animated: Bool) {
        present(alertController, animated: animated, completion: nil)
    }
    
    func updateNotesAfterObtaining(_ notes: [Note]) {
        notesArray = notes
        updateCounter()
        
        collectionView.reloadData()
    }
    
    func updateNotesAfterAdding(_ note: Note) {
        notesArray.append(note)
        updateCounter()
        
        collectionView.reloadData()
    }
    
    func updateNotesAfterUpdating(with note: Note, for index: Int) {
        notesArray.remove(at: index)
        notesArray.insert(note, at: index)
        
        updateCounter()
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension MainScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCollectionViewCell
        
        cell.noteLabel.text = notesArray[indexPath.row].text
        cell.note = notesArray[indexPath.row]
        cell.delegate = self
        
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
        output.didSelectCell(at: indexPath, item: notesArray[indexPath.row])
    }
}

extension MainScreenViewController: NoteCollectionViewCellDelegate {
    
    func didTapDeleteButton(note: Note) {
        output.didTapDeleteNoteButton(note: note)
    }
}
