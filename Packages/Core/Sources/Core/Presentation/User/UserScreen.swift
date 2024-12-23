import SwiftUI

struct UserScreen: View {
    @StateObject var store: UserScreenStore
    
    var body: some View {
        Text("\(store.user.login)")
    }
}
