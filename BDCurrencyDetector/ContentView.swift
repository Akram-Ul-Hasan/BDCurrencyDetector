//
//  ContentView.swift
//  BDCurrencyDetector
//
//  Created by Akram Ul Hasan on 1/6/25.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    let model: BDCurrencyDetector?
    
    init() {
        do {
            let config = MLModelConfiguration()
            model = try BDCurrencyDetector(configuration: config)
        } catch {
            print("Failed to load model: \(error)")
            model = nil
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
