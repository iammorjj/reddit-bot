import Foundation
import Alamofire

if #available(OSX 10.12, *) {
  Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
    Reddit.getNewPost { post in
      VK.send(post)
    }
  }
} else {
  print("hmmmmm..... ручка....")
}

CFRunLoopRun()
