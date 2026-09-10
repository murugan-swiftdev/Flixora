//
//  SplashView.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct SplashView: View {

    @Environment(AppRouter.self)
    private var router

    @State
    private var isVisible = false

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 18) {

                Image(systemName: "play.tv.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.red)
                    .scaleEffect(
                        isVisible ? 1 : 0.7
                    )
                    .opacity(
                        isVisible ? 1 : 0
                    )

                Text("FLIXORA")
                    .font(
                        .system(
                            size: 34,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .opacity(
                        isVisible ? 1 : 0
                    )

                Text("Movies • Series • Sports")
                    .font(.subheadline)
                    .foregroundStyle(
                        .white.opacity(0.7)
                    )
                    .opacity(
                        isVisible ? 1 : 0
                    )
            }
        }
        .task {

            // MARK: - Splash Animation

            withAnimation(
                .easeOut(duration: 0.8)
            ) {
                isVisible = true
            }

            // MARK: - Splash Duration

            try? await Task.sleep(
                for: .seconds(1.8)
            )

            // MARK: - Authentication Check

            if AuthViewModel.isLoggedIn {

                router.showHome()

            } else {

                router.showLogin()
            }
        }
    }
}
