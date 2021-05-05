//
//  Hashtag.swift
//  PhotoEditing
//
//  Created by Mahesh Sapkota, Sarad Poudel, Kritartha Kafle on 04/25/21. 
import Foundation
import Firebase

class Hashtag {
    var hashtag: String?
}

extension Hashtag {
    
    static func transformHashtag(dict: [String: Any], key: String) -> Hashtag {
        let tag = Hashtag()
        tag.hashtag = dict["hashtag"] as? String
        return tag
    }
}
