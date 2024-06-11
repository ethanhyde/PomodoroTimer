import SwiftUI

struct MainMenu: View {
    @StateObject var model = TimeSelectionModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Home")
                    .padding()
                    .font(.title)
                    .bold()
                
                NavigationLink (destination: AboutPage()){
                    Text("About")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(100)
                }
                
                NavigationLink (destination: TimeSelectionView(model: model)) {
                    Text("Timer")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(100)
                }
                
                NavigationLink (destination: Todo()) {
                    Text("Tasks")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(100)
                }
            }
            
        }
    }
}






struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
