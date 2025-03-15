//
//  ContentView.swift
//  Example
//
//  Created by Alper Tekin on 15.03.2025.
//

import SwiftUI
import Setgreet

struct ContentView: View {
    @AppStorage("flowId") private var flowId: String = ""
    @State private var errorMessage: String = ""
    
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
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
