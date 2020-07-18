//
//  NetworkManager.swift
//  GetHospital
//
//  Created by Chaithra Shrikrishna on 16/07/20.
//  Copyright © 2020 Chaithra Shrikrishna. All rights reserved.
//

import Foundation
import Alamofire

class BaseOperation {

    var jwtToken: HTTPHeaders? {
        var headers: HTTPHeaders?
        headers = ["Content-Type": "application/json",
                   "X-Consumer-Token": "",
                   "X-Customer-Token": ""]
        return headers
    }
}

public typealias JSON = [String: Any]


class NetworkOperation<T>: BaseOperation where T: Codable {

    func performOperation (_ url: String, type: Alamofire.HTTPMethod, params: JSON? = nil, completionHandler: @escaping (NSDictionary) -> Void, failureHandler: @escaping (Alamofire.Result<NetworkError>) -> Void) {

        Alamofire.request(url, method: type, parameters: params, encoding: JSONEncoding.default, headers: self.jwtToken).responseData(completionHandler: { (response) in

            switch response.result {
            case .success(let data) :
                if let statusCode = response.response?.statusCode {
                    if statusCode >= 200, statusCode < 300 {
                        if !data.isEmpty {
                            do {
                                if let jsonDict = try JSONSerialization.jsonObject(with: data) as? NSDictionary {
                                    completionHandler(jsonDict)
                                }
                            } catch let error {
                                print(error)
                                failureHandler(Alamofire.Result.failure(NetworkError.incorrectDataReturned))
                            }
                        }
                    } else {
                        failureHandler(Alamofire.Result.failure(NetworkError.custom(message: "\(statusCode)")))
                    }
                }
            case .failure(let error) :
                print(error)
                failureHandler(Alamofire.Result.failure(error))
            }
        })
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
