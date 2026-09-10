//
//  AuthViewModel.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import Foundation
import Observation

@Observable
final class AuthViewModel {

    // MARK: - Login

    var mobileNumber = ""

    // MARK: - OTP

    var otp = ""

    // MARK: - State

    var isLoading = false
    var errorMessage: String?

    var canContinue: Bool {
        mobileNumber.count == 10
    }

    var canVerifyOTP: Bool {
        otp.count == 6
    }

    // MARK: - Demo OTP

    let demoOTP = "123456"

    // MARK: - Session Key

    private static let loginKey =
        "flixora_is_logged_in"

    // MARK: - Login

    func sendOTP() -> Bool {

        errorMessage = nil

        let cleanedNumber = mobileNumber
            .filter { $0.isNumber }

        mobileNumber = cleanedNumber

        guard mobileNumber.count == 10 else {
            errorMessage =
                "Please enter a valid 10-digit mobile number."

            return false
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1
        ) {
            self.isLoading = false
        }

        return true
    }

    // MARK: - Verify OTP

    func verifyOTP() -> Bool {

        errorMessage = nil

        guard otp.count == 6 else {

            errorMessage =
                "Please enter the 6-digit OTP."

            return false
        }

        guard otp == demoOTP else {

            errorMessage =
                "Invalid OTP. Please try again."

            return false
        }

        saveLoginSession()

        return true
    }

    // MARK: - Save Session

    private func saveLoginSession() {

        UserDefaults.standard.set(
            true,
            forKey: Self.loginKey
        )
    }

    // MARK: - Login Status

    static var isLoggedIn: Bool {

        UserDefaults.standard.bool(
            forKey: loginKey
        )
    }

    // MARK: - Logout

    static func logout() {

        UserDefaults.standard.set(
            false,
            forKey: loginKey
        )
    }

    // MARK: - Clear Login Data

    func clearLoginData() {

        mobileNumber = ""
        otp = ""
        errorMessage = nil
        isLoading = false
    }
}
