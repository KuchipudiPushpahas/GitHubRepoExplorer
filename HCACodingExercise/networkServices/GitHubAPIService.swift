//
//  GitHubAPIService.swift
//  HCACodingExercise
//
//  Created by Pushpahas Kuchipudi on 1/14/25.
//

import Foundation

class GitHubAPIService {
    
    private let token = "YOUR_PERSONAL_ACCESS_TOKEN"
    
    func fetchRepositories(for user: String, page: Int = 1, completion: @escaping (Result<[Repository], APIError>) -> Void) {
        let urlString = "https://api.github.com/users/\(user)/repos?per_page=30&page=\(page)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        if !token.isEmpty {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(.networkError(error.localizedDescription)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 403 {
                    return completion(.failure(.apiRateLimitExceeded))
                }
                if httpResponse.statusCode != 200 {
                    return completion(.failure(.networkError("Non-200 response: \(httpResponse.statusCode)")))
                }
            }
            
            do {
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                completion(.success(repositories))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    func fetchUserDetails(for user: String, completion: @escaping (Result<Int, APIError>) -> Void) {
        let urlString = "https://api.github.com/users/\(user)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        if !token.isEmpty {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(.networkError(error.localizedDescription)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 403 {
                    return completion(.failure(.apiRateLimitExceeded))
                }
                if httpResponse.statusCode != 200 {
                    return completion(.failure(.networkError("Non-200 response: \(httpResponse.statusCode)")))
                }
            }
            
            do {
                let userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                completion(.success(userDetails.publicRepos))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    struct UserDetails: Codable {
        let publicRepos: Int
        
        enum CodingKeys: String, CodingKey {
            case publicRepos = "public_repos"
        }
    }
}
