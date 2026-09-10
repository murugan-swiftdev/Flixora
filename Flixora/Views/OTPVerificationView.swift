//
//  OTPVerificationView.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import SwiftUI

struct OTPVerificationView: View {

    @Environment(AppRouter.self)
    private var router

    @State
    private var viewModel = AuthViewModel()

    @FocusState
    private var isOTPFocused: Bool

    @State
    private var remainingSeconds = 30

    @State
    private var timer: Timer?

    let mobileNumber: String

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {

                VStack(
                    spacing: 0
                ) {

                    // MARK: - Back

                    HStack {

                        Button {

                            router.showLogin()

                        } label: {

                            Image(
                                systemName: "chevron.left"
                            )
                            .font(.headline)
                            .foregroundStyle(.white)

                            Text("Back")
                                .foregroundStyle(.white)
                        }

                        Spacer()
                    }

                    .padding(.bottom, 50)

                    // MARK: - Icon

                    ZStack {

                        Circle()
                            .fill(
                                Color.red.opacity(0.15)
                            )
                            .frame(
                                width: 86,
                                height: 86
                            )

                        Image(
                            systemName: "lock.fill"
                        )
                        .font(.system(size: 32))
                        .foregroundStyle(.red)
                    }

                    .padding(.bottom, 28)

                    // MARK: - Title

                    Text("Verify your number")
                        .font(
                            .system(
                                size: 28,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)

                    Text(
                        "We've sent a 6-digit OTP to"
                    )
                    .font(.subheadline)
                    .foregroundStyle(
                        .white.opacity(0.55)
                    )
                    .padding(.top, 8)

                    Text("+91 \(mobileNumber)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.top, 4)

                    // MARK: - OTP

                    HStack(
                        spacing: 10
                    ) {

                        ForEach(
                            0..<6,
                            id: \.self
                        ) { index in

                            OTPBox(
                                character: character(
                                    at: index
                                ),
                                isFocused:
                                    viewModel.otp.count == index
                            )
                        }
                    }
                    .padding(.top, 35)

                    // Hidden TextField

                    TextField(
                        "",
                        text: $viewModel.otp
                    )
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused(
                        $isOTPFocused
                    )
                    .frame(
                        width: 1,
                        height: 1
                    )
                    .opacity(0.01)
                    .onChange(
                        of: viewModel.otp
                    ) { _, newValue in

                        let filtered = newValue
                            .filter { $0.isNumber }

                        if filtered.count > 6 {

                            viewModel.otp =
                                String(
                                    filtered.prefix(6)
                                )

                        } else {

                            viewModel.otp = filtered
                        }
                    }

                    // MARK: - Error

                    if let errorMessage =
                        viewModel.errorMessage {

                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.top, 14)
                    }

                    // MARK: - Verify

                    Button {

                        verifyOTP()

                    } label: {

                        Text("Verify & Continue")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(height: 56)
                            .background(
                                viewModel.canVerifyOTP
                                ? Color.red
                                : Color.red.opacity(0.35)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16
                                )
                            )
                    }
                    .disabled(
                        !viewModel.canVerifyOTP
                    )
                    .padding(.top, 30)

                    // MARK: - Resend

                    if remainingSeconds > 0 {

                        Text(
                            "Resend OTP in \(remainingSeconds)s"
                        )
                        .font(.subheadline)
                        .foregroundStyle(
                            .white.opacity(0.45)
                        )
                        .padding(.top, 24)

                    } else {

                        Button {

                            resendOTP()

                        } label: {

                            Text("Resend OTP")
                                .font(
                                    .subheadline.weight(
                                        .semibold
                                    )
                                )
                                .foregroundStyle(.red)
                        }
                        .padding(.top, 24)
                    }

                    // MARK: - Demo Hint

                    Text("Demo OTP: 123456")
                        .font(.caption)
                        .foregroundStyle(
                            .white.opacity(0.25)
                        )
                        .padding(.top, 35)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {

            isOTPFocused = true
            startTimer()
        }
        .onDisappear {

            timer?.invalidate()
        }
    }

    // MARK: - Character

    private func character(
        at index: Int
    ) -> String {

        guard index < viewModel.otp.count else {
            return ""
        }

        let characters = Array(
            viewModel.otp
        )

        return String(
            characters[index]
        )
    }

    // MARK: - Verify

    private func verifyOTP() {

        guard viewModel.verifyOTP() else {
            return
        }

        timer?.invalidate()

        router.showHome()
    }

    // MARK: - Resend

    private func resendOTP() {

        viewModel.errorMessage = nil
        viewModel.otp = ""

        remainingSeconds = 30

        startTimer()

        isOTPFocused = true
    }

    // MARK: - Timer

    private func startTimer() {

        timer?.invalidate()

        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { _ in

            if remainingSeconds > 0 {

                remainingSeconds -= 1

            } else {

                timer?.invalidate()
            }
        }
    }
}

// MARK: - OTP Box

struct OTPBox: View {

    let character: String
    let isFocused: Bool

    var body: some View {

        Text(character)
            .font(
                .system(
                    size: 22,
                    weight: .bold
                )
            )
            .foregroundStyle(.white)
            .frame(
                maxWidth: .infinity
            )
            .frame(height: 58)
            .background(
                Color.white.opacity(0.08)
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 12
                )
                .stroke(
                    isFocused
                    ? Color.red
                    : Color.white.opacity(0.1),
                    lineWidth: 1.5
                )
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 12
                )
            )
    }
}
