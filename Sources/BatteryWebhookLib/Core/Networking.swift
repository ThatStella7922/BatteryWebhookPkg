//
//  Networking.swift
//
//
//  Created by Stella Luna on 12/14/23.
//

import Foundation

/**
 BatteryWebhookLib's core components for interacting with the Internet
 */
public class BatteryWebhookNetworking {
    public enum NetworkingError: Error {
        case systemError(String)
        case serverError(String)
        case generic
    }
    
    /**
     Performs an HTTP POST of JSON data to a specified URL, taking the data as an Encodable object.
     
     - Parameters:
      - sendUrl: The URL to POST to
      - dataToPost: An Encodable object that this function will encode to JSON automatically
     */
    public static func jsonPost(sendUrl: String, dataToPost: Encodable) throws {        
        var returnErr = false
        var returnErrMsg = NetworkingError.generic
        
        // prep json data
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(dataToPost)
        
        // our actual post
        let webhookURL = URL(string: sendUrl.trimmingCharacters(in: .whitespacesAndNewlines))! // create URL object from input string, cleaning it
        var request = URLRequest(url: webhookURL) // create a urlrequest object with the cleaned url as the url
        request.httpMethod = "POST" // make it a POST
        request.addValue("application/json", forHTTPHeaderField: "content-type") // inform server-side that we are sending json
        request.httpBody = jsonData // add the prepped json data as the body

        let sem = DispatchSemaphore.init(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            guard let data = data, error == nil else { // system returned an error (typically no internet)
                returnErr = true
                returnErrMsg = NetworkingError.systemError(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if responseJSON is [String: Any] { // remote server returned an error
                let jsonErrString = String(data: data, encoding: .utf8)
                returnErr = true
                returnErrMsg = NetworkingError.serverError(jsonErrString ?? "Could not decode error text")
            }
        }
        
        task.resume()
        sem.wait()
        
        if returnErr {
            throw returnErrMsg
        }
    }
}
