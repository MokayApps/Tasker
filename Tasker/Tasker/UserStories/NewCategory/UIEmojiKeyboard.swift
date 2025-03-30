//
//  UIEmojiKeyboard.swift
//  Tasker
//
//  Created by Roman Apanasevich on 02.02.2025.
//

import UIKit
import SwiftUI
import MokayUI

final class UIEmojiTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEmoji() {
        _ = self.textInputMode
    }
    
    override var textInputContextIdentifier: String? {
           return ""
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default
                return mode
            }
        }
        return nil
    }
	
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		action == #selector(self.resignFirstResponder)
	}

	override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
		[]
	}

	override func caretRect(for position: UITextPosition) -> CGRect {
		.null
	}
}

struct EmojiTextField: UIViewRepresentable {
	@Binding var text: String
	
	func makeUIView(context: Context) -> UIEmojiTextField {
		let txt = UIEmojiTextField()
		txt.text = text
		txt.delegate = context.coordinator
		txt.textAlignment = .center
		txt.tintColor = .clear
		txt.font = TypographyStyle.h3.uiFont
		txt.textContentType = .none
		return txt
	}
	
	func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
		uiView.text = text
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	class Coordinator: NSObject, UITextFieldDelegate {
		var parent: EmojiTextField
		
		init(parent: EmojiTextField) {
			self.parent = parent
		}
		
		func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
			if string.isEmpty {
				return false
			}
			
			parent.text = string
			textField.text = string
			return false
		}
		
		func textFieldDidBeginEditing(_ textField: UITextField) {
			textField.selectedTextRange = nil
		}
	}
}

struct EmojiContentView: View {
    
    @State private var text: String = "dfsdfsdf"
    
    var body: some View {
		EmojiTextField(text: $text)
    }
}

#Preview {
    EmojiContentView()
}
