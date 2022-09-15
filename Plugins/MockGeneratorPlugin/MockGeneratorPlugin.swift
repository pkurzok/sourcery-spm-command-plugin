//
//  MockGenerator.swift
//
//
//  Created by Peter Kurzok on 29.06.22.
//

import Foundation
import PackagePlugin

@main
struct MockGeneratorPlugin: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let configFilePath = context.package.directory.appending(subpath: ".sourcery.yml").string
        guard FileManager.default.fileExists(atPath: configFilePath) else {
            Diagnostics.error("Could not find config at: \(configFilePath)")
            return
        }

        let sourcery = try context.tool(named: "sourcery")
        let sourceryUrl = URL(fileURLWithPath: sourcery.path.string)

        try runSourceryFrom(url: sourceryUrl)
    }

    private func runSourceryFrom(url: URL) throws {
        let process = Process()
        process.executableURL = url

        process.arguments = [
            "--verbose",
            "--disableCache"
        ]

        try process.run()
        process.waitUntilExit()

        if process.terminationReason == .exit, process.terminationStatus == 0 {
            Diagnostics.remark("✅ Successfully generated Mocks 🎉")
        } else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("🛑 Sourcery invocation failed: \(problem) 🤦‍♂️")
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension MockGeneratorPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        let configFilePath = context.xcodeProject.directory.appending(subpath: ".sourcery.yml").string
        guard FileManager.default.fileExists(atPath: configFilePath) else {
            Diagnostics.error("Could not find config at: \(configFilePath)")
            return
        }

        let sourcery = try context.tool(named: "sourcery")
        let sourceryUrl = URL(fileURLWithPath: sourcery.path.string)

        try runSourceryFrom(url: sourceryUrl)
    }
}
#endif
