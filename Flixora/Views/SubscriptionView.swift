//
//  SubscriptionView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI
import StripePaymentSheet

struct SubscriptionView: View {

    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(PremiumManager.self)
    private var premiumManager

    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var paymentSuccess = false

    var body: some View {

        NavigationStack {

            ScrollView(
                .vertical,
                showsIndicators: false
            ) {

                VStack(spacing: 24) {

                    header

                    featuresSection

                    planCard(
                        title: "Monthly",
                        price: "₹149",
                        subtitle: "per month",
                        icon: "calendar",
                        isPopular: false
                    ) {
                        startPayment(
                            amount: 149,
                            planName: "Monthly"
                        )
                    }

                    planCard(
                        title: "Yearly",
                        price: "₹999",
                        subtitle: "per year",
                        icon: "calendar.badge.clock",
                        isPopular: true
                    ) {
                        startPayment(
                            amount: 999,
                            planName: "Yearly"
                        )
                    }

                    Text(
                        "Cancel anytime • Secure payments powered by Stripe"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(
                Color(.systemBackground)
                    .ignoresSafeArea()
            )
            .navigationTitle("Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button {
                        dismiss()
                    } label: {

                        Image(systemName: "xmark")
                            .font(
                                .system(
                                    size: 15,
                                    weight: .bold
                                )
                            )
                    }
                }
            }
            .alert(
                "Payment Error",
                isPresented: $showError
            ) {

                Button("OK") {
                    errorMessage = ""
                }

            } message: {

                Text(errorMessage)
            }
            .alert(
                "Payment Successful",
                isPresented: $paymentSuccess
            ) {

                Button("Continue") {
                    dismiss()
                }

            } message: {

                Text(
                    "Your Flixora Premium subscription has been activated."
                )
            }
            .overlay {

                if isLoading {
                    loadingView
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {

        VStack(spacing: 14) {

            ZStack {

                Circle()
                    .fill(
                        Color.red.opacity(0.12)
                    )
                    .frame(
                        width: 100,
                        height: 100
                    )

                Image(
                    systemName: "play.tv.fill"
                )
                .font(
                    .system(
                        size: 48,
                        weight: .bold
                    )
                )
                .foregroundStyle(.red)
            }

            Text("Unlock Flixora Premium")
                .font(
                    .system(
                        size: 28,
                        weight: .bold
                    )
                )
                .multilineTextAlignment(.center)

            Text(
                "Enjoy unlimited movies, series and live sports without limits."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 15)
        }
    }

    // MARK: - Features

    private var featuresSection: some View {

        VStack(spacing: 12) {

            featureRow(
                icon: "film.fill",
                title: "Unlimited Movies"
            )

            featureRow(
                icon: "tv.fill",
                title: "Premium Series"
            )

            featureRow(
                icon: "sportscourt.fill",
                title: "Live Sports"
            )

            featureRow(
                icon: "4k.tv.fill",
                title: "Premium Quality"
            )
        }
        .padding(18)
        .background(
            Color.gray.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }

    // MARK: - Feature Row

    private func featureRow(
        icon: String,
        title: String
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(.red)
                .frame(width: 28)

            Text(title)
                .font(
                    .subheadline.weight(.medium)
                )

            Spacer()

            Image(
                systemName:
                    "checkmark.circle.fill"
            )
            .foregroundStyle(.green)
        }
    }

    // MARK: - Plan Card

    private func planCard(
        title: String,
        price: String,
        subtitle: String,
        icon: String,
        isPopular: Bool,
        action: @escaping () -> Void
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            if isPopular {

                HStack {

                    Spacer()

                    Text("BEST VALUE")
                        .font(
                            .system(
                                size: 10,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .padding(
                            .horizontal,
                            12
                        )
                        .padding(
                            .vertical,
                            6
                        )
                        .background(
                            Color.red
                        )
                        .clipShape(
                            Capsule()
                        )
                }
            }

            HStack {

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.red)

                Text(title)
                    .font(.title3.bold())

                Spacer()
            }

            HStack(
                alignment: .firstTextBaseline,
                spacing: 6
            ) {

                Text(price)
                    .font(
                        .system(
                            size: 34,
                            weight: .bold
                        )
                    )

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {

                action()

            } label: {

                HStack {

                    Text("Subscribe Now")
                        .font(
                            .headline.weight(.bold)
                        )

                    Spacer()

                    Image(
                        systemName: "arrow.right"
                    )
                    .font(
                        .headline.weight(.bold)
                    )
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .frame(height: 54)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
            }
            .disabled(isLoading)
        }
        .padding(20)
        .background(
            Color.gray.opacity(0.08)
        )
        .overlay {

            RoundedRectangle(
                cornerRadius: 20
            )
            .stroke(
                isPopular
                    ? Color.red.opacity(0.5)
                    : Color.gray.opacity(0.12),
                lineWidth: 1
            )
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20
            )
        )
    }

    // MARK: - Loading

    private var loadingView: some View {

        ZStack {

            Color.black
                .opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 14) {

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.2)

                Text(
                    "Preparing secure payment..."
                )
                .font(
                    .subheadline.weight(.medium)
                )
                .foregroundStyle(.white)
            }
            .padding(25)
            .background(
                Color.black.opacity(0.85)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18
                )
            )
        }
    }

    // MARK: - Start Payment

    private func startPayment(
        amount: Int,
        planName: String
    ) {

        guard !isLoading else {
            return
        }

        print(
            "💳 Starting \(planName) payment: ₹\(amount)"
        )

        isLoading = true

        Task {

            do {

                let paymentSheet =
                    try await StripePaymentService.shared
                        .createPaymentSheet(
                            amountInRupees: amount
                        )

                await MainActor.run {

                    isLoading = false

                    presentPaymentSheet(
                        paymentSheet
                    )
                }

            } catch {

                await MainActor.run {

                    isLoading = false

                    errorMessage =
                        error.localizedDescription

                    showError = true

                    print(
                        "❌ Stripe error:",
                        error.localizedDescription
                    )
                }
            }
        }
    }

    // MARK: - Present Stripe

    @MainActor
    private func presentPaymentSheet(
        _ paymentSheet: PaymentSheet
    ) {

        guard
            let windowScene =
                UIApplication.shared.connectedScenes
                    .compactMap({
                        $0 as? UIWindowScene
                    })
                    .first,
            let rootViewController =
                windowScene.windows
                    .first(where: {
                        $0.isKeyWindow
                    })?
                    .rootViewController
        else {

            errorMessage =
                "Unable to present payment screen."

            showError = true

            return
        }

        var viewController =
            rootViewController

        while let presented =
                viewController.presentedViewController {

            viewController = presented
        }

        paymentSheet.present(
            from: viewController
        ) { result in

            handlePaymentResult(
                result
            )
        }
    }

    // MARK: - Payment Result

    private func handlePaymentResult(
        _ result: PaymentSheetResult
    ) {
        switch result {

        case .completed:
            print("✅ Flixora Stripe payment completed")

            premiumManager.activatePremium()
            paymentSuccess = true

        case .canceled:
            print("⚠️ Flixora payment cancelled")

        case .failed(let error):

            print("❌ Flixora payment failed")
            print("❌ Error:", error)
            print("❌ Localized:", error.localizedDescription)
            print("❌ Error type:", type(of: error))

            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
