//
//  YepUserDefaults.swift
//  Yep
//
//  Created by NIX on 15/3/17.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

let v1AccessTokenKey = "v1AccessToken"
let userIDKey = "userID"
let nicknameKey = "nickname"
let avatarURLStringKey = "avatarURLString"
let pusherIDKey = "pusherID"

class YepUserDefaults {

    // MARK: ReLogin

    class func userNeedRelogin() {
        let defaults = NSUserDefaults.standardUserDefaults()

        defaults.removeObjectForKey(v1AccessTokenKey)
        defaults.removeObjectForKey(userIDKey)
        defaults.removeObjectForKey(nicknameKey)
        defaults.removeObjectForKey(avatarURLStringKey)
        defaults.removeObjectForKey(pusherIDKey)


        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            if let rootViewController = appDelegate.window?.rootViewController {
                YepAlert.alert(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("User authentication error, you need to login again!", comment: ""), dismissTitle: NSLocalizedString("Relogin", comment: ""), inViewController: rootViewController, withDismissAction: { () -> Void in

                    appDelegate.startIntroStory()
                })
            }
        }
    }


    // MARK: v1AccessToken

    class func v1AccessToken() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(v1AccessTokenKey)
    }

    class func setV1AccessToken(accessToken: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(accessToken, forKey: v1AccessTokenKey)

        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            // 注册或初次登录时同步数据的好时机
            appDelegate.sync()

            // 也是注册或初次登录时启动 Faye 的好时机
            appDelegate.startFaye()
        }
    }

    // MARK: userID

    class func userID() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(userIDKey)
    }

    class func setUserID(userID: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userID, forKey: userIDKey)
    }

    // MARK: nickname

    class func nickname() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(nicknameKey)
    }

    class func setNickname(nickname: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nickname, forKey: nicknameKey)
    }

    // MARK: avatarURLString

    class func avatarURLString() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(avatarURLStringKey)
    }

    class func setAvatarURLString(avatarURLString: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(avatarURLString, forKey: avatarURLStringKey)
    }

    // MARK: pusherID

    class func pusherID() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(pusherIDKey)
    }

    class func setPusherID(pusherID: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(pusherID, forKey: pusherIDKey)

        // 注册推送的好时机
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            if appDelegate.notRegisteredPush {
                appDelegate.notRegisteredPush = false

                if let deviceToken = appDelegate.deviceToken {
                    appDelegate.registerThirdPartyPushWithDeciveToken(deviceToken, pusherID: pusherID)
                }
            }
        }
    }

}


