import SwiftUI

package struct SettingsScreen: View {
    @Bindable private var store: SettingsScreenStore

    package init(store: SettingsScreenStore) {
        self.store = store
    }

    package var body: some View {
        SettingsScreenContent(
            currentAccessToken: store.currentAccessToken,
            onAppear: {
                Task { await store.fetchAccessToken() }
            },
            onSetTap: {
                Task { await store.updateAccessToken() }
            },
            draftAccessToken: store.draftAccessToken
        )
    }
}

private struct SettingsScreenContent: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction
    
    let currentAccessToken: String?
    let onAppear: () -> Void
    let onSetTap: () -> Void

    @State var draftAccessToken: String

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Set your GitHub's Personal Access Token")
                                .font(.headline)
                            
                            if let currentAccessToken = currentAccessToken, !currentAccessToken.isEmpty {
                                Text("Current: \(currentAccessToken)")
                                    .font(.caption)
                            }
                        }
                    }
                }

                Section {
                    TextField("Personal Access Token", text: $draftAccessToken)
                        .keyboardType(.asciiCapable)
                }

                Section {
                    Button {
                        onSetTap()
                        dismiss()
                    } label: {
                        Text("Set")
                            .fontWeight(.bold)
                            .padding(4)
                    }
                    .disabled(draftAccessToken.isEmpty)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear(perform: onAppear)
        }
    }
}

#Preview {
    SettingsScreenContent(
        currentAccessToken: "currentAccessToken",
        onAppear: {},
        onSetTap: {},
        draftAccessToken: "draftAccessToken"
    )
}
