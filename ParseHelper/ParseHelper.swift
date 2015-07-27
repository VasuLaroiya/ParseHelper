//
//  ParseLogic.swift
//  One
//
//  Created by Jatinder Kumar on 7/2/15.
//  Copyright © 2015 Vasu Laroiya. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class ParseHelper: NSObject {
    static let sharedInstance = ParseHelper()
    
    var currentUser:PFUser!
    
    /**
    Logs the user in
    */
    
    func logInUser(email:String, password:String, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        PFUser.logInWithUsernameInBackground(email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), password: password, block: { (user:PFUser?, error:NSError?) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                    self.currentUser = PFUser.currentUser()!
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error!))
                }
            }
        })
    }
    
    /**
    Creates a new user
    */
    
    func createUser(email:String, password:String, confirmPassword:String?, parameters:[String:AnyObject]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        let user = PFUser()
        user.email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        user.username = user.email
        
        if parameters != nil {
            for parameter in parameters! {
                user[parameter.0] = parameter.1
            }
        }
        
        if confirmPassword != nil {
            
            if password.length > 0 && confirmPassword!.length > 0 {
                
                if password == confirmPassword {
                    user.password = password
                    
                    user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil {
                            if completion != nil {
                                completion!(success: true, errorMesssage: nil)
                                self.currentUser = PFUser.currentUser()!
                            }
                        } else {
                            if completion != nil {
                                var errorMessage = getErrorMessage(error!)
                                let email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                                errorMessage = errorMessage.stringByReplacingOccurrencesOfString(" \(email)", withString: "")
                                completion!(success: false, errorMesssage: errorMessage)
                            }
                        }
                    })
                } else {
                    if completion != nil {
                        completion!(success: false, errorMesssage: "Passwords do not match")
                    }
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: "Enter a valid password")
                }
            }
        } else {
            user.password = password
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, errorMesssage: nil)
                        self.currentUser = PFUser.currentUser()!
                    }
                } else {
                    if completion != nil {
                        var errorMessage = getErrorMessage(error!)
                        let email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        errorMessage = errorMessage.stringByReplacingOccurrencesOfString(" \(email)", withString: "")
                        completion!(success: false, errorMesssage: errorMessage)
                    }
                }
            })
        }
    }
    
    /**
    Sends password reset email
    */
    
    func sendForgotPasswordEmail(var email:String, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        PFUser.requestPasswordResetForEmailInBackground(email) { (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: success, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error!).stringByReplacingOccurrencesOfString("with email \(email)", withString: "with this email"))
                }
            }
        }
    }
    
    /**
    Login user using Facebook with read permissions
    */
    
    func loginUserUsingFacebookReadPermissions(permissions:[AnyObject]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error!))
                }
            }
        }
    }
    
    /**
    Login user using Facebook with publish permissions
    */
    
    func loginUserUsingFacebookPublishPermissions(permissions:[AnyObject]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        PFFacebookUtils.logInInBackgroundWithPublishPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error!))
                }
            }
        }
    }
    
    /**
    Link user to Facebook with read permissions
    */
    
    func linkFacebookToUserUsingReadPermissions(permissions:[AnyObject]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        if let user = PFUser.currentUser() {
            if !PFFacebookUtils.isLinkedWithUser(user) {
                PFFacebookUtils.linkUserInBackground(user, withReadPermissions: permissions, block: { (success, error) -> Void in
                    if error == nil {
                        if completion != nil {
                            completion!(success: success, errorMesssage: nil)
                        }
                    } else {
                        if completion != nil {
                            completion!(success: false, errorMesssage: getErrorMessage(error!))
                        }
                    }
                })
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: "User canceled login procedure")
                }
            }
        } else {
            if completion != nil {
                completion!(success: false, errorMesssage: "No Parse user logged in")
            }
        }
    }
    
    /**
    Link user to Facebook with publish permissions
    */
    
    func linkFacebookToUserUsingPublishPermissions(permissions:[AnyObject], completion:((success:Bool, errorMesssage:String?)->Void)?) {
        if let user = PFUser.currentUser() {
            if !PFFacebookUtils.isLinkedWithUser(user) {
                PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: permissions, block: { (success, error) -> Void in
                    if error == nil {
                        if completion != nil {
                            completion!(success: success, errorMesssage: nil)
                        }
                    } else {
                        if completion != nil {
                            completion!(success: false, errorMesssage: getErrorMessage(error!))
                        }
                    }
                })
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: "User canceled login procedure")
                }
            }
        } else {
            if completion != nil {
                completion!(success: false, errorMesssage: "No Parse user logged in")
            }
        }
    }
    
    /**
    Login user using Twitter
    */
    
    func loginUserUsingTwitter(completion:((success:Bool, errorMesssage:String?)->Void)?) {
        PFTwitterUtils.logInWithBlock { (user, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error!))
                }
            }
        }
    }
    
    /**
    Link user using Twitter
    */
    
    func linkTwitterToUser(completion:((success:Bool, errorMesssage:String?)->Void)?) {
        if let user = PFUser.currentUser() {
            if !PFTwitterUtils.isLinkedWithUser(user) {
                PFTwitterUtils.linkUser(user, block: { (success, error) -> Void in
                    if error == nil {
                        if completion != nil {
                            completion!(success: success, errorMesssage: nil)
                        }
                    } else {
                        if completion != nil {
                            completion!(success: false, errorMesssage: getErrorMessage(error!))
                        }
                    }
                })
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: "User canceled login procedure")
                }
            }
        } else {
            if completion != nil {
                completion!(success: false, errorMesssage: "No Parse user logged in")
            }
        }
    }
    
    /**
    Saves object to a specific class on Parse server
    */
    
    func saveObject(className:String, parameters:[String:AnyObject]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        let objectClass = PFObject(className: className)
        
        if parameters != nil {
            for parameter in parameters! {
                objectClass[parameter.0] = parameter.1
            }
        }
        
        objectClass.saveInBackgroundWithBlock({ (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error))
                }
            }
        })
    }
    
    /**
    Retrieves objects from a specific class on Parse server
    */
    
    func retrievesObject(className:String, objectID:String?, parameters:[String:AnyObject]?, completion:(success:Bool, errorMesssage:String?, object:[AnyObject]?)->Void) {
        let query = PFQuery(className:className)
        
        if parameters != nil {
            for parameter in parameters! {
                query.whereKey(parameter.0, equalTo: parameter.1)
            }
        }
        
        if objectID != nil {
            query.getObjectInBackgroundWithId(objectID!, block: { (object, error) -> Void in
                if error == nil {
                    completion(success: true, errorMesssage: nil, object: [object as! AnyObject])
                } else {
                    completion(success: false, errorMesssage: getErrorMessage(error), object: nil)
                }
            })
        } else {
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    completion(success: true, errorMesssage: nil, object: objects)
                } else {
                    completion(success: false, errorMesssage: getErrorMessage(error), object: nil)
                }
                
            })
        }
    }
    
    /**
    Saves a object to local data storage
    */
    
    func saveObjectToLocalDataStorage(className:String, pinName:String, parameters:[String:AnyObject]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        let objectClass = PFObject(className: className)
        
        if parameters != nil {
            for parameter in parameters! {
                objectClass[parameter.0] = parameter.1
            }
        }
        
        objectClass.pinInBackgroundWithName(pinName, block: { (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error))
                }
            }
        })
    }
    
    /**
    Retrieves objects from local data storage
    */
    
    func retrieveObjectsFromLocalDataStorage(className:String, pinName:String, parameters:[String:AnyObject]?, completion:(success:Bool, errorMesssage:String?, result:[AnyObject]?)->Void) {
        let query = PFQuery(className: className)
        query.fromPinWithName(pinName)
        
        if parameters != nil {
            for parameter in parameters! {
                query.whereKey(parameter.0, equalTo: parameter.1)
            }
        }
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                completion(success: true, errorMesssage: nil, result: objects)
            } else {
                completion(success: false, errorMesssage: getErrorMessage(error), result: nil)
            }
        }
    }
    
    /**
    Deletes object from local data storage
    */
    
    func unpinObject(pinName:String, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        PFObject.unpinAllObjectsInBackgroundWithName(pinName, block: { (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error))
                }
            }
        })
    }
    
    /**
    Deletes object from Parse server
    */
    
    func deleteObject(object:PFObject, parameters:[String]?, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        if parameters == nil {
            object.deleteInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, errorMesssage: nil)
                    }
                } else {
                    if completion != nil {
                        completion!(success: false, errorMesssage: getErrorMessage(error))
                    }
                }
            }
        } else {
            for key in parameters! {
                object.removeObjectForKey(key)
            }
            
            object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, errorMesssage: nil)
                    }
                } else {
                    if completion != nil {
                        completion!(success: false, errorMesssage: getErrorMessage(error))
                    }
                }
            })
        }
    }
    
    /**
    Convert UIImage to PFFile so you can save it in Parse
    */
    
    func imageToPFFile(image:UIImage, withName name:String?) -> PFFile {
        let imageData = UIImageJPEGRepresentation(image, 0)!
        let imageFile: PFFile!
        if name != nil {
            imageFile = PFFile(name:name, data:imageData)
        } else {
            imageFile = PFFile(data: imageData)
        }
        return imageFile
    }
}

extension String {
    var length: Int {
        return count(self)
    }
}

public func getErrorMessage(error:NSError?) -> String {
    var errorMessage = ""
    if error != nil {
        errorMessage = error!.localizedDescription
        errorMessage.replaceRange(errorMessage.startIndex...errorMessage.startIndex, with: String(errorMessage[errorMessage.startIndex]).capitalizedString)
    } else {
        errorMessage = "Unexpected error occured. Please try again"
    }
    return errorMessage
}
