import GitHubCore
import SwiftUI
import UICore

struct UserRepositoryScreen: View {
    @Bindable var store: UserRepositoryScreenStore

    var body: some View {
        AsyncContentView(
            state: store.viewState,
            success: {
                UserRepositoryScreenContent(
                    user: store.argument.user,
                    nextPage: store.nextPage,
                    repositories: $0,
                    selectUrl: store.selectUrl,
                    onRefresh: {
                        Task { await store.refresh() }
                    },
                    onBottomReach: {
                        Task { await store.fetchNextPage() }
                    },
                    onRepositoryTap: store.selectRepository(_:),
                    onSafariDismiss: store.onSafariDismiss
                )
            },
            onAppear: {
                Task { await store.fetchFirstPage() }
            },
            onRetryTap: {
                Task { await store.fetchFirstPage() }
            }
        )
        .errorAlert(
            error: store.error,
            onDismiss: store.onErrorAlertDismiss
        )
    }
}

private struct UserRepositoryScreenContent: View {
    let user: User
    let nextPage: Page?
    let repositories: [UserRepository]
    let selectUrl: URL?

    let onRefresh: () -> Void
    let onBottomReach: () -> Void
    let onRepositoryTap: (UserRepository) -> Void
    let onSafariDismiss: () -> Void

    var body: some View {
        List {
            Section {
                UserRowView(user: user)
            }

            Section("Repository") {
                ForEach(repositories) { repository in
                    UserRepositoryRowView(
                        repository: repository,
                        onTapped: { onRepositoryTap(repository) }
                    )
                }
                
                if nextPage != nil {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .progressViewStyle(.automatic)
                        .task { onBottomReach() }
                }
            }
        }
        .navigationTitle("User")
        .listStyle(.insetGrouped)
        .refreshable { onRefresh() }
        .safariFullScreenCover(
            url: selectUrl,
            onDismiss: { onSafariDismiss() }
        )
    }
}

private struct UserRepositoryRowView: View {
    let repository: UserRepository
    let onTapped: () -> Void
    
    var body: some View {
        Button(
            action: onTapped,
            label: {
                VStack(alignment: .leading, spacing: 8) {
                    Text(repository.name)
                        .font(.headline)

                    if let description = repository.description {
                        Text(description)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }

                    HStack {
                        if let language = repository.language {
                            Text(language)
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }

                        (Text(Image(systemName: "star")) + Text("\(repository.watchersCount ?? 0)"))
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                .foregroundStyle(.black)
            }
        )
    }
}

#Preview {
    let user: User = User(
        id: 1,
        login: "User",
        reposUrl: "https://github.com/sample",
        avatarUrl: "https://placehold.jp/150x150.png"
    )
    
    let repositories: [UserRepository] = (1...10).map { id in
        UserRepository(
            id: id,
            name: "Repository\(id)",
            htmlUrl: "",
            fork: false,
            language: "Swift",
            watchersCount: id,
            description: "description\(id)"
        )
    }

    UserRepositoryScreenContent(
        user: user,
        nextPage: nil,
        repositories: repositories,
        selectUrl: nil,
        onRefresh: {},
        onBottomReach: {},
        onRepositoryTap: { _ in },
        onSafariDismiss: {}
    )
}
