//
//  SportsCard.swift
//  Flixora
//
//  Created by Murugan on 19/08/26.
//

import SwiftUI

struct SportsCard: View {
    
    let content: SportsContent
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            
            // MARK: - Image
            
            ZStack(
                alignment: .topLeading
            ) {
                
                Image(content.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: 250,
                        height: 145
                    )
                    .background(
                        Color.gray.opacity(0.15)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                    .clipped()
                
                // Status
                
                HStack(spacing: 5) {
                    
                    if content.status == .live {
                        
                        Circle()
                            .fill(.red)
                            .frame(
                                width: 7,
                                height: 7
                            )
                    }
                    
                    Text(
                        content.status == .live
                        ? "LIVE"
                        : content.status.rawValue.uppercased()
                    )
                    .font(
                        .system(
                            size: 9,
                            weight: .bold
                        )
                    )
                }
                .foregroundStyle(.white)
                .padding(
                    .horizontal,
                    8
                )
                .padding(
                    .vertical,
                    5
                )
                .background(
                    content.status == .live
                    ? Color.red
                    : Color.black.opacity(0.7)
                )
                .clipShape(
                    Capsule()
                )
                .padding(8)
                
                // Premium
                
                if content.isPremium {
                    
                    Text("PREMIUM")
                        .font(
                            .system(
                                size: 8,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .padding(
                            .horizontal,
                            7
                        )
                        .padding(
                            .vertical,
                            4
                        )
                        .background(.red)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 5
                            )
                        )
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .bottomTrailing
                        )
                        .padding(8)
                }
            }
            
            // MARK: - League
            
            Text(content.league)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // MARK: - Teams
            
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                
                HStack {
                    
                    Text(content.teamOne)
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                    
                    Spacer()
                    
                    if let score =
                        content.teamOneScore {
                        
                        Text(score)
                            .font(
                                .system(
                                    size: 13,
                                    weight: .bold
                                )
                            )
                    }
                }
                
                HStack {
                    
                    Text(content.teamTwo)
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                    
                    Spacer()
                    
                    if let score =
                        content.teamTwoScore {
                        
                        Text(score)
                            .font(
                                .system(
                                    size: 13,
                                    weight: .bold
                                )
                            )
                    }
                }
            }
            
            // MARK: - Time
            
            Text(content.startTime)
                .font(.caption)
                .foregroundStyle(
                    content.status == .live
                    ? .red
                    : .secondary
                )
        }
        .frame(width: 250)
    }
}
