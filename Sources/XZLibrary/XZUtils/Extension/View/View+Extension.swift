//
//  ViewExtension.swift
//  Reader
//
//  Created by mac on 2021/4/11.
//

import Foundation
import SwiftUI
import UIKit

public extension View {
    func log(_ log: String) -> EmptyView {
        print("Log==>\(log)")
        return EmptyView()
    }
}

public extension View {
    func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        body(&result)
        return result
    }

    @ViewBuilder func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        @ViewBuilder trueContent: (Self) -> TrueContent,
        @ViewBuilder else falseContent: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueContent(self)
        } else {
            falseContent(self)
        }
    }
}
