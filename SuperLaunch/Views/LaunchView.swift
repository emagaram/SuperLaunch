import SwiftUI
struct LaunchView: View {
    // The view model is not used in this example
    // You may need to adjust the code to use it as per your requirements
    @StateObject private var viewModel = LaunchViewModel()
    

    var body: some View {
        VStack {
            TextField("Enter text", text: $viewModel.enteredText)
                .onChange(of: viewModel.enteredText) { newText in
                }
        }
    }
}
