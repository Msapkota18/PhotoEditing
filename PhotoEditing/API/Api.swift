//
//  Api.swift
//  PhotoEditing
//
//  Created by Mahesh Sapkota, Sarad Poudel and Kritartha Kafle on 04/25/21.

import Foundation

struct Api {
    
    static var Userr = UserApi()
    static var Post = PostApi()
    static var MyPosts = MyPostsApi()
    static var MySavedPosts = MySavedPostsApi()
    static var Follow = FollowApi()
    static var Feed = FeedApi()
    static var HashTag = HashTagApi()
    static let blockUser = BlockApi()
}
