//
//  DemoButton.swift
//  KeyboardKitDemoKeyboard
//
//  Created by Daniel Saidi on 2019-04-30.
//  Copyright © 2019 Daniel Saidi. All rights reserved.
//

import UIKit
import KeyboardKit

/**
 This demo-specific button view represents a keyboard button
 like the one used in the iOS system keyboard. The file also
 contains `KeyboardAction` extensions used by this class.
 */
class DemoButton: KeyboardButtonView {
    
    
    // MARK: - Setup
    
    public func setup(
        with action: KeyboardAction,
        in viewController: KeyboardInputViewController,
        edgeInsets: UIEdgeInsets,
        distribution: UIStackView.Distribution = .fillEqually) {
        super.setup(with: action, in: viewController)
        useDarkAppearance = action.useDarkAppearance(in: viewController)
        backgroundColor = .clearInteractable
        buttonView?.backgroundColor = action.buttonColor(for: viewController)
        buttonViewTopMargin?.constant = edgeInsets.top
        buttonViewBottomMargin?.constant = edgeInsets.bottom
        buttonViewLeadingMargin?.constant = edgeInsets.left
        buttonViewTrailingMargin?.constant = edgeInsets.right
        DispatchQueue.main.async { self.image?.image = action.buttonImage }
        textLabel?.font = action.systemFont
        textLabel?.text = action.buttonText
        textLabel?.textColor = action.tintColor(in: viewController)
        buttonView?.tintColor = action.tintColor(in: viewController)
        width = action.buttonWidth(for: distribution)
    }
    
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if useDarkAppearance {
            buttonView?.applyShadow(.standardButtonShadowDark)
        } else {
            buttonView?.applyShadow(.standardButtonShadowLight)
        }
    }
    
    
    // MARK: - Properties
    
    private var useDarkAppearance: Bool = false
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var buttonView: UIView? {
        didSet { buttonView?.layer.cornerRadius = 7 }
    }
    
    @IBOutlet weak var image: UIImageView?
    
    @IBOutlet weak var textLabel: UILabel? {
        didSet { textLabel?.text = "" }
    }
    
    
    // MARK: - Margins
    
    @IBOutlet weak var buttonViewBottomMargin: NSLayoutConstraint?
    
    @IBOutlet weak var buttonViewLeadingMargin: NSLayoutConstraint?
    
    @IBOutlet weak var buttonViewTopMargin: NSLayoutConstraint?
    
    @IBOutlet weak var buttonViewTrailingMargin: NSLayoutConstraint?
}


// MARK: - Private button-specific KeyboardAction Extensions

private extension KeyboardAction {
    
    /**
     The button color of a button that uses this action.
     */
    func buttonColor(for viewController: KeyboardInputViewController) -> UIColor {
        let isDark = useDarkAppearance(in: viewController)
        let standardColor = isDark ? Asset.Colors.darkButton : Asset.Colors.lightButton
        let systemColor = isDark ? Asset.Colors.darkSystemButton : Asset.Colors.lightSystemButton
        let asset = isSystemButton ? systemColor : standardColor
        return asset.color
    }
    
    /**
     The image to use for a button that uses this action.
     */
    var buttonImage: UIImage? {
        switch self {
        case .image(_, let imageName, _): return UIImage(named: imageName)
        case .nextKeyboard: return Asset.Images.Buttons.switchKeyboard.image
        default: return nil
        }
    }
    
    /**
     The text to use for a button that uses this action.
     */
    var buttonText: String? {
        switch self {
        case .backspace: return "⌫"
        case .character(let text), .emoji(let text): return text
        case .emojiCategory(let category): return buttonText(for: category)
        case .keyboardType(let type): return buttonText(for: type)
        case .newLine: return "return"
        case .shift(let currentState): return currentState.isUppercased ? "⇪" : "⇧"
        case .space: return "space"
        default: return nil
        }
    }
    
    /**
     The text to show for an emoji category button.
     */
    func buttonText(for category: EmojiCategory) -> String {
        switch category {
        case .frequent: return "🕓"
        case .smileys: return "😀"
        case .animals: return "🐻"
        case .foods: return "🍔"
        case .activities: return "⚽️"
        case .travels: return "🚗"
        case .objects: return "⏰"
        case .symbols: return "💱"
        case .flags: return "🏳️"
        }
    }
    
    /**
     The text to show for a keyboard switcher button.
     */
    func buttonText(for keyboardType: KeyboardType) -> String {
        switch keyboardType {
        case .alphabetic: return "ABC"
        case .emojis: return "🙂"
        case .images: return "🖼️"
        case .numeric: return "123"
        case .symbolic: return "#+="
        default: return "???"
        }
    }
    
    /**
     The width of certain system actions.
     */
    var buttonWidth: CGFloat {
        switch self {
        case .none: return 10
        case .newLine: return 120
        case .shift, .backspace, .keyboardType: return 60
        case .space: return 100
        default: return 50
        }
    }
    
    /**
     The width of the button, when it's used in a stack view
     with a certain distribution.
     */
    func buttonWidth(for distribution: UIStackView.Distribution) -> CGFloat {
        let adjust = distribution == .fillProportionally
        return adjust ? buttonWidth * 100 : buttonWidth
    }
    
    /**
     Whether or not the button is a "system button" that has
     a dark button style and that performs an action instead
     of typing text.
     */
    var isSystemButton: Bool {
        switch self {
        case .character, .image, .space: return false
        default: return true
        }
    }
    
    /**
     The tint color of the button.
     */
    func tintColor(in viewController: KeyboardInputViewController) -> UIColor {
        let isDark = useDarkAppearance(in: viewController)
        let standardColor = isDark ? Asset.Colors.darkButtonText : Asset.Colors.lightButtonText
        let systemColor = isDark ? Asset.Colors.darkSystemButtonText : Asset.Colors.lightSystemButtonText
        let asset = isSystemButton ? systemColor : standardColor
        return asset.color
    }
    
    /**
     Whether or not the keyboard action should apply a dark
     */
    func useDarkAppearance(in viewController: KeyboardInputViewController) -> Bool {
        if #available(iOSApplicationExtension 12.0, *) {
            return viewController.traitCollection.userInterfaceStyle == .dark
        } else {
            let appearance = viewController.textDocumentProxy.keyboardAppearance ?? .default
            return appearance == .dark
        }
    }
}
