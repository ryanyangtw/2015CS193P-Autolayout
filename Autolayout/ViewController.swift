//
//  ViewController.swift
//  Autolayout
//
//  Created by Ryan on 2015/4/4.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passwordLabel: UILabel!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var companyLabel: UILabel!
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  var loggedInUser: User? { didSet {updateUI()} }
  var secure: Bool = false { didSet {updateUI()} }
  
  private func updateUI() {
    passwordField.secureTextEntry = secure
    passwordLabel.text = secure ? "Secure Password" : "Password"
    nameLabel.text = loggedInUser?.name
    companyLabel.text = loggedInUser?.company
    image = loggedInUser?.image
  }

  @IBAction func toggleSecurity() {
    secure = !secure
  }
  @IBAction func login() {
    loggedInUser = User.login(loginField.text ?? "" , password: passwordField.text ?? "")
  }
  
  
  // a convenience property
  // so that we can easily intervene
  // when an image is set in our imageView
  // whenever the image is set in our imageView
  // we add a constraint that the imageView
  // must maintain the aspect ratio of its image
  private var image: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue
      if let constrainedView = imageView {
        if let newImage = newValue {
          aspectRatioConstraint = NSLayoutConstraint(
            item: constrainedView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: constrainedView,
            attribute: .Height,
            multiplier: newImage.aspectRatio,
            constant: 0)
        }  else {
          aspectRatioConstraint = nil
        }
      }
    }
  }
  

  // the imageView aspect ratio constraint
  // when it is set here,
  // we'll remove any existing aspect ratio constraint
  // and then add the new one to our view
  var aspectRatioConstraint: NSLayoutConstraint? {
    willSet {
      if let existingConstraint = aspectRatioConstraint {
        view.removeConstraint(existingConstraint)
      }
    }
    didSet {
      if let newConstraint = aspectRatioConstraint {
        view.addConstraint(newConstraint)
      }
    }
  }
  
}


extension User {
  
  var image: UIImage? {
    
    println("login: \(login)")
    
    if let image = UIImage(named: login) {
      return image
    } else {
      return UIImage(named: "unknown_user")
    }
  }
}


// wouldn't it be convenient
// to have an aspectRatio property in UIImage?
// yes, it would, so let's add one!
// why is this not already in UIImage?
// probably because the semantic of returning zero
//   if the height is zero is not perfect
//   (nil might be better, but annoying)
extension UIImage{
  var aspectRatio: CGFloat {
    return size.height != 0 ? size.width/size.height : 0
  }
}


