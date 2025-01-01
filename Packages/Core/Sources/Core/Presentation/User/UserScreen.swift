import SwiftUI

struct UserScreen: View {
    @StateObject var store: UserScreenStore
    
    var body: some View {
        List {
            Section {
                UserRowView(user: store.user)
            }

            Section("Repository") {
                ForEach(store.repositories) { repository in
                    UserRepositoryRowView(
                        repository: repository,
                        onTapped: {
                            store.onOpen(repository.htmlUrl)
                        }
                    )
                }
                
                if store.nextPage != nil {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .progressViewStyle(.automatic)
                        .task { await store.onReach() }
                }
            }
        }
        .navigationTitle(store.user.login)
        .listStyle(.insetGrouped)
        .task { await store.onAppear() }
        .fullScreenCover(isPresented: $store.isSafariPresented) {
            if let url = store.url {
                SafariView(url: url)
            }
        }
    }
}

struct UserRepositoryRowView: View {
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
