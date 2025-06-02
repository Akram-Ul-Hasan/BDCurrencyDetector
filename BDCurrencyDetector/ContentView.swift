//
//  ContentView.swift
//  BDCurrencyDetector
//
//  Created by Akram Ul Hasan on 1/6/25.
//

import SwiftUI
import CoreML
import PhotosUI

struct ProbabilityListView: View {
    
    let probs: [Dictionary<String, Double>.Element]
    
    var body: some View {
        List(probs, id: \.key) { (key, value) in
            
            HStack {
                Text(key)
                Text(NSNumber(value: value), formatter: NumberFormatter.percentage)
            }
        }
    }
}

struct ContentView: View {
    
    let model = try! BDCurrencyDetector(configuration: MLModelConfiguration())
    @State private var probs: [String: Double] = [: ]
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var uiImage: UIImage? = UIImage(named: "500Taka")
    @State private var isCameraSelected: Bool = false
    
    var sortedProbs: [Dictionary<String, Double>.Element] {
        
        let probsArray = Array(probs)
        return probsArray.sorted { lhs, rhs in
            lhs.value > rhs.value
        }
    }
    
    var body: some View {
        
        VStack {
            
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            }
            
            HStack {
                
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Text("Select a Photo")
                }
                
                Button("Camera") {
                    isCameraSelected = true
                }.buttonStyle(.bordered)
                    
            }
            
            
            Button("Predict") {
                
                guard let resizedImage = uiImage?.resizeTo(to: CGSize(width: 299, height: 299)) else {
                    return
                }
                guard let buffer = resizedImage.toCVPixelBuffer() else { return }
                
                do {
                    let result = try model.prediction(image: buffer)
                    probs = result.targetProbability
                } catch {
                    print(error.localizedDescription)
                }
                
            }.buttonStyle(.borderedProminent)
            
            ProbabilityListView(probs: sortedProbs)
        }
        .onChange(of: selectedPhotoItem, perform: { selectedPhotoItem in
            selectedPhotoItem?.loadTransferable(type: Data.self, completionHandler: { result in
                switch result {
                    case .success(let data):
                        if let data {
                            guard let img = UIImage(data: data) else { return }
                            uiImage = img
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            })
        })

        .sheet(isPresented: $isCameraSelected, content: {
            ImagePicker(image: $uiImage, sourceType: .camera)
        })
        .padding()
    }
}


#Preview {
    ContentView()
}
