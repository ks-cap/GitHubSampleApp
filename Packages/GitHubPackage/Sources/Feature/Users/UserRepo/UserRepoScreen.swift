import Domain
import Entity
import SwiftUI
import UICore

package struct UserRepoScreen: View {
    @Bindable var store: UserRepoScreenStore

    package init(store: UserRepoScreenStore) {
        self.store = store
    }

    package var body: some View {
        AsyncContentView(
            state: store.viewState,
            success: {
                UserRepoScreenContent(
                    user: store.argument.user,
                    nextPage: store.nextPage,
                    repos: $0,
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

private struct UserRepoScreenContent: View {
    let user: User
    let nextPage: Page?
    let repos: [UserRepo]
    let selectUrl: URL?

    let onRefresh: () -> Void
    let onBottomReach: () -> Void
    let onRepositoryTap: (UserRepo) -> Void
    let onSafariDismiss: () -> Void

    var body: some View {
        List {
            Section {
                UserRowView(user: user)
            }

            Section("Repository") {
                ForEach(repos) { repo in
                    UserRepoRowView(
                        repository: repo,
                        onTapped: { onRepositoryTap(repo) }
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

private struct UserRepoRowView: View {
    let repository: UserRepo
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
    
    let repositories: [UserRepo] = (1...10).map { id in
        UserRepo(
            id: id,
            name: "Repository\(id)",
            htmlUrl: "",
            fork: false,
            language: "Swift",
            watchersCount: id,
            description: "description\(id)"
        )
    }

    UserRepoScreenContent(
        user: user,
        nextPage: nil,
        repos: repositories,
        selectUrl: nil,
        onRefresh: {},
        onBottomReach: {},
        onRepositoryTap: { _ in },
        onSafariDismiss: {}
    )
}
