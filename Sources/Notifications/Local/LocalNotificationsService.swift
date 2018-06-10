//
// The MIT License (MIT)
//
// Copyright (c) 2018 Roman Kotov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit
import UserNotifications

open class LocalNotificationsService: NSObject, ILocalNotificationsService {
    private let keyIdentifier: String = "_identifier_"
    
    var registrationCompletion: RegistrationCompletion?
    var notificationCenter: NotificationCenter = .default
    
    // MARK: - Registration
    open func registration(completion: @escaping RegistrationCompletion) {
        let name = NSNotification.Name.init(RKILocalNotificationsServiceKeyNotificationRegistration)
        notificationCenter.addObserver(self, selector: #selector(registerResponse(_:)), name: name, object: nil)
        registrationCompletion = { [notificationCenter] error in
            notificationCenter.removeObserver(self)
            print("LocalNotificationsService registration error: \(error?.localizedDescription ?? "unknown")")
            completion(error)
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self]
                granted, error in
                guard let `self` = self else { return }
                self.registrationCompletion?(error)
            }
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    // MARK: - Schedule
    @available(iOS, deprecated: 10.0, message: "Use schedule(identifier:date:title:subtitle:body:userInfo:)")
    open func schedule(identifier: String, date: Date, body: String, userInfo: [AnyHashable: Any]) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.alertBody = body
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.userInfo = userInfo
        localNotification.userInfo?[keyIdentifier] = identifier
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    @available(iOS 10.0, *)
    open func schedule(identifier: String,
                       date: Date,
                       title: String?,
                       subtitle: String?,
                       body: String,
                       userInfo: [AnyHashable: Any]) {
        let content = UNMutableNotificationContent()
        
        if let title = title {
            content.title = title
        }
        
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }

        content.body = body
        content.userInfo = userInfo
        content.sound = UNNotificationSound.default()
        
        let componentsTypes = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        let dateComponents = Calendar.current.dateComponents(componentsTypes, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // MARK: - Cancel
    open func cancel(identifier: String) {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { request in
                let identifiers = request.filter({ $0.identifier == identifier }).map({ $0.identifier })
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            })
        } else {
            let notifications = UIApplication.shared.scheduledLocalNotifications?.filter({
                guard let id = $0.userInfo?[keyIdentifier] as? String, id == identifier else { return false }
                return true
            }) ?? []
            
            for notification in notifications {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
    }
    
    open func cancellAll() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    // MARK: - Private
    @objc
    private func registerResponse(_ notification: Notification) {
        guard let notificationSettings = notification.object as? UIUserNotificationSettings,
            notificationSettings.types == [] else {
                registrationCompletion?(nil)
                return
        }
        
        registrationCompletion?(NSError(domain: "com.rkcore.foundation.notifications.local",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Запретили доступ нотификациям"]))
    }
    
    @available(iOS 10.0, *)
    open func didReceiveNotification(response: UNNotificationResponse, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

// MARK: - UNUserNotificationCenterDelegate
@available(iOS 10, *)
extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        didReceiveNotification(response: response, completionHandler: completionHandler)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
