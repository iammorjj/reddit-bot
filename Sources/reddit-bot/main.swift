import Foundation
import Alamofire

let urlString = "https://www.reddit.com/api/v1/access_token"

let params = [
  "grant_type":"password",
  "username":"\(username)",
  "password":"\(password)"
]

let headers: HTTPHeaders = [
  "User-Agent": "ChangeMeClient/0.1 by YourUsername",
]

Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).authenticate(user: appID, password: appSecret).responseJSON { response in
  debugPrint(response)
  exit(EXIT_SUCCESS)
}

dispatchMain()
