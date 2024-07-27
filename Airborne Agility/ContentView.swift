import SwiftUI

struct ContentView: View {
    
    @StateObject var userData = UserDataMain()
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                NavigationLink(destination: PlayAgilityView()
                    .environmentObject(userData)
                    .navigationBarBackButtonHidden(true)) {
                    ZStack {
                        Image("background_of_btn")
                            .resizable()
                            .frame(width: 300, height: 60)
                        
                        Text("Play")
                            .font(.custom("Souses", size: 32))
                            .foregroundColor(.primartTextColor)
                    }
                }
                
                NavigationLink(destination: SettingsAgilityView()
                    .environmentObject(userData)
                    .navigationBarBackButtonHidden(true)) {
                    ZStack {
                        Image("background_of_btn")
                            .resizable()
                            .frame(width: 300, height: 60)
                        
                        Text("Settings")
                            .font(.custom("Souses", size: 32))
                            .foregroundColor(.primartTextColor)
                    }
                }
                
                NavigationLink(destination: DailyRewardsView()
                    .environmentObject(userData)
                    .navigationBarBackButtonHidden(true)) {
                    ZStack {
                        Image("background_of_btn")
                            .resizable()
                            .frame(width: 300, height: 60)
                        
                        Text("Daily Reward")
                            .font(.custom("Souses", size: 32))
                            .foregroundColor(.primartTextColor)
                    }
                }
                
                NavigationLink(destination: RulesAgilityView()
                    .environmentObject(userData)
                    .navigationBarBackButtonHidden(true)) {
                    ZStack {
                        Image("background_of_btn")
                            .resizable()
                            .frame(width: 300, height: 60)
                        
                        Text("Rules")
                            .font(.custom("Souses", size: 32))
                            .foregroundColor(.primartTextColor)
                    }
                }
            }
            .background(
                Image("app_background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
