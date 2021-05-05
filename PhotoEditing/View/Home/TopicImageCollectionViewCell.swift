//
//  TopicImageCollectionViewCell.swift
//  PhotoEditing
//
//  Created by Mahesh Sapkota, Sarad Poudel, Kritartha Kafle on 04/25/21.

import UIKit

class TopicImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var imageLayer: UIImageView!
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageLayer.layer.cornerRadius = 8.0
        imageLayer.clipsToBounds = true 
    }
    
    
}
