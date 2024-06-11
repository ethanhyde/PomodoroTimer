import SwiftUI
import Combine

struct TimeDisplayView: View {
    @ObservedObject var model: TimeSelectionModel
    @State private var progress: CGFloat = 1.0
    @State private var timerActive = false
    @State private var remainingSeconds: Int = 0
    @State private var totalSeconds: Int = 0
    @State private var timerCancellable: AnyCancellable?
    @State private var isBreakTime = false     // True when on short break
    @State private var isLongBreakTime = false // True when on long break
    @State private var counter: Int = 0 // When 4, long break starts
    @State private var isPaused = false

    var body: some View {
            VStack {
                Text(timerActive ? "Focus!" : "Tap start to begin")
                    .frame(maxWidth: .infinity, alignment: .top)
                    .font(.title2)
                    .padding(.top)

                    Spacer()

                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                        .padding()
                    
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(isLongBreakTime ? Color.green : (isBreakTime ? Color.orange : Color.blue))
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.linear(duration: 1), value: progress)
                        .padding()
                    
                    VStack {
                        Text("Time Remaining")
                            .font(.title)
                        
                        if timerActive {
                            let minutes = remainingSeconds / 60
                            let seconds = remainingSeconds % 60
                            Text(String(format: "%02d:%02d", minutes, seconds))
                                .font(.largeTitle)
                        }
                        
                        Text("Sessions Completed: \(counter)")
                            .padding(8)
                            .font(.title3)
                        
                        // Pause button
                        if timerActive {
                            Button(isPaused ? "Resume Timer" : "Pause Timer") {
                                pause()
                            }
                            .font(.body)
                            .padding(8)
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .cornerRadius(100)
                        }
                        
                        Button(timerActive ? "Reset Timer" : (isBreakTime ? "Start Break" : (isLongBreakTime ? "Start Long Break" : "Start Timer"))) {
                            handleButtonAction()
                        }
                        .font(.body)
                        .padding(8)
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(100)
                    
                        
                        NavigationLink(destination: Todo()) {
                            Text("Todo Page")
                                .font(.body)
                                .padding(8)
                                .background(Color.gray)
                                .foregroundColor(.black)
                                .cornerRadius(100)
                                
                        }
                        
                    }
                    .padding()
                }
                Spacer()
                
                // Skip button
                Button(action: skip) {
                    Text("Skip")
                        .font(.body)
                        .padding(8)
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(100)
                }
            }
        }
    // Skip ahead button
    private func skip() {
        stopTimer()
        
        if isBreakTime {
            // End current break and start a new work session
            isBreakTime = false
        } else if isLongBreakTime {
            // End long break and start a new work session
            isLongBreakTime = false
            counter = 0 // Reset counter after long break
        } else {
            // Skip current work session and go to the next break
            if counter < 3 {
                counter += 1
                isBreakTime = true
            } else {
                counter = 0
                isLongBreakTime = true
            }
        }
    }

    private func handleButtonAction() {
        if timerActive {
            stopTimer()
        } else {
            if isBreakTime {
                startBreak()
            } else if isLongBreakTime {
                startLongBreak()
            } else {
                startTimer()
            }
        }
    }

    // Starts timer
    private func startTimer() {
        setTimer(isBreak: false, isLongBreak: false, duration: model.selectedHour * 3600 + model.selectedMinute * 60)
    }

    // Starts short break
    private func startBreak() {
        setTimer(isBreak: true, isLongBreak: false, duration: model.selectedShortBreak * 60)
    }
    
    // Starts long break
    private func startLongBreak() {
        setTimer(isBreak: false, isLongBreak: true, duration: model.selectedLongBreak * 60)
    }
    
    // Sets the timer and breaks up
    private func setTimer(isBreak: Bool, isLongBreak: Bool, duration: Int) {
        isBreakTime = isBreak
        isLongBreakTime = isLongBreak
        remainingSeconds = duration
        totalSeconds = duration
        timerActive = true
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.timerTick()
            }
    }
    
    // Ticking function and break logic
    private func timerTick() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            updateProgress()
        } else {
            stopTimer()
        }
    }
    
    // Stops timer
    private func stopTimer() {
        timerCancellable?.cancel()
        timerActive = false
        progress = 1.0  // Reset progress
    }

    // Updates
    private func updateProgress() {
        progress = CGFloat(remainingSeconds) / CGFloat(totalSeconds)
    }
    
    // Pause resume function
    private func pause() {
        if isPaused {
            if timerActive {
                timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                    .sink { _ in
                        self.timerTick()
                    }
                isPaused = false
            }
        }
        
        else {
            if timerActive {
                timerCancellable?.cancel()
                isPaused = true
            }
        }
    }
}

struct TimeDisplayView_Preview: PreviewProvider {
    static var previews: some View {
        let sampleModel = TimeSelectionModel()
        sampleModel.selectedHour = 0
        sampleModel.selectedMinute = 1   // Set to 1 minute for testing
        sampleModel.selectedShortBreak = 1 // Set to 1 minute for testing
        sampleModel.selectedLongBreak = 2
        return TimeDisplayView(model: sampleModel)
    }
}
