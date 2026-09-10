//
//  StripeManager.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import Foundation
import StripePaymentSheet

final class StripeManager {

    static let shared = StripeManager()

    private init() {}

    func configure() {
        STPAPIClient.shared.publishableKey =
            "pk_test_yo0pdzyFz67jhYNNvQ28PcWh00w4O00nBc"

        print("✅ Flixora Stripe configured")
    }
}
