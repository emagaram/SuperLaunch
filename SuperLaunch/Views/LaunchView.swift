//
//  LaunchView.swift
//  SuperLaunch
//
//  Created by Ezra Magaram on 4/28/23.
//

import Foundation
import SwiftUI

struct LaunchView: View {
    @StateObject private var viewModel = LaunchViewModel()
    
//    let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30), .)
    var body: some View {
        VStack {
            TextField("Title", text: $viewModel.enteredText)
        }
    }
}

