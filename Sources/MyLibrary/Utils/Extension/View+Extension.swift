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
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    func log(_ log: String) -> EmptyView {
        print("Log==>\(log)")
        return EmptyView()
    }
}
