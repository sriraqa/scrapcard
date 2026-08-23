//
//  Font+Extension.swift
//  scrapcard
//
//  Created by Sarah Qiao on 2025-08-31.
//

import SwiftUI

extension Font {
    static func senRegular(size: CGFloat) -> Font {
        .custom("Sen-Regular", size: size)
    }

    static func senMedium(size: CGFloat) -> Font {
        .custom("Sen-Medium", size: size)
    }

    static func senSemiBold(size: CGFloat) -> Font {
        .custom("Sen-SemiBold", size: size)
    }

    static func senBold(size: CGFloat) -> Font {
        .custom("Sen-Bold", size: size)
    }

    static func senExtraBold(size: CGFloat) -> Font {
        .custom("Sen-ExtraBold", size: size)
    }
}
