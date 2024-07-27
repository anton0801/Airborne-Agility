import SwiftUI
import SpriteKit

struct PlayAgilityView: View {
    
    @Environment(\.presentationMode) var pr
    
    @EnvironmentObject var userData: UserDataMain
    
    @State var gameOver = false
    @State var timeInGame = 0
    
    var body: some View {
        ZStack {
            SpriteView(scene: PlayAgilityScene())
                .ignoresSafeArea()
            
            if gameOver {
                lossScreen
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("to_home")), perform: { _ in
            pr.wrappedValue.dismiss()
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("plane_lose")), perform: { notification in
            guard let userInfo = notification.userInfo,
                  let time = userInfo["time"] as? Int else { return }
            timeInGame = time
            withAnimation(.linear(duration: 0.3)) {
                self.gameOver = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("save_money")), perform: { notification in
            guard let userInfo = notification.userInfo,
                  let money = userInfo["money"] as? Int else { return }
            userData.money = money
        })
    }
    
    private var lossScreen: some View {
        VStack {
            VStack {
                Text("LOSS")
                    .font(.custom("Souses", size: 32))
                    .foregroundColor(.red)
                
                ZStack {
                    Image("loss_item_background")
                        .resizable()
                        .frame(width: 200, height: 50)
                    
                    Text("\(userData.money)")
                        .font(.custom("Souses", size: 24))
                        .foregroundColor(.red)
                }
                
                ZStack {
                    Image("loss_item_background")
                        .resizable()
                        .frame(width: 200, height: 50)
                    
                    Text("\(TimeFormatter.format(seconds: timeInGame))")
                        .font(.custom("Souses", size: 24))
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button {
                    NotificationCenter.default.post(name: Notification.Name("restart_game"), object: nil)
                    withAnimation(.linear(duration: 0.3)) {
                        gameOver = false
                    }
                } label: {
                    ZStack {
                        Image("loss_item_background")
                            .resizable()
                            .frame(width: 200, height: 50)
                        
                        Image("restart")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
                
                Button {
                    pr.wrappedValue.dismiss()
                } label: {
                    ZStack {
                        Image("loss_item_background")
                            .resizable()
                            .frame(width: 200, height: 50)
                        
                        Image("home")
                            .resizable()
                            .frame(width: 28, height: 32)
                    }
                }
            }
            .frame(width: 350, height: 300)
            .background(
                Image("loss_dialog_background")
                    .resizable()
                    .frame(width: 350, height: 320)
            )
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
    PlayAgilityView()
        .environmentObject(UserDataMain())
}
