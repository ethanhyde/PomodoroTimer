import SwiftUI
import Combine

struct TimeDisplayView: View {
    @ObservedObject var model: TimeSelectionModel
    @State private var progress: CGFloat = 1.0
    @State private var timerActive = false
    @State private var remainingSeconds: Int = 0
    @State private var totalSeconds: Int = 0
    @State private var timerCancellable: AnyCancellable?
    @State private var isBreakTime = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(isBreakTime ? Color.orange : Color.blue) // Changes if break is active
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear(duration: 1), value: progress)
                
            VStack {
                Text("Time Remaining")
                    .font(.title)

                if timerActive {
                    let minutes = remainingSeconds / 60
                    let seconds = remainingSeconds % 60
                    Text(String(format: "%02d:%02d", minutes, seconds))
                        .font(.largeTitle)
                }

                Button(timerActive ? "Stop Timer" : (isBreakTime ? "Start Break" : "Start Timer")) {
                    if timerActive {
                        stopTimer()
                    }
                    else {
                        if isBreakTime {
                            startBreak()
                        }
                        else {
                            startTimer()
                        }
                    }
                }
                .padding()
            }
            .padding()
        }
        .padding()
        
    }
    
    // Start timer logic
    private func startTimer() {
        isBreakTime = false
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
                    self.isBreakTime = true // User starts break, changes color
                }
            }
    }
    
    // Short break timer
    private func startBreak() {
        isBreakTime = true
        remainingSeconds = model.selectedShortBreak * 60
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
        isBreakTime = false
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
        sampleModel.selectedMinute = 1     // Set to 1 minute for testing
        sampleModel.selectedShortBreak = 1 // Set to 1 minute for testing
        return TimeDisplayView(model: sampleModel)
    }
}
