import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    var isDisabled: Bool
    @Environment(\.colorScheme) var colorScheme

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        // Customize textView...
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = true
        
        // Set initial background and text colors based on color scheme
        updateColors(in: textView)
        
        // Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(Coordinator.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        textView.inputAccessoryView = toolbar
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        
        // Update colors when the color scheme changes
        updateColors(in: uiView)
        
        // Update isEditable and isUserInteractionEnabled based on isDisabled
        uiView.isEditable = !isDisabled
        uiView.isUserInteractionEnabled = !isDisabled
        
        // Update text color based on isDisabled
        if isDisabled {
            uiView.textColor = UIColor.lightGray
        } else {
            uiView.textColor = colorScheme == .dark ? UIColor.black : UIColor.black
        }
    }

    private func updateColors(in textView: UITextView) {
        textView.backgroundColor = colorScheme == .dark ? UIColor.clear : UIColor.clear
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor

        init(_ textView: CustomTextEditor) {
            self.parent = textView
        }

        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}


#Preview("Custom Text Editor") {
    CustomTextEditor(text: .constant("Type here..."), isDisabled: false)
}
