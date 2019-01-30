//
//  ViewController.swift
//  MDComposeToolbar-Example
//
//  Created by Jonathan Danek on 1/30/19.
//  Copyright © 2019 Two Lambda. All rights reserved.
//

import UIKit
import MDComposeToolbar

class ViewController: UIViewController {

	@IBOutlet var label: UILabel!
	var toolbar: MDComposeToolbar?

	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}

	func setup() {
		let toolbar = MDComposeToolbar()
		toolbar.view.frame = view.bounds
		toolbar.delegate = self
		view.addSubview(toolbar.view)
		self.toolbar = toolbar
	}
}

extension ViewController: MDComposeToolbarDelegate {
	func toolbarDidFinish(with string: String?) {
		label.text = string
	}
}
