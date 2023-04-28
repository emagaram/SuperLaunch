import UIKit
import SwiftUI
final class CustomKeyboard: UIInputView, UIViewRepresentable {
    
    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        setupButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtons() {
        let button1 = UIButton(type: .system)
        button1.setTitle("Button 1", for: .normal)
        button1.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        button1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        addSubview(button1)

        let button2 = UIButton(type: .system)
        button2.setTitle("Button 2", for: .normal)
        button2.frame = CGRect(x: 100, y: 0, width: 100, height: 50)
        button2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        addSubview(button2)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let buttonTitle = sender.title(for: .normal) {
            print("\(buttonTitle) tapped")
        }
    }
    
    func makeUIView(context: Context) -> CustomKeyboard {
         let keyboard = CustomKeyboard(frame: CGRect(x: 0, y: 0, width: 100, height: 250), inputViewStyle: .keyboard)
         return keyboard
     }

     func updateUIView(_ uiView: CustomKeyboard, context: Context) {
         // update the view if needed
     }
}
