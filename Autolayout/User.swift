//
//  User.swift
//  Autolayout
//
//  Created by Ryan on 2015/4/4.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation

// User model
struct User{
  let name: String
  let company: String
  let login: String
  let password: String
  
  var lastLogin = NSDate.demoRandom()
  
  static func login(login: String, password: String) -> User? {
    if let user = database[login] {
      if user.password == password {
        return user
      }
    }
    return nil
  }
  
  // database = ["japple": User]
  static let database: Dictionary<String, User> = {
    var theDatabase = Dictionary<String, User>()
    for user in [
      User(name: "John Appleseed", company: "Apple", login: "japple", password: "foo", lastLogin: NSDate.demoRandom()),
      User(name: "Madison Bumgarner", company: "World Champion San Francisco Giants", login: "madbum", password: "foo", lastLogin: NSDate.demoRandom()),
      
      User(name: "John Hennessy", company: "Stanford", login: "hennessy", password: "foo", lastLogin: NSDate.demoRandom()),
      User(name: "Bad Guy", company: "Criminals, Inc.", login: "baddie", password: "foo", lastLogin: NSDate.demoRandom())
      ] {
        theDatabase[user.login] = user
    }
    return theDatabase
  }()
  
  
}


private extension NSDate {
  class func demoRandom() -> NSDate {
    let randomIntervalIntoThePast = -Double(arc4random() % 60*60*24*20)
    return NSDate(timeIntervalSinceNow: randomIntervalIntoThePast)
  }
}