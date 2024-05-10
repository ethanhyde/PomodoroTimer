import SwiftUI
import Combine

struct TimeDisplayView: View {
    @ObservedObject var model: TimeSelectionModel
    @State private var progress: CGFloat = 1.0
    @State private var timerActive = false
    @State private var remainingSeconds: Int = 0
    @State private var totalSeconds: Int = 0
    @State private var timerCancellable: AnyCancellable?

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear(duration: 1), value: progress)

            VStack {
                Text("Time Remaining")
                    .font(.title)

                Text(String(format: "%02d:%02d", model.selectedHour, model.selectedMinute))
                    .font(.largeTitle)

                if timerActive {
                    Text("\(remainingSeconds) seconds remaining")
                        .font(.headline)
                }

                Button(timerActive ? "Stop Timer" : "Start Timer") {
                    if timerActive {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }
                .padding()

//                NavigationLink(destination: TimeSelectionView(model: model)) {
//                    Text("Change Time")
//                }
//                .padding()
            }
            .padding()
        }
    }
    
    // Start timer logic
    private func startTimer() {
        remainingSeconds = model.selectedHour * 3600 + model.selectedMinute * 60
        totalSeconds = remainingSeconds
        timerActive = true
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                    self.updateProgress()
                } else {
                    self.stopTimer()
                }
            }
    }

    // Stop timer logic
    private func stopTimer() {
        timerCancellable?.cancel()
        timerActive = false
        progress = 1.0  // Reset progress
    }

    private func updateProgress() {
        progress = CGFloat(remainingSeconds) / CGFloat(totalSeconds)
    }
}

// Simulator
struct TimeDisplayView_Preview: PreviewProvider {
    static var previews: some View {
        let sampleModel = TimeSelectionModel()
        sampleModel.selectedHour = 0
        sampleModel.selectedMinute = 1  // Set to 1 minute for testing
        return TimeDisplayView(model: sampleModel)
    }
}
