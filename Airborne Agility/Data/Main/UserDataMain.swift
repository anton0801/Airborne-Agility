import Foundation

class UserDataMain: ObservableObject {
    
    var money: Int = 0 {
        didSet {
            saveMoney()
        }
    }
    
    init() {
        money = UserDefaults.standard.integer(forKey: "money")
    }
    
    private func saveMoney() {
        UserDefaults.standard.set(money, forKey: "money")
    }
    
}
