# GitHubRepoExplorer

## **Overview**
This iOS app fetches and displays repositories for a given GitHub username using the GitHub API. The app is built using Swift and SwiftUI, following the MVVM (Model-View-ViewModel) architecture.

---

## **Features**
- Fetch and display public repositories for a GitHub user.
- Support for paginated loading of repositories.
- Filter repositories by programming language.
- View repository details, including:
  - Name
  - Description
  - Language
  - Stars
  - Forks
  - Last updated date
- Error handling for invalid usernames, API rate limits, and connectivity issues.

---

## **Project Structure**

- **`networkServices/`**: Handles API requests to GitHub, including fetching repositories and user details.
- **`model/`**: Defines the data models (`Repository`, `UserDetails`) to decode API responses.
- **`viewmodel/`**: Contains business logic and state management for paginated loading, filtering, and error handling.
- **`view/`**: Contains SwiftUI views (`RepositoryListView`, `RepositoryDetailView`, etc.) for displaying the UI.

---

## **Technologies**
- Swift 5
- SwiftUI
- Combine framework for reactive state management
- GitHub API
- MVVM architecture pattern

---
