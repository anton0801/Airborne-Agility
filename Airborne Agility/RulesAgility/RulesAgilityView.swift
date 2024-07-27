import SwiftUI

struct RulesAgilityView: View {
    
    @Environment(\.presentationMode) var pr
    
    @EnvironmentObject var userData: UserDataMain
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    pr.wrappedValue.dismiss()
                } label: {
                    Image("close_button")
                        .resizable()
                        .frame(width: 52, height: 52)
                }
                Spacer()
                ZStack {
                    Image("balance_background")
                        .resizable()
                        .frame(width: 150, height: 52)
                    
                    Text("\(userData.money)")
                        .font(.custom("Souses", size: 24))
                        .foregroundColor(.primartTextColor)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            ZStack {
                Image("background_of_btn")
                    .resizable()
                    .frame(width: 350, height: 200)
                    .scaledToFill()
                
                Text("help the plane to pass obstacles, set records and have fun")
                    .multilineTextAlignment(.center)
                    .font(.custom("Souses", size: 32))
                    .foregroundColor(.primartTextColor)
                    .frame(width: 300)
            }
            
            Spacer()
        }
        .background(
            Image("app_background")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    RulesAgilityView()
        .environmentObject(UserDataMain())
}
