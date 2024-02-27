//
//  SendInfo.swift
//  BatteryWebhook
//
//  Created by Stella Luna on 12/14/23.
//

import Foundation

/**
 BatteryWebhookPkg's way of sending power info to a supported service
 */
public class BatteryWebhookSendInfo {
    
    public static func sendDiscord(sendUrl: String, payload: BatteryWebhookServices.DiscordService.DiscordPayload) throws {
        do {
            try BatteryWebhookNetworking.jsonPost(sendUrl: sendUrl, dataToPost: payload)
        } catch BatteryWebhookNetworking.NetworkingError.serverError(let errorMsg) {
            // Catch only server errors, and decode them using the DiscordError struct since this is sendDiscord
            let decoded = try JSONDecoder().decode(BatteryWebhookServices.DiscordService.DiscordNetworkErrorJSON.self, from: errorMsg.data(using: .utf8)!)
            throw BatteryWebhookServices.DiscordService.DiscordNetworkError.intermediary(decoded)
        } catch {
            // sendDiscord does not handle any other error types, throw the error again to be caught
            throw error
        }
    }
}
