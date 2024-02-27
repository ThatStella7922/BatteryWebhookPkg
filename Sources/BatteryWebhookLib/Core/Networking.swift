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
    enum NetworkingError: Error {
        case error(String)
    }
    
    /**
     Performs an HTTP POST of JSON data to a specified URL, taking the data as an Encodable object.
     
     - Parameters:
      - sendUrl: The URL to POST to
      - dataToPost: An Encodable object that this function will encode to JSON automatically
     */
    public static func jsonPost(sendUrl: String, dataToPost: Encodable) throws -> (err: Bool, errMsg: String) {
        //TODO: Actually throw errors instead of returning them
        
        var returnErr = false
        var returnErrMsg = ""
        
        // prep json data
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(dataToPost)
        
        // our actual post
        let webhookURL = URL(string: sendUrl.trimmingCharacters(in: .whitespacesAndNewlines))! // create URL object from input string, cleaning it
        var request = URLRequest(url: webhookURL) // create a urlrequest object with the cleaned url as the url
        request.httpMethod = "POST" // make it a POST
        request.addValue("application/json", forHTTPHeaderField: "content-type") // inform server-side that we are sending json
        request.httpBody = jsonData // add the prepped json data as the body

        let sem = DispatchSemaphore.init(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            guard let data = data, error == nil else {
                returnErr = true
                returnErrMsg = error?.localizedDescription ?? "No data"
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if responseJSON is [String: Any] {
                let jsonErrString = String(data: data, encoding: .utf8)
                returnErr = true
                returnErrMsg = jsonErrString ?? "there was an error while getting the error text"
            }
        }
        
        task.resume()
        sem.wait()
        
        return (returnErr, returnErrMsg)
    }
}
