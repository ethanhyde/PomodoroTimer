import Foundation
import Combine

class TimeSelectionModel: ObservableObject {
    // Variables to hold time lengths specified by user
    @Published var selectedHour: Int = 0
    @Published var selectedMinute: Int = 0
    @Published var selectedShortBreak: Int = 0
    @Published var selectedLongBreak: Int = 0
}


