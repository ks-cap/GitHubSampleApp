import SwiftUI

struct UsersScreen: View {
    @StateObject var store: UsersScreenStore
    
    var body: some View {        
        NavigationView {
            List {
                Section {
                    ForEach(store.users) { user in
                        UserRowView(user: user)
                    }
                    
                    if store.nextPage != nil {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .progressViewStyle(.automatic)
                            .task { await store.onReach() }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable { await store.onRefresh() }
        }
        .task { await store.onAppear() }
    }
}

private struct UserRowView: View {
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
        }
    }
}
