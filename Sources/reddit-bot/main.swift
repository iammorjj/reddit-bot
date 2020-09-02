import Foundation
import Alamofire

var token = ""

func refreshToken() {
  getNewToken()
  sleep(2) // seconds
}

func getNewToken() {
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

var postUrl: String?
var postID: String?

func getNewPost(subreddit: String = "MedicalMeme") {
  let url = "https://oauth.reddit.com/r/\(subreddit)/hot?limit=1"
  
  let headers: HTTPHeaders = [
    "Authorization": "Bearer \(token)",
  ]
  
  Alamofire.request(url, headers: headers).responseJSON { response in
    guard response.result.isSuccess else {
      print("[getNewPost] no success")
      
      // oh shit here we go again
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

    postUrl = data["url"] as? String
    postID = data["id"] as? String
    
  }
}

func isImage(url: String) -> Bool {
  let suffixes = [".png", ".jpeg", ".jpg"]
  for suf in suffixes {
    if url.hasSuffix(suf) {
      return true
    }
  }
  
  return false
}

if #available(OSX 10.12, *) {
  Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { _ in
    getNewPost()
    
    if let postID = postID, let postUrl = postUrl,
     !sentPosts.contains(postID) && isImage(url: postUrl) {
      print(postUrl)
      sentPosts.insert(postID)
    } else {
      print("🤓")
      print(postID ?? "nil", postUrl ?? "nil")
      print("👿")
    }
    
  }
} else {
  print("hmmmmm..... ручка....")
}

CFRunLoopRun()
