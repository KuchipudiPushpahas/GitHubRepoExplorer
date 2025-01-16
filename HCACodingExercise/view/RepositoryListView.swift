//
//  RepositoryListView.swift
//  HCACodingExercise
//
//  Created by Pushpahas Kuchipudi on 1/14/25.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel = RepositoriesViewModel()
    @State private var username: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter GitHub username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Load Repos") {
                        guard !username.isEmpty else { return }
                        viewModel.resetRepositories()
                        viewModel.loadRepositories(for: username) {}
                    }
                    .padding(.trailing)
                }
                
                if viewModel.isLoading && viewModel.repositories.isEmpty {
                    ProgressView("Loading Repositories...")
                } else {
                    List(viewModel.repositories) { repository in
                        NavigationLink(destination: RepositoryDetailView(repository: repository)) {
                            RepositoryRow(repository: repository)
                        }
                        .onAppear {
                            if viewModel.shouldLoadMore(repository: repository) {
                                viewModel.loadMoreRepositories(for: username)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Repositories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Filter") {
                        ForEach(viewModel.languages, id: \.self) { language in
                            Button(language) {
                                viewModel.filterByLanguage(language)
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}


