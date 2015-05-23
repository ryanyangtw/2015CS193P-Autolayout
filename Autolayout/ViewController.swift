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
  
  @IBOutlet weak var lastLoginLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  var loggedInUser: User? { didSet {updateUI()} }
  var secure: Bool = false { didSet {updateUI()} }
  
  private func updateUI() {
    passwordField.secureTextEntry = secure
    
    let password = NSLocalizedString("Password", comment: "Prompt for the user's password when it is not secure (i.e. plain text)")
    let securedPassword = NSLocalizedString("Secured Password", comment: "Prompt for an obscured (not plain text) password")
    
    passwordLabel.text = secure ? securedPassword : password
    nameLabel.text = loggedInUser?.name
    companyLabel.text = loggedInUser?.company
    image = loggedInUser?.image
    
    if let lastLogin = loggedInUser?.lastLogin {
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
      dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
      let time = dateFormatter.stringFromDate(lastLogin)
      let numberFormatter = NSNumberFormatter()
      
      numberFormatter.maximumFractionDigits = 1
      
      let daysAgo = numberFormatter.stringFromNumber(-lastLogin.timeIntervalSinceNow/(60*60*24))!
      
      let lastLoginFormatString = NSLocalizedString("Last Login %@ days ago at %@", comment: "Reports the number of days ago and time that the user last logged in")
      
      lastLoginLabel.text = String.localizedStringWithFormat(lastLoginFormatString, daysAgo, time)
    
    } else {
      lastLoginLabel.text = ""
    }
    
  }

  @IBAction func toggleSecurity() {
    secure = !secure
  }
  
  
  
  private struct AlertStrings {
    struct LoginError {
      static let Title = NSLocalizedString("Login Error", comment: "Title of alert when user types in an incorrect user name or password")
      
      static let Message = NSLocalizedString("Invalid user name or password", comment: "Message in an alert when the user types in an incorrect user name or password")
      
      static let DismissButton = NSLocalizedString("Try Again", comment: "The only button available in an alert presented when the user types incorrect user name or password")
    }
  }
  
  @IBAction func login() {
    loggedInUser = User.login(loginField.text ?? "" , password: passwordField.text ?? "")
    
    if loggedInUser == nil {
      let alert = UIAlertController(title: AlertStrings.LoginError.Title, message: AlertStrings.LoginError.Message, preferredStyle: UIAlertControllerStyle.Alert)
      
      alert.addAction(UIAlertAction(title: AlertStrings.LoginError.DismissButton, style: UIAlertActionStyle.Default, handler: nil))
      
      presentViewController(alert, animated: true, completion: nil)
    }
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


