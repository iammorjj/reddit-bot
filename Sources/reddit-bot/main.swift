import Foundation
import Alamofire

if #available(OSX 10.12, *) {
  Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
    VK.sendPost(Reddit.getNewPost())
  }
} else {
  print("hmmmmm..... ручка....")
}

CFRunLoopRun()
