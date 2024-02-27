//
//  Settings.swift
//  BatteryWebhook
//
//  Created by Stella Luna on 12/16/23.
//

import Foundation

/**
 Constants for setting (key) names, not access to the setting/key value itself (call UserDefaults as described in Overview for that)
 
 I intend for these to be used with UserDefaults calls.
 This is in my opinion the safest option, as you can access setting/key names by constant as such:
   UserDefaults.standard.bool(forKey: BatteryWebhookSettings.ExampleServiceSettings.exampleKey)
 instead of by string:
   UserDefaults.standard.bool(forKey: "exampleServiceExampleKey")
 
 This has the following benefits:
   - Prevents typos while typing out the key name
   - Enables the use of autocomplete for key names
   - Ensures camel case naming
   - Keeps track of exactly *what* keys are used in BatteryWebhookLib
 */
public class BatteryWebhookSettings {
    public class InternalDateStorage {
        public static let savedDate = "savedDate"
    }
    
    /// Privacy settings used across all of Battery Webhook (from BatteryWebhookPkg up to client GUI apps of Battery Webhook)
    public class GlobalPrivacy {
        /// Stores the user's preference on sending their device name (as Bool)
        public static let sendDeviceName = "sendDeviceName"
        
        /// Stores the user's preference on sending their device model (as Bool)
        public static let sendDeviceModel = "sendDeviceModel"
    }
    
    /// Settings for the user's identity that are used across all of Battery Webhook (from BatteryWebhookPkg up to client GUI apps of Battery Webhook)
    public class GlobalIdentity {
        public static let userDisplayName = "userDisplayName"
        
        public static let userPronoun = "userPronoun"
        
        public static let userDeviceDisplayName = "userDeviceDisplayName"
    }
    
    /// Settings specific to the "Discord" service
    public class Discord {
        /// Contains the Webhook URL for the "Discord" service (as String)
        public static let discordWebhookUrl = "discordWebhookUrl"
    }
}
