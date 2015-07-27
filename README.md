# ParseHelper

A light-weight wrapper for Parse

# Install

Copy the ParseHelper.swift file into your Xcode Project

Then in your AppDelegate.swift file under didFinishLaunchingWithOptions add

    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    Parse.enableLocalDatastore()
 
    // Initialize Parse.
    Parse.setApplicationId("YOUR PARSE APP ID", clientKey: "YOUR PARSE CLIENT KEY")

**If you want to use Facebook or Twitter**

    // Facebook
    // Go to https://parse.com/docs/ios/guide#users-facebook-users to help setup Facebook with Parse
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    
    // Twitter 
    // Go to https://parse.com/docs/ios/guide#users-twitter-users to help setup Twitter with Parse
    PFTwitterUtils.initializeWithConsumerKey("YOUR CONSUMER KEY",  consumerSecret:"YOUR CONSUMER SECRET")
    
# Usage

**First create an instance of ParseHelper:**

**Make the parseHelper instance as a global variable so you don't have to create it over and over again**

    let parseHelper = ParseHelper.sharedInstance

**Log a user in**

    parseHelper.logInUser("example@email.com", password: "password") { (success, errorMesssage) -> Void in
            // Handle Error
        }
        
**Create a new user**

    parseHelper.createUser("example@email.com", password: "password", confirmPassword: "confirmPassword", parameters: ["fullName":"Example Name"]) { (success, errorMesssage) -> Void in
            // Handle Error
        }
        
**Send reset password email**

    parseHelper.sendForgotPasswordEmail("example@email.com", completion: { (success, errorMesssage) -> Void in
            // Handle Error
        })
        
**Log user in via Facebook with Read Permissions**

    parseHelper.loginUserUsingFacebookReadPermissions(permissions, completion: { (success, errorMesssage) -> Void in
            // Handle Error
        })
        

**Log user in via Facebook with Write Permissions**

    parseHelper.loginUserUsingFacebookWritePermissions(permissions, completion: { (success, errorMesssage) -> Void in
            // Handle Error
        })
        
**Log user in via Twitter**

    parseHelper.loginUserUsingTwitter { (success, errorMesssage) -> Void in
            // Handle Error
        }
        
**Link user to Facebook with Read Permissions**

    parseHelper.linkFacebookToUserUsingReadPermissions(permissions, completion: { (success, errorMesssage) -> Void in
            // Handle Error
        })
        
**Link user to Facebook with Write Permissions**

    parseHelper.linkFacebookToUserUsingWritePermissions(permissions, completion: { (success, errorMesssage) -> Void in
            // Handle Error
        })
        
**Link user to Twitter**

    parseHelper.linkTwitterToUser { (success, errorMesssage) -> Void in
            // Handle Error
        }
