//
//  TimeDisplayView.swift
//  Pomodoro
//
//  Created by Ethan Hyde on 5/9/24.
//

import SwiftUI

// View to display the selected hour and minute
struct TimeDisplayView: View {
    // An observed object to access the selection data
    @ObservedObject var model: TimeSelectionModel
    @State private var progress: CGFloat = 1.0

    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.yellow)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)
            
            VStack {
                Text("Time Remaining")
                    .font(.title)

                // Display the hour and minute values
                Text(String(format: "%02d:%02d", model.selectedHour, model.selectedMinute))
                    .font(.largeTitle)

                // Go back to the selection view
                NavigationLink(destination: TimeSelectionView(model: model)) {
                    Text("Change Time")
                }
                .padding()
            }
            .padding()
        }

        }
    
}

struct TimeDisplayView_Preview: PreviewProvider {
    static var previews: some View {
        // Create a sample TimeSelectionModel instance
        let sampleModel = TimeSelectionModel()
        sampleModel.selectedHour = 0  // Example hour
        sampleModel.selectedMinute = 0  // Example minute

        // Pass the sample model to the TimeSelectionView preview
        return TimeDisplayView(model: sampleModel)
    }
}
