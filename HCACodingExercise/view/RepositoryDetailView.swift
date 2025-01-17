//
//  RepositoryDetailView.swift
//  HCACodingExercise
//
//  Created by Pushpahas Kuchipudi on 1/14/25.
//

import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository
    
    var formattedDate: String {
        guard let date = ISO8601DateFormatter().date(from: repository.updatedAt) else {
            return "Unknown"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(repository.name)
                    .font(.largeTitle)
                    .bold()
                
                Text(repository.description ?? "No description available")
                    .font(.body)
                
                HStack {
                    if let language = repository.language {
                        Text("Language: \(language)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    Text("⭐ \(repository.stargazersCount)")
                        .font(.subheadline)
                    Text("🍴 \(repository.forksCount)")
                        .font(.subheadline)
                }
                
                Text("Owner: \(repository.owner.username)")
                    .font(.callout)
                    .foregroundColor(.secondary)
                Text("Last Updated: \(formattedDate)")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("Repository Details")
    }
}

