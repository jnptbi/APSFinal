//
//  ReportingPhotoCollectionCell.swift
//  apssecurity
//
//  Created by Smeet Chavda on 2020-11-23.
//

import UIKit

protocol DeleteImageProtocol {
    func deleteImage(index: Int)
}

class ReportingPhotoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var objImgView: UIImageView!
    @IBOutlet weak var objDeleteBtn: UIButton!
    var delegate: DeleteImageProtocol?
    
    @IBAction func deleteClicked(_ sender: UIButton) {
        delegate?.deleteImage(index: sender.tag)
    }
}
