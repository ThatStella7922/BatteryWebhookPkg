//
//  BatteryWebhookServices.swift
//  BatteryWebhookCore
//
//  Created by Stella Luna on 12/11/23.
//

import Foundation

/**
 Data types and definitions of every service supported by BatteryWebhookPkg, so you can build payloads and reference service types.
 */
public class BatteryWebhookServices {
    public enum ServiceList {
        case Discord
    }
    
    /// Data types used to build payloads for the "Discord" service
    public class DiscordService {
        
        /**
         Error type for errors returned from Discord webhooks. You'll get a `code` (Int) and `message` (String)
         
         This type is used strictly for decoding responses.
         
         - Warning: You cannot catch this object, catch `DiscordNetworkError.intermediary` instead. See `DiscordNetworkError2` for more info
         */
        public struct DiscordNetworkErrorJSON: Decodable {
            public let code: Int
            public let message: String
        }
        
        /**
         Container error type for `DiscordNetworkErrorJSON`.
         
         This is required because you cannot directly catch `DiscordNetworkErrorJSON` due to error that I wasn't able to debug.
         
         `DiscordNetWorkErrorJSON` previously conformed to Error, but could not be caught in do catch statements because of the following error:
         "`Type 'BatteryWebhookServices.DiscordService.DiscordNetworkErrorJSON.Type' cannot conform to '_ErrorCodeProtocol'`".
         
         Now `DiscordNetworkErrorJSON` no longer conforms to Error, and you should catch this `DiscordNetworkError` object when catching errors returned from Discord webhooks.

         */
        public enum DiscordNetworkError: Error {
            case intermediary(DiscordNetworkErrorJSON)
        }
        
        /**
         Author block to be used in a `DiscordEmbed`
         
         Supply `name` and `icon_url` as strings.
         [View on Discord Webhooks Guide](https://birdie0.github.io/discord-webhooks-guide/structure/embed/author.html)
         */
        public struct DiscordAuthor: Encodable {
            public init(name: String? = nil, icon_url: String? = nil) {
                self.name = name
                self.icon_url = icon_url
            }
            
            var name: String?
            var icon_url: String?
        }
        
        /**
         DiscordEmbed to be used in a `DiscordMessageObj`.
         
         This object can contain a `DiscordAuthor`, `DiscordFooter`, title, decimal color value, and more. See the struct definition and the link below for more.
         
         You can supply multiple `DiscordEmbed`s in a `DiscordMessageObj` to provide multiple embeds with a single web request.
         
         [View on Discord Webhooks Guide](https://birdie0.github.io/discord-webhooks-guide/structure/embeds.html)
         */
        public struct DiscordEmbed: Encodable {
            public init(author: DiscordAuthor? = nil, footer: DiscordFooter? = nil, title: String? = nil, description: String? = nil, color: Int? = nil, fields: [DiscordEmbedField]? = nil) {
                self.author = author
                self.footer = footer
                self.title = title
                self.description = description
                self.color = color
                self.fields = fields
            }
            
            var author: DiscordAuthor?
            var footer: DiscordFooter?
            var title: String?
            var description: String?
            var color: Int?
            var fields: [DiscordEmbedField]?
        }
        
        /**
         Field block to be used in a `DiscordEmbed`
         
         [See on Discord Webhooks Guide](https://birdie0.github.io/discord-webhooks-guide/structure/embed/fields.html)
         */
        public struct DiscordEmbedField: Encodable {
            public init(name: String? = nil, value: String? = nil, inline: Bool? = nil) {
                self.name = name
                self.value = value
                self.inline = inline
            }
            
            var name: String?
            var value: String?
            var inline: Bool?
        }
        
        /**
         Footer block to be used in a `DiscordEmbed`
         
         Supply `text` and `icon_url` as strings.
         [View on Discord Webhooks Guide](https://birdie0.github.io/discord-webhooks-guide/structure/embed/footer.html)
         */
        public struct DiscordFooter: Encodable {
            public init(text: String? = nil, icon_url: String? = nil) {
                self.text = text
                self.icon_url = icon_url
            }
            
            var text: String?
            var icon_url: String?
        }
        
        /**
         A complete representation of a payload for the "Discord" service.
         
         For a successful webhook interaction with Discord you need to populate `content` with a String message at minimum.
         For more advanced interaction, make use of `embeds` by providing one or more ``DiscordEmbed``s.
        
         [View on Discord Webhooks Guide](https://birdie0.github.io/discord-webhooks-guide/discord_webhook.html)
         */
        public struct DiscordPayload: Encodable {
            public init(embeds: [DiscordEmbed]? = nil, content: String? = nil, username: String? = nil, avatar_url: String? = nil) {
                self.embeds = embeds
                self.content = content
                self.username = username
                self.avatar_url = avatar_url
            }
            
            var embeds: [DiscordEmbed]?
            var content: String?
            var username: String? // overrides the predefined username of the webhook
            var avatar_url: String? // overrides the predefined avatar of the webhook
        }
    }
}
