//
//  ContentView.swift
//  Example
//
//  Created by Alper Tekin on 15.03.2025.
//

import SwiftUI
import SetgreetSDK

struct ContentView: View {
    @AppStorage("flowId") private var flowId: String = ""
    @State private var errorMessage: String = ""
    @State private var eventLogs: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Setgreet")
                    .font(.largeTitle)
                    .padding(.bottom, 16)

                TextField("FlowId", text: $flowId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 16)

                Button(action: {
                    if flowId.isEmpty {
                        errorMessage = "FlowId must be filled"
                    } else {
                        errorMessage = ""
                        Setgreet.shared.showFlow(flowId: flowId)
                    }
                }) {
                    Text("Show Flow")
                }
                .padding(.bottom, 16)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 16)
                }

                if !eventLogs.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Event Logs")
                                .font(.headline)
                            Spacer()
                            Button("Clear") {
                                eventLogs.removeAll()
                            }
                            .font(.caption)
                        }

                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 2) {
                                ForEach(eventLogs.indices, id: \.self) { index in
                                    Text(eventLogs[index])
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                    }
                    .padding(.top, 16)
                }
            }
            .padding()
            .onAppear {
                setupFlowCallbacks()
            }
        }
    }

    private func setupFlowCallbacks() {
        Setgreet.shared.setFlowCallbacks { callbacks in
            callbacks
                .onFlowStarted { event in
                    addLog("Flow Started: \(event.flowId) (\(event.screenCount) screens)")
                }
                .onFlowCompleted { event in
                    addLog("Flow Completed: \(event.flowId) in \(event.durationMs)ms")
                }
                .onFlowDismissed { event in
                    addLog("Flow Dismissed: \(event.reason.rawValue) at screen \(event.screenIndex + 1)/\(event.screenCount)")
                }
                .onScreenChanged { event in
                    addLog("Screen Changed: \(event.fromIndex + 1) -> \(event.toIndex + 1)")
                }
                .onActionTriggered { event in
                    var log = "Action: \(event.actionType)"
                    if let name = event.actionName {
                        log += " (event: \(name))"
                    }
                    addLog(log)
                }
                .onPermissionRequested { event in
                    addLog("Permission: \(event.permissionType) -> \(event.result)")
                }
                .onError { event in
                    addLog("Error: \(event.errorType.rawValue) - \(event.message)")
                }
        }
    }

    private func addLog(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        eventLogs.insert("[\(timestamp)] \(message)", at: 0)
    }
}

#Preview {
    ContentView()
}
