import SwiftUI

struct DailyRewardsView: View {
    
    @Environment(\.presentationMode) var pr
    
    @EnvironmentObject var userData: UserDataMain
    
    @StateObject private var viewModel = DailyRewardsViewModel()
    @State var claimError = false
    
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
            
            ScrollView {
                VStack {
                    ForEach(viewModel.rewards, id: \.id) { reward in
                        Button {
                            if viewModel.canClaimReward() {
                                if let reward = viewModel.claimReward() {
                                    userData.money += reward.reward
                                }
                            } else {
                                claimError = true
                            }
                        } label: {
                            HStack {
                                Text("\(reward.day)")
                                    .font(.custom("Souses", size: 32))
                                    .foregroundColor(.red)
                                Text("DAY")
                                    .font(.custom("Souses", size: 24))
                                    .foregroundColor(.red)
                                Spacer()
                                
                                if !viewModel.claimedRewards.contains(where: { $0.day == reward.day }) {
                                    Text("\(reward.reward)")
                                        .font(.custom("Souses", size: 20))
                                        .foregroundColor(.red)
                                } else {
                                    Text("CLAIMED")
                                        .font(.custom("Souses", size: 20))
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.horizontal)
                            .frame(width: 350, height: 60)
                            .background(
                                Image("background_of_btn")
                                    .resizable()
                                    .frame(width: 350, height: 60)
                            )
                            .padding()
                        }
                    }
                }
            }
        }
        .background(
            Image("app_background")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $claimError) {
            Alert(title: Text("Error claim"),
                  message: Text("Reward is not available!"),
                  dismissButton: .cancel(Text("Ok")))
        }
    }
}

#Preview {
    DailyRewardsView()
        .environmentObject(UserDataMain())
}
