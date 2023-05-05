import SwiftUI
struct LaunchView: View {
    // The view model is not used in this
    @ObservedObject var viewModel = LaunchViewModel()
    func onEndedCallback () {
        print("END!")
        viewModel.openApp(appName: viewModel.predicted)
    }

    var body: some View {
        Spacer()
        Text(viewModel.predicted)
        CustomKeyboard(onEndedCallback: onEndedCallback, viewModel: viewModel)
    }
}
