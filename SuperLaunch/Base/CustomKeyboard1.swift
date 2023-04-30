import SwiftUI

struct CustomKeyboard1: View {
    @Binding var text: String

    let rows = [
        "1234567890",
        "QWERTYUIOP",
        "ASDFGHJKL",
        "ZXCVBNM"
    ]

    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let keyWidth = (screenWidth - 50) / CGFloat(rows[0].count)
        
        VStack(alignment: .center, spacing: 10) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row.map { String($0) }, id: \.self) { key in
                        Button(action: {
                            self.text += key
                        }) {
                            Text(key)
                                .font(.system(size: 24))
                                .frame(width: keyWidth, height: 32)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                }
            }
            HStack(spacing: 10) {
                Button(action: {
                    self.text = String(self.text.dropLast())
                }) {
                    Image(systemName: "delete.left")
                        .font(.system(size: 24))
                        .frame(width: (screenWidth - 50) / 4, height: 32)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                }
                Button(action: {
                    self.text += " "
                }) {
                    Text("Space")
                        .font(.system(size: 24))
                        .frame(height: 36)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                }
                Button(action: {
                    // Handle return key action
                }) {
                    Text("Return")
                        .font(.system(size: 24))
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
    }
}
