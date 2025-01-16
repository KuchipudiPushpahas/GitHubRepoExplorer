//
//  APIError.swift
//  HCACodingExercise
//
//  Created by Pushpahas Kuchipudi on 1/14/25.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case invalidURL
    case noData
    case networkError(String)
    case apiRateLimitExceeded
    case decodingError

    var description: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .noData:
            return "No data available. Please check your internet connection."
        case .networkError(let message):
            return "Network error: \(message)"
        case .apiRateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .decodingError:
            return "Error parsing data from the server. Please try again."
        }
    }
}

