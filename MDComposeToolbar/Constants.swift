//
//  MDComposeToolbarConstants.swift
//  MDComposeToolbar
//
//  Created by Jonathan Danek on 1/30/19.
//  Copyright © 2019 Two Lambda. All rights reserved.
//

import Foundation

internal struct Constants {

	// Height of toolbar when minimized
	static let MinimizedHeight = CGFloat(60.0)

	// Height and Width of Button Images
	static let ImageSize = CGFloat(30.0)

	// Toolbar Backing's Corner Radius
	static let CornerRadius = CGFloat(10.0)

	// Varying Constants for Auto Layout
	static let EditorVerticlePadding = CGFloat(5.5)
	static let EditorHorizontalPadding = CGFloat(15)
	static let ActionButtonTopMargin = CGFloat(20)

	// Character length threshold whether to alert user when
	// deleting a document.
	static let SaveWarningThreshold = 10

	// Duration of Animations in Seconds
	static let AnimationDuration = 0.1

	// Dark Gray Color
	static let BlackGrayColor = UIColor(red: 35.0 / 255.0, green: 36.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0)
}
