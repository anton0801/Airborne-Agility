import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var soundsEnabled: Bool {
        didSet {
            saveSettings()
        }
    }
    @Published var musicEnabled: Bool {
        didSet {
            saveSettings()
        }
    }
    
    init() {
        self.soundsEnabled = UserDefaults.standard.bool(forKey: "soundsEnabled")
        self.musicEnabled = UserDefaults.standard.bool(forKey: "musicEnabled")
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(soundsEnabled, forKey: "soundsEnabled")
        UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled")
    }
}
