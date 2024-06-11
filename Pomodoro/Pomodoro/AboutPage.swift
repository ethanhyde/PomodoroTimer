import SwiftUI
import Foundation

struct AboutPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("What is the Pomodoro Technique?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("""
                        The Pomodoro method is a technique developed by Francesco Cirillo in the late 1980s, where he used a tomato shaped kitchen timer to help with his studying.
                    
                        Typically, a session will consist of four 25 minute study sessions, each immediately followed by a 5 minute break, called a "set." After the last study session, a longer 20-30 minute break is taken.
                    
                    A typical study session will work as follows:
                    
                    1) Decide on a task that has to be done.
                    2) Set the Pomodoro Timer (25 mins usually)
                    3) Work on that task
                    4) End work when the timer rings and take a short break (usually 5 minutes)
                    5) Go back to step 2 and repeat until 4 pomodoros are completed
                    6) After 4 Pomodoros are done, take a long break (25-30 minutes)
                    
                        This method helps to decrease mental fatigure, thus improving mental focus and overall productivity.
                        
                    
                    """)
                    .font(.body)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("About the Pomodoro Technique")
    }
}

struct AboutPagePreview: PreviewProvider {
    static var previews: some View {
        AboutPage()
    }
}
