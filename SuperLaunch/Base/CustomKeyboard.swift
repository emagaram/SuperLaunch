import SwiftUI

struct CustomKeyboard: View {
    var onEndedCallback: () -> Void
    @ObservedObject var viewModel: LaunchViewModel
    let rows = [
        "1234567890",
        "QWERTYUIOP",
        "ASDFGHJKL",
        "ZXCVBNM",
    ]
    var body: some View {
        
        let paddingHorizontal:CGFloat = 1
        let paddingVertical:CGFloat = 4
        let screenWidth:CGFloat = UIScreen.main.bounds.width - 2*paddingHorizontal
        let keyWidthPercentage = 0.085
        let keyWidth:CGFloat = screenWidth * keyWidthPercentage
        let keySpacingPercentage = (1-keyWidthPercentage*10)
        let keySpacing:CGFloat = screenWidth*(keySpacingPercentage/10)
        let keyHeight:CGFloat = 40
        let rowSpacing:CGFloat = 10
        let buttonColor = Color.white.opacity(0.95)
        let textColor = Color.black.opacity(0.95)
        ZStack {
            GeometryReader {
                keyboardGeometry in
                VStack(alignment: .center, spacing: rowSpacing) {
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: keySpacing) {
                            ForEach(row.map { String($0) }, id: \.self) { key in
                                Button(action: {
                                }) {
                                    var pair:CGPoint = CGPoint(x: 0, y: 0)
                                    Text(key)
                                        .font(.system(size: 24))
                                        .foregroundColor(textColor)
                                        .frame(width: keyWidth, height: keyHeight)
                                        .background(GeometryReader { buttonGeometry -> Color in
                                            pair = CGPoint(x: buttonGeometry.frame(in: .global).midX, y: buttonGeometry.frame(in: .global).midY - keyboardGeometry.frame(in: .global).minY)
                                            return buttonColor
                                        })
                                        .cornerRadius(5)
                                        .onAppear {
                                            viewModel.buttonCenterCoords[key.lowercased()] = pair
                                            print("Button ", key, "has x ", pair.x, " and has y ", pair.y)
                                        }
                                }
                            }
                        }
                    }
                    HStack(spacing: 10) {
                        Button(action: {
                        }) {
                            var pair:CGPoint = CGPoint(x: 0, y: 0)
                            Text("Space")
                                .font(.system(size: 24))
                                .foregroundColor(textColor)
                                .frame(width: keyWidth*5,height: keyHeight)
                                .background(GeometryReader { buttonGeometry -> Color in
                                    pair = CGPoint(x: buttonGeometry.frame(in: .global).midX, y: buttonGeometry.frame(in: .global).midY - keyboardGeometry.frame(in: .global).minY)
                                    return buttonColor
                                })
                                .cornerRadius(5)
                                .onAppear {
                                    viewModel.buttonCenterCoords[" "] = pair
                                }
                        }
                        Button(action: {
                        }) {
                            Image(systemName: "delete.left")
                                .font(.system(size: 24))
                                .foregroundColor(textColor)
                                .frame(width: (screenWidth - 50) / 4, height: keyHeight)
                                .background(buttonColor)
                                .cornerRadius(5)
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: paddingVertical, leading: paddingHorizontal, bottom: paddingVertical, trailing: paddingHorizontal))
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.gray.opacity(0.3))
            }.frame(width: UIScreen.main.bounds.width, height:250)
            
            DrawingView(onEndedCallback:onEndedCallback, lastLine: $viewModel.lastLine).frame(width: screenWidth, height: 250).border(.blue)
        }
    }
}
