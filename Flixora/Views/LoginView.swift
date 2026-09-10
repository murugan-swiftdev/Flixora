//
//  LoginView.swift
//  Flixora
//
//  Created by Murugan on 21/08/26.
//

import SwiftUI

struct LoginView: View {

    @Environment(AppRouter.self)
    private var router

    @State
    private var viewModel = AuthViewModel()

    @FocusState
    private var isMobileFocused: Bool

    var body: some View {

        ZStack {

            // MARK: - Background

            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.08, green: 0.02, blue: 0.12),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(
                showsIndicators: false
            ) {

                VStack(
                    spacing: 0
                ) {

                    Spacer(minLength: 60)

                    // MARK: - Logo

                    VStack(spacing: 8) {

                        ZStack {

                            Circle()
                                .fill(
                                    Color.red.opacity(0.15)
                                )
                                .frame(
                                    width: 92,
                                    height: 92
                                )

                            Image(
                                systemName: "play.tv.fill"
                            )
                            .font(.system(size: 42))
                            .foregroundStyle(.red)
                        }

                        Text("FLIXORA")
                            .font(
                                .system(
                                    size: 32,
                                    weight: .black
                                )
                            )
                            .tracking(2)
                            .foregroundStyle(.white)

                        Text("Movies. Shows. Entertainment.")
                            .font(.subheadline)
                            .foregroundStyle(
                                .white.opacity(0.55)
                            )
                    }

                    .padding(.bottom, 55)

                    // MARK: - Welcome

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Text("Welcome back")
                            .font(
                                .system(
                                    size: 28,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.white)

                        Text(
                            "Login to continue watching your favourite content."
                        )
                        .font(.subheadline)
                        .foregroundStyle(
                            .white.opacity(0.55)
                        )
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                    .padding(.bottom, 28)

                    // MARK: - Mobile Number

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Text("Mobile Number")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(
                                .white.opacity(0.8)
                            )

                        HStack(spacing: 12) {

                            Text("+91")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.white)

                            Rectangle()
                                .fill(
                                    .white.opacity(0.15)
                                )
                                .frame(
                                    width: 1,
                                    height: 24
                                )

                            TextField(
                                "Enter mobile number",
                                text: $viewModel.mobileNumber
                            )
                            .keyboardType(.numberPad)
                            .textContentType(.telephoneNumber)
                            .foregroundStyle(.white)
                            .focused(
                                $isMobileFocused
                            )
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(
                            Color.white.opacity(0.08)
                        )
                        .overlay {
                            RoundedRectangle(
                                cornerRadius: 14
                            )
                            .stroke(
                                isMobileFocused
                                ? Color.red
                                : Color.white.opacity(0.08),
                                lineWidth: 1
                            )
                        }
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 14
                            )
                        )
                    }

                    // MARK: - Error

                    if let errorMessage = viewModel.errorMessage {

                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(.top, 10)
                    }

                    // MARK: - Continue

                    Button {

                        sendOTP()

                    } label: {

                        HStack {

                            if viewModel.isLoading {

                                ProgressView()
                                    .tint(.white)

                            } else {

                                Text("Continue")

                                Image(
                                    systemName: "arrow.right"
                                )
                            }
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(height: 56)
                        .background(
                            viewModel.canContinue
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
                        !viewModel.canContinue ||
                        viewModel.isLoading
                    )
                    .padding(.top, 24)

                    // MARK: - Terms

                    Text(
                        "By continuing, you agree to Flixora's Terms of Service and Privacy Policy."
                    )
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        .white.opacity(0.4)
                    )
                    .padding(
                        .top,
                        22
                    )

                    Spacer(
                        minLength: 40
                    )
                }
                .padding(.horizontal, 24)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Send OTP

    private func sendOTP() {

        guard viewModel.sendOTP() else {
            return
        }

        router.showOTP(
            mobileNumber: viewModel.mobileNumber
        )
    }
}
