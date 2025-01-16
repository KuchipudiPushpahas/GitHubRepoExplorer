//
//  RepositoriesViewModel.swift
//  HCACodingExercise
//
//  Created by Pushpahas Kuchipudi on 1/14/25.
//

import Combine
import Foundation

class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published private(set) var allRepositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var filterLanguage: String = "All"
    @Published var currentPage: Int = 1
    @Published private(set) var totalPages: Int = 1
    
    private let pageSize = 10
    private var cancellables = Set<AnyCancellable>()
    
    var languages: [String] {
        let allLanguages = allRepositories.compactMap { $0.language }
        let uniqueLanguages = Array(Set(allLanguages)).sorted()
        return ["All"] + uniqueLanguages
    }
    
    func loadRepositories(for user: String, completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        GitHubAPIService().fetchRepositories(for: user, page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let repos):
                    if repos.isEmpty && self?.allRepositories.isEmpty == true {
                        self?.showError = true
                        self?.errorMessage = "No repositories found for this user."
                    } else {
                        self?.allRepositories.append(contentsOf: repos)
                        self?.filterAndUpdateRepositories()
                        self?.currentPage += 1
                    }
                case .failure(let error):
                    self?.handleError(error)
                }
                completion()
            }
        }
    }
    
    private func handleError(_ error: APIError) {
        errorMessage = error.description
        showError = true
    }
    
    
    func shouldLoadMore(repository: Repository) -> Bool {
        return repository == repositories.last
    }
    
    func loadMoreRepositories(for user: String) {
        loadRepositories(for: user) { [weak self] in
            DispatchQueue.main.async {
                if self?.repositories.isEmpty ?? true {
                    self?.errorMessage = "No more repositories to load."
                    self?.showError = true
                }
            }
        }
    }
    
    func resetRepositories() {
        allRepositories = []
        repositories = []
        currentPage = 1
        filterLanguage = "All"
    }
    
    func filterByLanguage(_ language: String) {
        guard filterLanguage != language else { return }
        filterLanguage = language
        filterAndUpdateRepositories()
    }
    
    private func filterAndUpdateRepositories() {
        if filterLanguage == "All" {
            repositories = allRepositories
        } else {
            repositories = allRepositories.filter { $0.language == filterLanguage }
        }
    }
}
