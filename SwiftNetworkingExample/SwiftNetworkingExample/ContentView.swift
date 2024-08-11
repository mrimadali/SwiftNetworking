//
//  ContentView.swift
//  SwiftNetworkingExample
//
//  Created by Imaad  on 8/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: Self.ViewModel
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView(viewModel: ContentView.ViewModel())
}
