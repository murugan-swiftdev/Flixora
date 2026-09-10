//
//  StripePaymentService.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import Foundation
import StripePaymentSheet

final class StripePaymentService {

    static let shared = StripePaymentService()

    private init() {}

    // MARK: - Backend

    private let paymentSheetURL = URL(
        string: "http://10.211.245.40:3000/payment-sheet"
    )!

    // MARK: - Response

    private struct PaymentSheetResponse: Decodable {

        let clientSecret: String

        enum CodingKeys: String, CodingKey {
            case clientSecret
        }
    }

    // MARK: - Create Payment Sheet

    func createPaymentSheet(
        amountInRupees: Int
    ) async throws -> PaymentSheet {

        print("💳 Flixora Payment Request")
        print("➡️ Amount: ₹\(amountInRupees)")

        let amountInPaise =
            amountInRupees * 100

        print(
            "➡️ Amount in paise: \(amountInPaise)"
        )

        var request =
            URLRequest(
                url: paymentSheetURL
            )

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let body: [String: Any] = [
            "amount": amountInPaise,
            "currency": "inr"
        ]

        request.httpBody =
            try JSONSerialization.data(
                withJSONObject: body
            )

        let (
            data,
            response
        ) =
            try await URLSession.shared.data(
                for: request
            )

        guard let httpResponse =
                response as? HTTPURLResponse
        else {
            throw StripePaymentError.invalidResponse
        }

        guard
            200...299 ~= httpResponse.statusCode
        else {

            let responseBody =
                String(
                    data: data,
                    encoding: .utf8
                )
                ?? "Unknown server error"

            print(
                "❌ Payment API status:",
                httpResponse.statusCode
            )

            print(
                "❌ Payment API response:",
                responseBody
            )

            throw StripePaymentError.serverError(
                statusCode: httpResponse.statusCode,
                message: responseBody
            )
        }

        let paymentResponse =
            try JSONDecoder().decode(
                PaymentSheetResponse.self,
                from: data
            )

        print("✅ Client secret received")

        return makePaymentSheet(
            clientSecret:
                paymentResponse.clientSecret
        )
    }

    // MARK: - Payment Sheet

    private func makePaymentSheet(
        clientSecret: String
    ) -> PaymentSheet {

        var configuration =
            PaymentSheet.Configuration()

        configuration.merchantDisplayName =
            "Flixora"

        configuration.allowsDelayedPaymentMethods =
            false

        return PaymentSheet(
            paymentIntentClientSecret:
                clientSecret,
            configuration:
                configuration
        )
    }
}

// MARK: - Error

enum StripePaymentError: LocalizedError {

    case invalidResponse

    case serverError(
        statusCode: Int,
        message: String
    )

    var errorDescription: String? {

        switch self {

        case .invalidResponse:

            return "Invalid payment server response."

        case let .serverError(
            statusCode,
            message
        ):

            return
                "Payment server error (\(statusCode)): \(message)"
        }
    }
}

