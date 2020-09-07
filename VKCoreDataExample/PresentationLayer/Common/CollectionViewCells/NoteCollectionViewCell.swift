//
//  NoteCollectionViewCell.swift
//  VKCoreDataExample
//
//  Created by Feyfolken on 23.08.2020.
//  Copyright © 2020 Feyfolken. All rights reserved.
//

import UIKit

public protocol NoteCollectionViewCellDelegate {
    
    func didTapDeleteButton(note: Note)
}

final class NoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var noteLabel: UILabel!
    var note: Note!
    
    public var delegate: NoteCollectionViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        delegate.didTapDeleteButton(note: note)
    }
}
