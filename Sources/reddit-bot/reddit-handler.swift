//
//  reddit.swift
//  reddit-bot
//
//  Created by Alexander Mordovsky on 03/09/2020.
//

import Foundation
import Alamofire

class Reddit {
  static var token = ""
  
  static func refreshToken() {
    getNewToken()
    sleep(2) // seconds
  }

  static func getNewToken() {
    let urlString = "https://www.reddit.com/api/v1/access_token"

    let params = [
      "grant_type": "password",
      "username": "\(username)",
      "password": "\(password)"
    ]

    Alamofire.request(urlString, method: .post, parameters: params).authenticate(user: appID, password: appSecret).responseJSON { response in
      guard response.result.isSuccess else {
        print("no success")
        exit(EXIT_SUCCESS)
      }
      
      guard let dict = response.result.value as? [String: Any] else {
        print("no value transform")
        exit(EXIT_SUCCESS)
      }
      
      token = dict["access_token"] as! String
    }
  }
  
  static func isImage(url: String) -> Bool {
    let suffixes = [".png", ".jpeg", ".jpg"]
    for suf in suffixes {
      if url.hasSuffix(suf) {
        return true
      }
    }
    
    return false
  }
  
  static func isNewPost(_ postID: String, _ postUrl: String) -> Bool {
//    if let postID = postID, let postUrl = postUrl,
    
     if !sentPosts.contains(postID) && isImage(url: postUrl) {
      sentPosts.insert(postID)
      saveSentPosts()
      return true
    } else {
      return false
    }
  }
  
  typealias PostURL = String
  
  static func getNewPost(subreddit: String = "MedicalMeme", _ completion: @escaping (_ post: PostURL) -> ()) {
    let url = "https://oauth.reddit.com/r/\(subreddit)/hot?limit=1"
    
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(token)",
    ]
    
    Alamofire.request(url, headers: headers).responseJSON { response in
      guard response.result.isSuccess else {
        print("[getNewPost] no success")

        refreshToken()
        return
      }

      guard let dict = response.result.value as? [String: Any],
        let globData = dict["data"] as? [String: Any],
        let children = globData["children"] as? [[String: Any]],
        let child = children.first,
        let data = child["data"] as? [String: Any] else {
          print("[getNewPost] no value transform")
          exit(EXIT_SUCCESS)
      }
      
      if let postUrl = data["url"] as? PostURL,
        let postID = data["id"] as? String,
//        isNewPost(postID, postUrl) {
        true {
        completion(postUrl)
      }
      
    }
  }
}
