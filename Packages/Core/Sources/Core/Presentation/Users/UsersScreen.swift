import SwiftUI

struct UsersScreen: View {
    @Bindable var store: UsersScreenStore
    
    var body: some View {        
        NavigationStack {
            List {
                Section {
                    ForEach(store.users) { user in
                        NavigationLink {
                            UserBuilder.build(with: user)
                        } label: {
                            UserRowView(user: user)
                        }
                    }
                    
                    if store.nextPage != nil {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .progressViewStyle(.automatic)
                            .task { await store.fetchNextPage() }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .task { await store.fetchFirstPage() }
            .refreshable { await store.fetchFirstPage() }
            .alert(item: $store.error) {
                Alert(title: Text($0.error.localizedDescription))
            }
        }
    }
}

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(
                url:  URL(string: user.avatarUrl),
                content: { $0.resizable() },
                placeholder: { ProgressView() }
            )
            .clipShape(Circle())
            .frame(width: 28, height: 28)
            
            Text(user.login)
                .foregroundStyle(.primary)
                .font(.body)
        }
    }
}
