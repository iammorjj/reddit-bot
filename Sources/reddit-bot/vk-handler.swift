//
//  vk-handler.swift
//  reddit-bot
//
//  Created by Alexander Mordovsky on 05/09/2020.
//

import Foundation
import Alamofire

class VK {
  static func send(_ post: String) {
    let urlString = "https://api.vk.com/method/messages.send"
    
    var params = [
      "access_token": "6b9420af1ef1024b571c213310ac0f5753b1a55dcea091bb083101ad1e644e6abb41b983dd3a105336832",
      "domain": "amordo",
      "v": "5.122",
      "message": "vibratorrrr",
      "random_id": "232222"
    ]
    
    func changeRand() {
      params["random_id"] = String(arc4random())
    }
    
    changeRand()
    
    //print(params)
    
    Alamofire.request(urlString, parameters: params).responseJSON { response in
        guard response.result.isSuccess else {
          print("no success vk ")
          exit(EXIT_SUCCESS)
        }
        
        guard let dict = response.result.value as? [String: Any] else {
          print("no value transform")
          exit(EXIT_SUCCESS)
        }
        
        print(dict["response"] as? Int ?? "hm, another decoder")
    }
  }
}
