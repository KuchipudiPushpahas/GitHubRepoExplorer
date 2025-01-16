//
//  Repository.swift
//  HCACodingExercise
//
//  Created by Pushpahas Kuchipudi on 1/14/25.
//

import Foundation

struct Repository: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let owner: Owner
    let updatedAt: String
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case owner
        case updatedAt = "updated_at"
    }
}

struct Owner: Codable, Equatable {
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
    }
}
