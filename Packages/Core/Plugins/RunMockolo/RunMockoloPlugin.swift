import PackagePlugin

@main struct RunMockoloPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let generatedSourcePath = context.pluginWorkDirectoryURL.path().appending("GeneratedMocks.swift")

        return [
            .prebuildCommand(
                displayName: "Run mockolo",
                executable: try context.tool(named: "mockolo").url,
                arguments: [
                    "-s", context.package.directoryURL.path(),
                    "-d", generatedSourcePath,
                    "--mock-final"
                ],
                outputFilesDirectory: context.pluginWorkDirectoryURL
            ),
        ]
    }
}

