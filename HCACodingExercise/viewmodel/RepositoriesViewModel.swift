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
    @Published private(set) var totalPageCount: Int = 1
    @Published private(set) var totalRepos: Int = 0
    
    private let pageSize = 30
    private var cancellables = Set<AnyCancellable>()
    
    var languages: [String] {
        let allLanguages = allRepositories.compactMap { $0.language }
        let uniqueLanguages = Array(Set(allLanguages)).sorted()
        return ["All"] + uniqueLanguages
    }
    
    func fetchTotalRepos(for user: String, completion: @escaping () -> Void) {
        GitHubAPIService().fetchUserDetails(for: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let totalRepos):
                    self?.totalRepos = totalRepos
                    self?.totalPageCount = (totalRepos + self!.pageSize - 1) / self!.pageSize
                case .failure(let error):
                    self?.handleError(error)
                }
                completion()
            }
        }
    }
    
    func loadRepositories(for user: String, page: Int? = nil, completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        let pageToLoad = page ?? currentPage
        GitHubAPIService().fetchRepositories(for: user, page: pageToLoad) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let repos):
                    if repos.isEmpty && pageToLoad == 1 {
                        self?.showError = true
                        self?.errorMessage = "No repositories found for this user."
                    } else {
                        self?.repositories = repos
                        self?.allRepositories.append(contentsOf: repos)
                        self?.currentPage = pageToLoad
                    }
                case .failure(let error):
                    self?.handleError(error)
                }
                completion()
            }
        }
    }
    
    func goToPage(_ page: Int, for user: String) {
        guard page >= 1, page <= totalPageCount, page != currentPage else {
            //print("Invalid page \(page). Current page: \(currentPage)")
            return
        }
        //print("Navigation to page \(page)")
        loadRepositories(for: user, page: page) {
            //print("loaded page \(page)")
        }
    }
    
    func handleError(_ error: APIError) {
        errorMessage = error.description
        showError = true
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
