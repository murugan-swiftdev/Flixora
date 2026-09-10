//
//  OTTTabBar.swift
//  Flixora
//
//  Created by Murugan on 18/08/26.
//

import SwiftUI

struct OTTTabBar: View {

    @Binding var selectedTab: OTTTab

    var body: some View {

        HStack(spacing: 4) {

            ForEach(OTTTab.allCases, id: \.self) { tab in

                Button {

                    withAnimation(.spring(
                        response: 0.3,
                        dampingFraction: 0.8
                    )) {
                        selectedTab = tab
                    }

                } label: {

                    VStack(spacing: 5) {

                        Image(
                            systemName:
                                selectedTab == tab
                                ? tab.selectedIcon
                                : tab.icon
                        )
                        .font(.system(
                            size: 18,
                            weight: selectedTab == tab
                                ? .semibold
                                : .regular
                        ))

                        Text(tab.title)
                            .font(.system(
                                size: 10,
                                weight: selectedTab == tab
                                    ? .semibold
                                    : .regular
                            ))
                            .lineLimit(1)
                    }
                    .foregroundStyle(
                        selectedTab == tab
                        ? .white
                        : .white.opacity(0.55)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background {

                        if selectedTab == tab {

                            Capsule()
                                .fill(.red.opacity(0.9))
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .background {

            RoundedRectangle(cornerRadius: 24)
                .fill(.black.opacity(0.94))
                .overlay {

                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            .white.opacity(0.08),
                            lineWidth: 1
                        )
                }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
}
