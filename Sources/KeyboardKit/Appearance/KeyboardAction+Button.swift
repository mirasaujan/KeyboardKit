//
//  KeyboardAction+Button.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI
import UIKit

public extension KeyboardAction {
    
    /**
     The action's standard button background color.
     */
    func standardButtonBackgroundColor(for context: KeyboardContext, isPressed: Bool = false) -> Color {
        if let color = standardButtonBackgroundColorForAllStates() { return color }
        return isPressed
            ? standardButtonBackgroundColorForPressedState(for: context)
            : standardButtonBackgroundColorForIdleState(for: context)
    }
    
    /**
     The action's standard button font.
     */
    func standardButtonFont(for context: KeyboardContext) -> UIFont {
        .preferredFont(forTextStyle: standardButtonTextStyle(for: context))
    }
    
    /**
     The action's standard button font weight, if any.
     */
    var standardButtonFontWeight: UIFont.Weight? {
        if standardButtonImage != nil { return .light }
        switch self {
        case .character(let char): return char.isLowercased ? .light : nil
        default: return nil
        }
    }
    
    /**
     The action's standard button foreground color.
     */
    func standardButtonForegroundColor(for context: KeyboardContext, isPressed: Bool = false) -> Color {
        return isPressed
            ? standardButtonForegroundColorForPressedState(for: context)
            : standardButtonForegroundColorForIdleState(for: context)
    }
    
    /**
     The action's standard button image.
     */
    var standardButtonImage: Image? {
        switch self {
        case .backspace: return .backspace
        case .command: return .command
        case .control: return .control
        case .dictation: return .dictation
        case .dismissKeyboard: return .keyboardDismiss
        case .image(_, let imageName, _): return Image(imageName)
        case .keyboardType(let type): return type.standardButtonImage
        case .moveCursorBackward: return .moveCursorLeft
        case .moveCursorForward: return .moveCursorRight
        case .newLine: return .newLine
        case .nextKeyboard: return .globe
        case .option: return .option
        case .primary(let type): return type.standardButtonImage
        case .settings: return .settings
        case .shift(let currentState): return currentState.standardButtonImage
        case .systemImage(_, let imageName, _): return Image(systemName: imageName)
        case .tab: return .tab
        default: return nil
        }
    }
    
    /**
     The action's standard button shadow color.
     */
    func standardButtonShadowColor(for context: KeyboardContext) -> Color {
        if case .none = self { return .clear }
        if case .emoji = self { return .clear }
        return .standardButtonShadowColor(for: context)
    }
    
    /**
     The action's standard button text.
     */
    func standardButtonText(for context: KeyboardContext) -> String? {
        switch self {
        case .character(let char): return char
        case .done: return KKL10n.done.text(for: context)
        case .emoji(let emoji): return emoji.char
        case .emojiCategory(let cat): return cat.fallbackDisplayEmoji.char
        case .go: return KKL10n.go.text(for: context)
        case .keyboardType(let type): return type.standardButtonText
        case .nextLocale: return context.locale.languageCode?.uppercased()
        case .ok: return KKL10n.ok.text(for: context)
        case .primary(let type): return type.standardButtonText(for: context)
        case .return: return KKL10n.return.text(for: context)
        case .search: return KKL10n.search.text(for: context)
        default: return nil
        }
    }
    
    /**
     The action's standard button text style.
     */
    func standardButtonTextStyle(for context: KeyboardContext) -> UIFont.TextStyle {
        if standardButtonImage != nil { return .title2 }
        switch self {
        case .character(let char): return char.isLowercased ? .title1 : .title2
        case .emoji: return .title1
        case .emojiCategory: return .callout
        case .keyboardType: return .callout
        case .primary: return .callout
        case .return: return .callout
        case .space: return .body
        default: return .title2
        }
    }
}

private extension KeyboardAction.PrimaryType {
    
    var standardButtonImage: Image? {
        switch self {
        case .newLine: return .newLine
        default: return nil
        }
    }
    
    func standardButtonText(for context: KeyboardContext) -> String? {
        switch self {
        case .done: return KKL10n.done.text(for: context)
        case .go: return KKL10n.go.text(for: context)
        case .newLine: return nil
        case .ok: return KKL10n.ok.text(for: context)
        case .search: return KKL10n.search.text(for: context)
        }
    }
}

private extension KeyboardAction {
    
    func standardButtonBackgroundColorForAllStates() -> Color? {
        if case .none = self { return .clear }
        if case .emoji = self { return .clearInteractable }
        if case .emojiCategory = self { return .clearInteractable }
        return nil
    }
    
    func standardButtonBackgroundColorForIdleState(for context: KeyboardContext) -> Color {
        if isPrimaryAction { return .blue }
        if isSystemAction { return .standardDarkButton(for: context) }
        return .standardButton(for: context)
    }
    
    func standardButtonBackgroundColorForPressedState(for context: KeyboardContext) -> Color {
        if isPrimaryAction { return context.colorScheme == .dark ? .standardDarkButton(for: context) : .white }
        if isSystemAction { return .white }
        return .standardDarkButton(for: context)
    }
    
    func standardButtonForegroundColorForIdleState(for context: KeyboardContext) -> Color {
        if isPrimaryAction { return .white }
        return .standardButtonTint(for: context)
    }
    
    func standardButtonForegroundColorForPressedState(for context: KeyboardContext) -> Color {
        if isPrimaryAction { return context.colorScheme == .dark ? .white : .standardButtonTint(for: context) }
        return .standardButtonTint(for: context)
    }
}
