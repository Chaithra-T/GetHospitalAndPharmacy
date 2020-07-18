//
//  Errors.swift
//  GetHospital
//
//  Created by Chaithra Shrikrishna on 16/07/20.
//  Copyright © 2020 Chaithra Shrikrishna. All rights reserved.
//

import Foundation

public protocol ErrorResponseCodeProtocol {
    var responseCode: Int? { get }
    var isResponseSerializationError: Bool { get }
}

public enum NetworkError: Error, CustomStringConvertible {

    /// Unknown or not supported error.
    case unknown

    /// Not connected to the internet.
    case notConnectedToInternet

    /// Cannot reach the server.
    case notReachedServer

    /// Service is temporarily unavailable (status code == 503).
    case serviceUnavailable

    /// Incorrect data returned from the server.
    case incorrectDataReturned

    /// Authentication required
    case authenticationRequired

    /// Customer access token is invalid. Somebody logged in on another device.
    case invalidAccessToken

    /// Resource was not recognized
    case notRecognized

    /// Resource not found
    case resourceNotFound

    /// Request was aborted
    case aborted

    case custom(message: String)

    init(error: ErrorResponseCodeProtocol) {
        guard let responseCode = error.responseCode else {
            if error.isResponseSerializationError {
                self = .incorrectDataReturned
            } else {
                self = .unknown
            }
            return
        }

        switch responseCode {
        case 400:
            self = .notRecognized
        case 401:
            self = .authenticationRequired
        case 403:
            self = .invalidAccessToken
        case 404:
            self = .resourceNotFound
        case 500...599:
            self = .serviceUnavailable
        default:
            if error.isResponseSerializationError {
                self = .incorrectDataReturned
            } else {
                self = .unknown
            }
        }
    }

    public var title: String {
        switch self {
        case .unknown:
            return "unknown"
        case .notConnectedToInternet:
            return "No internet"
        case .notReachedServer:
            return "Server error"
        case .serviceUnavailable:
            return "service unavailable"
        case .incorrectDataReturned:
            return "Incorrect data returned"
        case .authenticationRequired:
            return "Not valid user"
        case .invalidAccessToken:
            return "Invalid Access"
        case .resourceNotFound:
            return "Resource not found"
        case .notRecognized:
            return "Not recognized"
        case .aborted:
            return "Server error"
        case .custom(let message):
            return message.isEmpty ? "Network error" : message
        }
    }

    public var description: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .notConnectedToInternet:
            return "Please check your internet connection"
        case .notReachedServer:
            return "We are facing some internal issue."
        case .serviceUnavailable:
            return "Service temporarily unavailable. Please try again later"
        case .incorrectDataReturned:
            return "Incoorect data"
        case .authenticationRequired:
            return "You are not a valid user"
        case .invalidAccessToken:
            return "Invalid Access"
        case .resourceNotFound:
            return "Resource not found"
        case .notRecognized:
            return "Not recognized"
        case .aborted:
            return "Network Error Problem"
        case .custom(let message):
            return message.isEmpty ? "Network Error Problem" : message
        }
    }

    public var localizedDescription: String {
        return description
    }
}
