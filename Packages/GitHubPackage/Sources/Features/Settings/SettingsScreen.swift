import GitHubCore
import SwiftUI
import UICore

package struct SettingsScreen: View {
    @Bindable private var store: SettingsScreenStore

    package init(store: SettingsScreenStore) {
        self.store = store
    }

    package var body: some View {
        SettingsScreenContent(
            hasAccessToken: store.hasAccessToken,
            onSaveTap: {
                Task { await store.updateAccessToken() }
            },
            onResetTap: {
                Task { await store.updateAccessToken() }
            },
            isAccessTokenPresented: $store.isAccessTokenPresented,
            accessToken: $store.accessToken
        )
        .errorAlert(
            error: store.error,
            onDismiss: store.onErrorAlertDismiss
        )
        .task { await store.fetchAccessToken() }
    }
}

private struct SettingsScreenContent: View {
    let hasAccessToken: Bool

    let onSaveTap: () -> Void
    let onResetTap: () -> Void

    @Binding var isAccessTokenPresented: Bool
    @Binding var accessToken: String

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Access Token")
                                .font(.headline)
                            
                            Text(hasAccessToken ? "設定済み" : "未設定")
                                .font(.caption)
                        }
                    }
                }

                Section {
                    TextField("Enter new Personal Access Token", text: $accessToken)
                        .keyboardType(.asciiCapable)
                        .disableAutocorrection(true)
                }

                Section {
                    Button {
                        onSaveTap()
                    } label: {
                        Text("Save")
                            .fontWeight(.bold)
                            .padding(4)
                    }
                    .disabled(accessToken.isEmpty)
                }
                
                if hasAccessToken {
                    Section {
                        Button {
                            accessToken.removeAll()
                            onResetTap()
                        } label: {
                            Text("Reset")
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                                .padding(4)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(
                "Personal Access Token",
                isPresented: $isAccessTokenPresented,
                actions: {},
                message: {
                    Text("Updated!")
                }
            )
        }
    }
}

#Preview {
    SettingsScreenContent(
        hasAccessToken: true,
        onSaveTap: {},
        onResetTap: {},
        isAccessTokenPresented: .init(get: { false }, set: { _ in }),
        accessToken: .init(get: { "" }, set: { _ in })
    )
}
