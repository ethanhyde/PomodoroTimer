import SwiftUI

// Initial ContentView to show the first selection view
struct ContentView: View {
    // Create an instance of the shared observable object
    @StateObject var model = TimeSelectionModel()

    var body: some View {
        NavigationView {
            TimeSelectionView(model: model)
        }
    }
}

// Preview provider for the initial ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
