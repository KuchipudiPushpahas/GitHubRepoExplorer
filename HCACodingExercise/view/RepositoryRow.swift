//
//  RepositoryRow.swift
//  HCACodingExercise
//
//  Created by Pushpahas Kuchipudi on 1/14/25.
//

import SwiftUI

struct RepositoryRow: View {
    let repository: Repository

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(repository.name)
                .font(.headline)
                .foregroundColor(.blue)

            if let description = repository.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                if let language = repository.language {
                    Text(language)
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(4)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.green, lineWidth: 1))
                }

                Spacer()
                
                HStack {
                    Image(systemName: "star")
                    Text("\(repository.stargazersCount)")
                }
                .foregroundColor(.yellow)

                HStack {
                    Image(systemName: "tuningfork")
                    Text("\(repository.forksCount)")
                }
                .foregroundColor(.purple)
            }
        }
        .padding(.vertical, 8)
    }
}

