import SwiftUI

struct CustomKeyboard: View {
    @Binding var text: String
    
    let rows = [
        "1234567890",
        "QWERTYUIOP",
        "ASDFGHJKL",
        "ZXCVBNM",
    ]
    @State var buttonCenterCoords:[String:XYPair] = [:]
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
        VStack(alignment: .center, spacing: rowSpacing) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: keySpacing) {
                    ForEach(row.map { String($0) }, id: \.self) { key in
                        var pair:XYPair = (x:0,y:0)
                        Button(action: {
                            self.text += key
                        }) {
                            Text(key)
                                .font(.system(size: 24))
                                .frame(width: keyWidth, height: keyHeight)
                                .background(GeometryReader { buttonGeometry -> Color in
                                    pair = XYPair(x: buttonGeometry.frame(in: .global).midX, y: buttonGeometry.frame(in: .global).midY)
                                    return buttonColor
                                })
                                .cornerRadius(5)
                                .onAppear {
                                    buttonCenterCoords[key] = pair
                                    print("Button ", key, "has x ", pair.x, " and has y ", pair.y)
                                }
                            
                            
                            
                            
                            
                        }
                    }
                }
            }
            HStack(spacing: 10) {
                Button(action: {
                    self.text += " "
                }) {
                    Text("Space")
                        .font(.system(size: 24))
                        .frame(width: keyWidth*5,height: keyHeight)
                        .background(buttonColor)
                        .cornerRadius(5)
                }
                Button(action: {
                    self.text = String(self.text.dropLast())
                }) {
                    Image(systemName: "delete.left")
                        .font(.system(size: 24))
                        .frame(width: (screenWidth - 50) / 4, height: keyHeight)
                        .background(buttonColor)
                        .cornerRadius(5)
                }
            }
            
        }
        .padding(EdgeInsets(top: paddingVertical, leading: paddingHorizontal, bottom: paddingVertical, trailing: paddingHorizontal))
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.gray.opacity(0.3))
        
    }
}
