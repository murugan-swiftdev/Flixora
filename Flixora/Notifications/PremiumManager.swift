//
//  PremiumManager.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import Foundation
import Observation

@Observable
final class PremiumManager {

    static let shared = PremiumManager()

    private let premiumKey = "flixora_premium_active"

    private init() {}

    var isPremium: Bool {
        UserDefaults.standard.bool(
            forKey: premiumKey
        )
    }

    func activatePremium() {
        UserDefaults.standard.set(
            true,
            forKey: premiumKey
        )

        print("💎 Flixora Premium ACTIVATED")
    }

    func deactivatePremium() {
        UserDefaults.standard.set(
            false,
            forKey: premiumKey
        )

        print("🔒 Flixora Premium DEACTIVATED")
    }
}
