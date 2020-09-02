//
//  log-posts-id.swift
//  reddit-bot
//
//  Created by Alexander Mordovsky on 02/09/2020.
//

import Foundation

var sentPosts: Set<String> = []

let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
let fileURL = dir?.appendingPathComponent("posts.log")

func loadSentPosts() {
  guard let fileURL = fileURL else {
    print("Can't get posts.log file")
    return
  }
  
  do {
    let file = try String(contentsOf: fileURL, encoding: .utf8)
    sentPosts = Set(file.split(separator: "\n").map{String($0)})
  }
  catch {
    print("Can't parse posts.log file")
  }
}

func saveSentPosts() {
  guard let fileURL = fileURL else {
    print("Can't get posts.log file")
    return
  }
  
  let file = Array(sentPosts).joined(separator: "\n")
  do {
    try file.write(to: fileURL, atomically: true, encoding: .utf8)
  }
  catch {
    print("Can't rewrite posts.log file")
  }
}
