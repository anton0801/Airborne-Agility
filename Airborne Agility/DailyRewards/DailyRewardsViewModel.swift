import Foundation
import Combine

struct Reward: Identifiable, Codable {
    let id = UUID()
    let day: Int
    let reward: Int
}

class DailyRewardsViewModel: ObservableObject {
    
    @Published var currentDay: Int = 0
    @Published var lastClaimTime: Date?
    @Published var rewardClaimedToday: Bool = false
    @Published var nextRewardTime: String = ""
    @Published var claimedRewards: [Reward] = []
    
    let rewards: [Reward] = [
        Reward(day: 1, reward: 2000),
        Reward(day: 2, reward: 3000),
        Reward(day: 3, reward: 4000),
        Reward(day: 4, reward: 5000),
        Reward(day: 5, reward: 6000),
        Reward(day: 6, reward: 7000),
        Reward(day: 7, reward: 10000)
    ]
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadRewardData()
        updateNextRewardTime()
        
        $lastClaimTime
            .sink { [weak self] _ in
                self?.updateNextRewardTime()
            }
            .store(in: &cancellables)
    }
    
    func canClaimReward() -> Bool {
        guard let lastClaimTime = lastClaimTime else {
            return true
        }
        let elapsedTime = Date().timeIntervalSince(lastClaimTime)
        return elapsedTime >= 86400
    }
    
    func claimReward() -> Reward? {
        if !canClaimReward() {
            return nil
        }
        
        if currentDay >= rewards.count {
            return nil
        }
        
        lastClaimTime = Date()
        let reward = rewards[currentDay]
        currentDay += 1
        rewardClaimedToday = true
        claimedRewards.append(reward)
        saveRewardData()
        updateNextRewardTime()
        
        return reward
    }
    
    func resetRewards() {
        currentDay = 0
        lastClaimTime = nil
        rewardClaimedToday = false
        claimedRewards.removeAll()
        saveRewardData()
    }
    
    private func updateNextRewardTime() {
        guard let lastClaimTime = lastClaimTime else {
            nextRewardTime = "Reward is available now."
            return
        }
        let nextRewardDate = Calendar.current.date(byAdding: .day, value: 1, to: lastClaimTime)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        nextRewardTime = "Next reward available at: \(dateFormatter.string(from: nextRewardDate))"
    }
    
    
    private func saveRewardData() {
        UserDefaults.standard.set(currentDay, forKey: "currentDay")
        UserDefaults.standard.set(lastClaimTime, forKey: "lastClaimTime")
        
        if let encoded = try? JSONEncoder().encode(claimedRewards) {
            UserDefaults.standard.set(encoded, forKey: "claimedRewards")
        }
    }
    
    private func loadRewardData() {
        currentDay = UserDefaults.standard.integer(forKey: "currentDay")
        lastClaimTime = UserDefaults.standard.object(forKey: "lastClaimTime") as? Date
        
        if let savedRewards = UserDefaults.standard.object(forKey: "claimedRewards") as? Data {
            if let decodedRewards = try? JSONDecoder().decode([Reward].self, from: savedRewards) {
                claimedRewards = decodedRewards
            }
        }
    }
    
}
