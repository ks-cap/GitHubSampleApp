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
            error: store.error,
            onAppear: {
                Task { await store.fetchAccessToken() }
            },
            onSaveTap: {
                Task { await store.updateAccessToken() }
            },
            onResetTap: {
                Task { await store.updateAccessToken() }
            },
            onErrorAlertDismiss: {
                Task { store.onErrorAlertDismiss() }
            },
            isAccessTokenPresented: $store.isAccessTokenPresented,
            accessToken: $store.accessToken
        )
    }
}

private struct SettingsScreenContent: View {
    let hasAccessToken: Bool
    let error: Error?

    let onAppear: () -> Void
    let onSaveTap: () -> Void
    let onResetTap: () -> Void
    let onErrorAlertDismiss: () -> Void

    @Binding var isAccessTokenPresented: Bool
    @Binding var accessToken: String

    var body: some View {
        NavigationStack {
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
            .errorAlert(
                error: error,
                onDismiss: onErrorAlertDismiss
            )
            .onAppear(perform: onAppear)
        }
    }
}

#Preview {
    SettingsScreenContent(
        hasAccessToken: true,
        error: nil,
        onAppear: {},
        onSaveTap: {},
        onResetTap: {},
        onErrorAlertDismiss: {},
        isAccessTokenPresented: .init(get: { false }, set: { _ in }),
        accessToken: .init(get: { "" }, set: { _ in })
    )
}
