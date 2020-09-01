import Foundation
import Alamofire

var token = ""

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
    
    getNewMeme()
  }
}

func getNewMeme(subreddit: String = "MedicalMeme") {
  let url = "https://oauth.reddit.com/r/\(subreddit)/hot?limit=1"
  
//  let params = [
//    "grant_type": "password",
//    "username": "\(username)",
//    "password": "\(password)"
//  ]
  
  let headers: HTTPHeaders = [
    "Authorization": "Bearer \(token)",
  ]
  
  Alamofire.request(url, headers: headers).responseJSON { response in
    guard response.result.isSuccess else {
      print("[getNewMeme] no success")
      exit(EXIT_SUCCESS)
    }

    guard let dict = response.result.value as? [String: Any],
      let globData = dict["data"] as? [String: Any],
      let children = globData["children"] as? [[String: Any]],
      let child = children.first,
      let data = child["data"] as? [String: Any] else {
        print("[getNewMeme] no value transform")
        exit(EXIT_SUCCESS)
    }

    let url = data["url"] as? String
    let after = data["after"] as? String
    let postID = data["id"] as? String
    
    let gag = "bebebe"
    
    print(url ?? gag)
    print(after ?? gag)
    print(postID ?? gag)
    
  }
}

getNewToken()

dispatchMain()
