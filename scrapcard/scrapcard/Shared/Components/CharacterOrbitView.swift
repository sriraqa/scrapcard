//
//  CharacterOrbitView.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2026-08-23.
//

import SwiftUI

enum ScrapcardAssets {
    static let characterImages = [
        "character_pig",
        "character_elephant",
        "character_alien",
        "character_cat",
        "character_frog"
    ]

    static let stickerImages = [
        "sticker_heart",
        "sticker_clover",
        "sticker_shimmer",
        "sticker_bang",
        "sticker_flower",
        "sticker_star"
    ]
}

struct CharacterOrbitView: View {
    let characterName: String
    let stickerNames: [String]

    private let animationDuration = 5.0
    private let settleRotation = Double.pi * 4
    private let totalStickerCount = 10
    private let startDate = Date()

    private var orbitStickers: [OrbitSticker] {
        let names = repeatedStickerNames(count: totalStickerCount)
        let bands: [OrbitBand] = [
            OrbitBand(radiusX: 110, radiusY: 24, centerY: -72, size: 32, phase: 0.1),
            OrbitBand(radiusX: 130, radiusY: 48, centerY: -16, size: 40, phase: 0.7),
            OrbitBand(radiusX: 110, radiusY: 28, centerY: 52, size: 34, phase: 1.3)
        ]

        return names.indices.map { index in
            let band = bands[index % bands.count]
            let bandIndex = index / bands.count
            let stickersPerBand = max(Int(ceil(Double(names.count) / Double(bands.count))), 1)
            let angleOffset = (Double(bandIndex) / Double(stickersPerBand) * Double.pi * 2) + band.phase

            return OrbitSticker(
                id: index,
                name: names[index],
                angleOffset: angleOffset,
                band: band
            )
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = min(timeline.date.timeIntervalSince(startDate), animationDuration)
            let progress = elapsed / animationDuration
            let rotation = settleRotation * easeOut(progress)

            ZStack {
                ForEach(orbitStickers) { sticker in
                    stickerView(sticker, rotation: rotation, progress: progress)
                }

                Image(characterName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 178, height: 178)
                    .zIndex(10)
            }
            .frame(width: 320, height: 300)
        }
        .accessibilityHidden(true)
    }

    private func stickerView(_ sticker: OrbitSticker, rotation: Double, progress: Double) -> some View {
        let angle = sticker.angleOffset + rotation
        let depth = sin(angle)
        let orbitX = cos(angle) * sticker.band.radiusX
        let orbitY = sticker.band.centerY + (depth * sticker.band.radiusY)
        let settledPosition = settledArcPosition(for: sticker)
        let settleProgress = easeOut(max((progress - 0.65) / 0.35, 0))
        let x = orbitX + ((settledPosition.x - orbitX) * settleProgress)
        let y = orbitY + ((settledPosition.y - orbitY) * settleProgress)
        let scale = 0.72 + ((depth + 1) * 0.16)

        return Image(sticker.name)
            .resizable()
            .scaledToFit()
            .frame(width: sticker.band.size, height: sticker.band.size)
            .scaleEffect(scale)
            .offset(x: x, y: y)
            .zIndex(settleProgress < 0.9 && depth > 0 ? 20 + depth : depth)
    }

    private func settledArcPosition(for sticker: OrbitSticker) -> CGPoint {
        let denominator = max(totalStickerCount - 1, 1)
        let progress = Double(sticker.id) / Double(denominator)
        let startAngle = Double.pi + (Double.pi / 9)
        let endAngle = -(Double.pi / 9)
        let angle = startAngle + ((endAngle - startAngle) * progress)
        let alternatingRadiusOffset = sticker.id.isMultiple(of: 2) ? -20.0 : 20.0
        let radiusX = 136 + alternatingRadiusOffset
        let radiusY = 150 + alternatingRadiusOffset

        return CGPoint(
            x: cos(angle) * radiusX,
            y: 10 - (sin(angle) * radiusY)
        )
    }

    private func repeatedStickerNames(count: Int) -> [String] {
        guard !stickerNames.isEmpty else { return [] }

        return (0..<count).map { index in
            stickerNames[index % stickerNames.count]
        }
    }

    private func easeOut(_ progress: Double) -> Double {
        1 - pow(1 - progress, 3)
    }
}

private struct OrbitSticker: Identifiable {
    let id: Int
    let name: String
    let angleOffset: Double
    let band: OrbitBand
}

private struct OrbitBand {
    let radiusX: Double
    let radiusY: Double
    let centerY: Double
    let size: Double
    let phase: Double
}

#Preview {
    CharacterOrbitView(
        characterName: ScrapcardAssets.characterImages[0],
        stickerNames: ScrapcardAssets.stickerImages
    )
}
