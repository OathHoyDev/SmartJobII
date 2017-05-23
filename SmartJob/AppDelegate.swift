//
//  AppDelegate.swift
//  SmartJob
//
//  Created by SilVeriSm on 10/19/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GCMReceiverDelegate , GGLInstanceIDDelegate {

    var window: UIWindow?
    
    let isGCMSandbox = false
    // true = DEV
    // false = PROD
    
    
    //var employerID : String?
    //var employeeID : String?
    
    var employee = NSDictionary()
    var employer = NSDictionary()
    var branch = NSDictionary()
    var usercode = String()
    
    var jobAnnounceIDForNoti = String()
    var employeeIDForNoti = String()
    var employerIDForNoti = String()
    var haveNotiFromBackground = false
    
    var token = String()
    var notiKey = String()
    
    var connectedToGCM = false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/global"

    //let keychainWrapper = KeychainWrapper()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        employee = NSDictionary()
        employer = NSDictionary()
        branch = NSDictionary()
        usercode = ""
        
        // Override point for customization after application launch.
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        
        print("gcmSenderID : \(gcmSenderID)")
        
        // [END_EXCLUDE]
        // Register for remote notifications
        if #available(iOS 8.0, *) {
            print("registerForRemoteNotifications ios 8")
            let types:UIUserNotificationType = ([.alert, .sound, .badge])
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            //application.registerFor
        } else {
            // Fallback
            print("registerForRemoteNotifications Lower ios 8")
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }
        
        // [END register_for_remote_notifications]
        // [START start_gcm_service]
        let gcmConfig = GCMConfig.default()
        gcmConfig?.receiverDelegate = self
        GCMService.sharedInstance().start(with: gcmConfig)
        // [END start_gcm_service]
        
        return true
    }
    
    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if(registrationToken != nil && connectedToGCM) {
            GCMPubSub.sharedInstance().subscribe(withToken: self.registrationToken, topic: subscriptionTopic,
                options: nil, handler: {(error) -> Void in
                    if let error = error as? NSError {
                        // Treat the "already subscribed" error more gently
                        if error.code == 3001 {
                            print("Already subscribed to \(self.subscriptionTopic)")
                        } else {
                            print("Subscription failed: \(error.localizedDescription)");
                        }
                    } else {
                        self.subscribedToTopic = true;
                        NSLog("Subscribed to \(self.subscriptionTopic)");
                    }
            })
        }
    }
    
    // [START connect_gcm_service]
    func applicationDidBecomeActive( _ application: UIApplication) {
        print("applicationDidBecomeActive")
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        if self.connectedToGCM == false {
        // Connect to the GCM server to receive non-APNS notifications
            GCMService.sharedInstance().connect(handler: {
                (error) -> Void in
                if error != nil {
                    print("Could not connect to GCM: \(error?.localizedDescription)")
                } else {
                    self.connectedToGCM = true
                    print("Connected to GCM")
                    // [START_EXCLUDE]
                    self.subscribeToTopic()
                    // [END_EXCLUDE]
                }
            })
        }else{
            print("Already Connected to GCM")
        }
    }
    // [END connect_gcm_service]
    
    // [START disconnect_gcm_service]
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        GCMService.sharedInstance().disconnect()
        // [START_EXCLUDE]
        self.connectedToGCM = false
        // [END_EXCLUDE]
    }
    // [END disconnect_gcm_service]
    
    // [START receive_apns_token]
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: Data ) {
            // [END receive_apns_token]
            // [START get_gcm_reg_token]
            // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
            let instanceIDConfig = GGLInstanceIDConfig.default()
            instanceIDConfig?.delegate = self
            // Start the GGLInstanceID shared instance with that config and request a registration
            // token to enable reception of notifications
            GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
            registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken as AnyObject,
                kGGLInstanceIDAPNSServerTypeSandboxOption:isGCMSandbox as AnyObject]
        
            GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                             scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
        
        // [END get_gcm_reg_token]
            print("deviceToken : \(deviceToken)")
            token = "\(deviceToken)"
    }
    
    // [START receive_apns_token_error]
    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: Error ) {
            print("Registration for remote notification failed with error: \(error.localizedDescription)")
            // [END receive_apns_token_error]
            let userInfo = ["error": error.localizedDescription]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: registrationKey), object: nil, userInfo: userInfo)
    }
    
    // [START ack_message_reception]
    func application( _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
            print("Notification received foreground : \(userInfo)")
            // This works only if the app started the GCM service
            GCMService.sharedInstance().appDidReceiveMessage(userInfo);
            // Handle the received message
            // [START_EXCLUDE]
            print("messageKey : \(messageKey)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: messageKey), object: nil,                userInfo: userInfo)
            // [END_EXCLUDE]
    }
    
    
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("didReceiveLocalNotification")

        let logoImage = UIImage(named: "share_icon")! as UIImage
        
        let activeVc = UIApplication.shared.keyWindow?.rootViewController
        
        let userType = UserDefaults.standard.value(forKey: "userType") as? String
        
        TSMessage.showNotification(in: activeVc, title: notification.alertTitle, subtitle: notification.alertBody, image: logoImage, type: TSMessageNotificationType.message , duration: 0 , callback: nil, buttonTitle: "ดูรายละเอียด", buttonCallback: { (action) in
            
            
            if userType == "Employee" {
                
                let rootViewController = self.window!.rootViewController as! UINavigationController
                
                let controllerArray = rootViewController.viewControllers
                
                if controllerArray[controllerArray.count-1].isKind(of: JobDetailForApplyViewController.self) ||
                    controllerArray[controllerArray.count-1].isKind(of: JobDetailViewController.self) {
                        self.haveNotiFromBackground = true
                    rootViewController.popViewController(animated: false)
                }else{
                    self.haveNotiFromBackground = false
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let jobDetailForApplyViewController = mainStoryboard.instantiateViewController(withIdentifier: "JobDetailForApplyViewController") as! JobDetailForApplyViewController
                    
                    let jobDetail = self.getJobDetail(self.jobAnnounceIDForNoti, AndEmployeeID: self.employeeIDForNoti)
                    
                    jobDetailForApplyViewController.jobDetail = jobDetail
                    jobDetailForApplyViewController.haveMessage = true
                    
                    
                    rootViewController.show(jobDetailForApplyViewController, sender: nil)
                }
            
            }else{
                
                let rootViewController = self.window!.rootViewController as! UINavigationController
                
                let controllerArray = rootViewController.viewControllers
                
                if controllerArray[controllerArray.count-1].isKind(of: EmployeeDetailViewController.self) {
                        self.haveNotiFromBackground = true
                    
                    rootViewController.popToViewController(controllerArray[controllerArray.count - 3], animated: false);
                    
                }else{
                    self.haveNotiFromBackground = false
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let employeeDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "EmployeeDetailViewController") as! EmployeeDetailViewController
                    
                    let resp = self.getEmployeeDetail(withEmployeeID: self.employeeIDForNoti)
                    if resp["RespBody"] != nil {
                        
                        let respArray = resp["RespBody"] as! NSMutableArray
                        employeeDetailViewController.employee = respArray.object(at: 0) as! NSDictionary
                    }

                    
                    employeeDetailViewController.jobAnnounceID = self.jobAnnounceIDForNoti
                    employeeDetailViewController.haveMessage = true
                    
                    rootViewController.show(employeeDetailViewController, sender: nil)
                }
                
            }
            

            
            }, at: TSMessageNotificationPosition.top , canBeDismissedByUser: true)
        
        
    }
    
    func application( _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler handler: @escaping (UIBackgroundFetchResult) -> Void) {
            print("Notification received fetchCompletionHandler: \(userInfo)")
            // This works only if the app started the GCM service
            GCMService.sharedInstance().appDidReceiveMessage(userInfo);
            // Handle the received message
            // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
            // [START_EXCLUDE]
            print("messageKey : \(messageKey)")
            
            let message = userInfo["gcm.notification.message"] as! String
            print("gcm.notification.message : \(message)")
            getMessageAndShowJob(message)
            
            if (application.applicationState == UIApplicationState.active ) {
                print("UIApplicationState.Active")
                
                let localNotification:UILocalNotification = UILocalNotification()
                localNotification.alertTitle = "คุณได้รับข้อความใหม่"
                localNotification.alertBody = "คุณได้รับข้อความใหม่จากระบบ Smart Job Center"
                localNotification.fireDate = Date(timeIntervalSinceNow: 1)
                UIApplication.shared.scheduleLocalNotification(localNotification)
                
            }else{
            
                print("Get Message from Noti")
                
                
                // [END_EXCLUDE]
                
                haveNotiFromBackground = true
                
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: messageKey), object: nil,
                userInfo: userInfo)
            handler(UIBackgroundFetchResult.noData);
    }
    // [END ack_message_reception]
    
    
    
    func getMessageAndShowJob(_ notiMessage : String){
        
        let messageArray = notiMessage.components(separatedBy: "&")
        
        let jobIDArray = messageArray[1].components(separatedBy: "=")
        self.jobAnnounceIDForNoti = jobIDArray[1]
        
        let employeeArray = messageArray[2].components(separatedBy: "=")
        self.employeeIDForNoti = employeeArray[1]
        
        if messageArray.count == 4 {
            let employerArray = messageArray[3].components(separatedBy: "=")
            self.employerIDForNoti = employerArray[1]
        }
        
    }
    
    
    
    func registrationHandler(_ registrationToken: String?, error: Error?) {
        if (registrationToken != nil) {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
            notiKey = registrationToken!
        } else {
            print("Registration to GCM failed with error: \(error?.localizedDescription)")
            let userInfo = ["error": error?.localizedDescription]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
        }
    }
    
    // [START on_token_refresh]
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
            scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    // [END on_token_refresh]
    
    // [START upstream_callbacks]
    func willSendDataMessage(withID messageID: String!, error: NSError!) {
        if (error != nil) {
            // Failed to send the message.
        } else {
            // Will send message, you can save the messageID to track the message
        }
    }
    
    func didSendDataMessage(withID messageID: String!) {
        // Did successfully send message identified by messageID
    }
    // [END upstream_callbacks]
    
    func didDeleteMessagesOnServer() {
        // Some messages sent to this device were deleted on the GCM server before reception, likely
        // because the TTL expired. The client should notify the app server of this, so that the app
        // server can resend those messages.
    }
    
    func getJobDetail(_ jobAnnounceID : String , AndEmployeeID employeeID : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        let employeeHelper = EmployeeHelper()
        
        var jobDetail = NSDictionary()
        
        do {
            
            try resp = employeeHelper.getJobDetail(jobAnnounceID, AndEmployeeID: employeeID)
            
            if resp["RespBody"] != nil {
                
                let respArray = resp["RespBody"] as! NSMutableArray
                jobDetail = respArray.object(at: 0) as! NSDictionary
                
            }
            
        }catch {
            
            return NSDictionary()
            
        }
        
        return jobDetail
        
    }
    
    func getEmployeeDetail(withEmployeeID employeeID : String) -> NSDictionary {
        
        var resp = NSDictionary()
        
        let employeeHelper = EmployeeHelper()
        
        do {
            
            try resp =  employeeHelper.getEmployeeDetail(withEmployeeID: employeeID)
            
            return resp
        }catch {
            
            return NSDictionary()
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //smartjob://jobannounceid/72437
        
        //let userType = NSUserDefaults.standardUserDefaults().valueForKey("userType") as? String
        
        //if userType == "Employee" || userType == nil {
        
        print("URL : \(url)")
        
        let url = "\(url)"
        
        self.jobAnnounceIDForNoti = url.replacingOccurrences(of: "smartjob://jobannounceid/", with: "")
        
        let rootViewController = self.window!.rootViewController as! UINavigationController
        
        let controllerArray = rootViewController.viewControllers
        
        print("controllerArray.count : \(controllerArray.count)")
            
        if controllerArray.count > 0 && ( controllerArray[controllerArray.count-1].isKind(of: JobDetailForApplyViewController.self) ||
            controllerArray[controllerArray.count-1].isKind(of: JobDetailViewController.self)) {
                self.haveNotiFromBackground = true
                rootViewController.popViewController(animated: false)
        }else{
            self.haveNotiFromBackground = true
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let jobDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "JobDetailViewController") as! JobDetailViewController
            
            let jobDetail = self.getJobDetail(self.jobAnnounceIDForNoti, AndEmployeeID: "")
            
            jobDetailViewController.jobDetail = jobDetail
            
            rootViewController.show(jobDetailViewController, sender: nil)
        }
            
        //}
        
        return true
    }


}

extension UIView {
    
    func addDashedBorder(size : CGSize , color : UIColor) {
        
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = size
        let shapeRect = CGRect(x: 3, y: 3, width: frameSize.width - 6 , height: frameSize.height - 6)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [3,2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
        
}

extension UITextView {
    
    func setPaddingPoints(_ amount:CGFloat){
        self.textContainerInset = UIEdgeInsetsMake(amount, amount, amount, amount)
    }
    
    
    func setFontSize() {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            self.font = UIFont(name: ServiceConstant.FONT_NAME, size: ServiceConstant.IPAD_FONT_SIZE)
            
        }else{
            
            self.font = UIFont(name: ServiceConstant.FONT_NAME, size: ServiceConstant.IPHONE_FONT_SIZE)
            
            
        }
        
    }
}

extension UILabel {
    
    func setFontSize() {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            self.font = UIFont(name: ServiceConstant.FONT_NAME, size: ServiceConstant.IPAD_FONT_SIZE)
            
        }else{
            
            self.font = UIFont(name: ServiceConstant.FONT_NAME, size: ServiceConstant.IPHONE_FONT_SIZE)
            
            
        }
        
    }
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setFontSize() {
    
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            self.font = UIFont(name: ServiceConstant.FONT_NAME, size: ServiceConstant.IPAD_FONT_SIZE)
            
        }else{
            
            self.font = UIFont(name: ServiceConstant.FONT_NAME, size: ServiceConstant.IPHONE_FONT_SIZE)
            
            
        }
    
    }
}

extension UIButton {
    
    func setFontSize() {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            self.titleLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: ServiceConstant.IPAD_FONT_SIZE)!
            
        }else{
            
            self.titleLabel?.font = UIFont(name: ServiceConstant.FONT_NAME, size: ServiceConstant.IPHONE_FONT_SIZE)!
            
            
        }
        
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

