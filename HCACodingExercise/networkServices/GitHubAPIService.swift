//
//  GitHubAPIService.swift
//  HCACodingExercise
//
//  Created by Pushpahas Kuchipudi on 1/14/25.
//

import Foundation

class GitHubAPIService {
    func fetchRepositories(for user: String, page: Int = 1, completion: @escaping (Result<[Repository], APIError>) -> Void) {
        let urlString = "https://api.github.com/users/\(user)/repos?per_page=10&page=\(page)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
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
                //print("Repositories: \(repositories)")
                completion(.success(repositories))
            } catch {
                //print("Decoding Error: \(error.localizedDescription)")
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}

