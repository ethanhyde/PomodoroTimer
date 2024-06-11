import SwiftUI

// View to allow the user to select the hour and minute
struct TimeSelectionView: View {
    // An observed object to store the user's selection
    @ObservedObject var model: TimeSelectionModel
    
    var hours: [Int] { Array(0..<24) }   // Hours range from 0 to 23
    var minutes: [Int] { Array(0..<60) } // Minutes range from 0 to 59
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Minute selection
                VStack {
                    Text("Minute")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    // Picker to select a minute
                    Picker("Minute", selection: $model.selectedMinute) {
                        ForEach(minutes, id: \.self) { minute in
                            Text("\(minute)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
            }
            
            HStack {
                // Short break selection
                VStack {
                    Text("Short Break")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Picker for selecting short break
                    Picker("Minute", selection: $model.selectedShortBreak) {
                        ForEach(minutes, id: \.self) { minute in
                            Text("\(minute)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                VStack {
                    Text("Long Break")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    // Picker to select length of long break
                    Picker("Minute", selection: $model.selectedLongBreak) {
                        ForEach(minutes, id: \.self) { minute in
                            Text("\(minute)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            
            // Navigation to the display view
            NavigationLink(destination: TimeDisplayView(model: model)) {
                Text("Set Timer")
            }
            .padding()
        }
        .padding()
    }
}

struct TimeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample TimeSelectionModel instance
        let sampleModel = TimeSelectionModel()
        sampleModel.selectedHour = 0  // Example hour
        sampleModel.selectedMinute = 0  // Example minute

        // Pass the sample model to the TimeSelectionView preview
        return TimeSelectionView(model: sampleModel)
    }
}


