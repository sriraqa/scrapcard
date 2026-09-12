//
//  InboxView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-06.
//

import SwiftUI

struct InboxView: View {
    @State private var isDraftPresented = false

    private let friends = [
        FriendStamp(name: "Sarah", assetName: nil),
        FriendStamp(name: "Alex", assetName: nil),
        FriendStamp(name: "Mina", assetName: nil),
        FriendStamp(name: "Theo", assetName: nil),
        FriendStamp(name: "June", assetName: nil)
    ]

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 20),
        count: 3
    )

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                header

                LazyVGrid(columns: columns, spacing: 24) {
                    MeInboxTile {
                        isDraftPresented = true
                    }

                    ForEach(friends) { friend in
                        FriendStampTile(friend: friend) {
                            print("Open stamp for \(friend.name)")
                        }
                    }
                }

                Spacer()
            }
            .background(Color.background)
            .navigationDestination(isPresented: $isDraftPresented) {
                DraftView()
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack {
            IconButtonView(systemName: "bell") {
                print("notification")
            }

            Spacer()

            Text("Your Inbox")
                .font(.senRegular(size: 24))

            Spacer()

            IconButtonView(systemName: "person.badge.plus") {
                print("add")
            }
        }
    }
}

private struct FriendStamp: Identifiable {
    let id = UUID()
    let name: String
    let assetName: String?
}

private struct MeInboxTile: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            InboxTileContainer(name: "Me") {
                Rectangle()
                    .stroke(Color("Primary"), lineWidth: 2)
                    .overlay {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 34, weight: .medium))
                            .foregroundStyle(Color("Primary"))
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

private struct FriendStampTile: View {
    let friend: FriendStamp
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            InboxTileContainer(name: friend.name) {
                Rectangle()
                    .stroke(
                        Color("TextPrimary"),
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .butt,
                            lineJoin: .miter,
                            miterLimit: 10,
                            dash: [2, 4, 6, 8]
                        )
                    )
                    .overlay {
                        if let assetName = friend.assetName {
                            Image(assetName)
                                .resizable()
                                .scaledToFit()
                                .padding(12)
                        }
                    }
            }
        }
        .buttonStyle(.plain)
    }
}

private struct InboxTileContainer<Content: View>: View {
    let name: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 8) {
            content()
                .aspectRatio(1, contentMode: .fit)

            Text(name)
                .font(.senRegular(size: 16))
                .foregroundStyle(Color("TextPrimary"))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

#Preview {
    InboxView()
}
