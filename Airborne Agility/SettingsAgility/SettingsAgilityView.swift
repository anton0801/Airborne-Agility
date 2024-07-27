import SwiftUI

struct SettingsAgilityView: View {
    
    @Environment(\.presentationMode) var pr
    
    @EnvironmentObject var userData: UserDataMain
    
    @StateObject var viewModel = SettingsViewModel()
    
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
                    .frame(width: 350, height: 60)
                HStack {
                    Image("emoji_sounds")
                        .resizable()
                        .frame(width: 52, height: 52)
                    Text("Sounds")
                        .font(.custom("Souses", size: 20))
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button {
                        changeSoundsSettings()
                    } label: {
                        if viewModel.soundsEnabled {
                            Image("toggle_on")
                                .resizable()
                                .frame(width: 50, height: 25)
                        } else {
                            Image("toggle_off")
                                .resizable()
                                .frame(width: 50, height: 25)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(width: 350, height: 60)
            }
            
            ZStack {
                Image("background_of_btn")
                    .resizable()
                    .frame(width: 350, height: 60)
                HStack {
                    Image("emoji_music")
                        .resizable()
                        .frame(width: 52, height: 52)
                    Text("Music")
                        .font(.custom("Souses", size: 20))
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button {
                        changeMusicSettings()
                    } label: {
                        if viewModel.musicEnabled {
                            Image("toggle_on")
                                .resizable()
                                .frame(width: 50, height: 25)
                        } else {
                            Image("toggle_off")
                                .resizable()
                                .frame(width: 50, height: 25)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(width: 350, height: 60)
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
    
    private func changeSoundsSettings() {
        withAnimation(.linear(duration: 0.3)) {
            viewModel.soundsEnabled = !viewModel.soundsEnabled
        }
    }
    
    private func changeMusicSettings() {
        withAnimation(.linear(duration: 0.3)) {
            viewModel.musicEnabled = !viewModel.musicEnabled
        }
    }
    
}

#Preview {
    SettingsAgilityView()
        .environmentObject(UserDataMain())
}
