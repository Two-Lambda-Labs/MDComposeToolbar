//
//  MDComposeToolbar.swift
//  MDComposeToolbar
//
//  Created by Jonathan Danek on 1/30/19.
//  Copyright © 2019 Two Lambda. All rights reserved.
//

import UIKit
import Notepad

public protocol MDComposeToolbarDelegate {
	func toolbarDidFinish(with string: String?)
}

public class MDComposeToolbar: UIViewController, UITextViewDelegate {

	// MARK: Properties
	public var delegate: MDComposeToolbarDelegate?
	public var isMaximized: Bool = false {
		didSet { updateSubviews() }
	}

	private var toolbarHeightConstraint: NSLayoutConstraint!

	// MARK: UI Elements

	private lazy var toolbarBacking: UIView = {
		let view = UIView()
		view.backgroundColor = Constants.BlackGrayColor
		view.layer.cornerRadius = Constants.CornerRadius
		return view
	}()

	private lazy var actionButton: UIButton = {
		let button = UIButton()
		button.setTitle("", for: .normal)
		button.setImage(UIImage(named: "Pencil", in: Bundle(for: MDComposeToolbar.self), compatibleWith: nil), for: .normal)
		return button
	}()

	private lazy var saveButton: UIButton = {
		let button = UIButton()
		button.setTitle("", for: .normal)
		button.setImage(UIImage(named: "Rocket", in: Bundle(for: MDComposeToolbar.self), compatibleWith: nil), for: .normal)
		return button
	}()

	private lazy var editor: Notepad = {
		let editor = Notepad(frame: .zero, themeFile: "base16-tomorrow-dark")
		editor.text = "Enter here"
		editor.backgroundColor = .clear
		return editor
	}()

	// MARK: Lifecycle

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public init() {
		super.init(nibName: nil, bundle: nil)
	}

	override public func viewDidLoad() {
        super.viewDidLoad()

        setupToolbar()

		setupMDEditor()

		setupConstraints()
    }

	// MARK: Private Setup

	private func setupToolbar() {

		view.addSubview(toolbarBacking)
		toolbarBacking.translatesAutoresizingMaskIntoConstraints = false

		toolbarBacking.addSubview(actionButton)
		actionButton.translatesAutoresizingMaskIntoConstraints = false

		toolbarBacking.addSubview(saveButton)
		saveButton.translatesAutoresizingMaskIntoConstraints = false
		saveButton.isHidden = true

		toolbarBacking.addSubview(editor)
		editor.translatesAutoresizingMaskIntoConstraints = false
		editor.isHidden = true
		editor.autoresizingMask = [.flexibleWidth, .flexibleHeight]

		actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
		saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)

	}

	private func setupMDEditor() {
		editor.delegate = self

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			toolbarBacking.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			toolbarBacking.leftAnchor.constraint(equalTo: view.leftAnchor),
			toolbarBacking.rightAnchor.constraint(equalTo: view.rightAnchor)
		])

		NSLayoutConstraint.activate([
			actionButton.widthAnchor.constraint(equalToConstant: Constants.ImageSize),
			actionButton.heightAnchor.constraint(equalToConstant: Constants.ImageSize),
			actionButton.centerXAnchor.constraint(equalTo: toolbarBacking.centerXAnchor),
			actionButton.topAnchor.constraint(equalTo: toolbarBacking.topAnchor, constant: Constants.ActionButtonTopMargin)
		])

		NSLayoutConstraint.activate([
			saveButton.widthAnchor.constraint(equalToConstant: Constants.ImageSize),
			saveButton.heightAnchor.constraint(equalToConstant: Constants.ImageSize),
			saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			saveButton.leftAnchor.constraint(equalTo: editor.rightAnchor),
			saveButton.rightAnchor.constraint(equalTo: toolbarBacking.rightAnchor)
		])

		NSLayoutConstraint.activate([
			editor.leftAnchor.constraint(equalTo: toolbarBacking.leftAnchor, constant: Constants.EditorHorizontalPadding),
			editor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			editor.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: Constants.EditorVerticlePadding)
		])

		toolbarHeightConstraint = toolbarBacking.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.MinimizedHeight)
		toolbarHeightConstraint.isActive = true

		view.setNeedsLayout()
		view.layoutIfNeeded()
	}

	// MARK: Event Handling

	@objc private func actionButtonPressed() {

		// Expand if not already
		guard isMaximized else {
			isMaximized = true
			return
		}

		// Alert user they are about to delete their document
		let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete this entry?", preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) { _ in
			self.isMaximized = false
			self.delegate?.toolbarDidFinish(with: nil)
		}
		let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
		alert.addAction(yesAction)
		alert.addAction(noAction)
		present(alert, animated: true, completion: nil)

	}

	@objc private func saveButtonPressed() {
		// Perform delegate callback and reset editor
		self.isMaximized = false
		delegate?.toolbarDidFinish(with: editor.text)
		editor.text = ""
	}

	@objc private func keyboardWillShow(notification: Notification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			toolbarBacking.transform = CGAffineTransform(translationX: 0.0, y: -keyboardSize.height)
		}
	}

	@objc private func keyboardWillHide(notification: Notification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			toolbarBacking.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
		}
	}

	// MARK: UITextView Delegate

	public func textViewDidChange(_ textView: UITextView) {
		updateSubviews()
	}

	// MARK: Helpers/Utilities

	private func updateSubviews() {
		editor.isHidden = !isMaximized
		saveButton.isHidden = !isMaximized

		var toolbarHeight = Constants.MinimizedHeight

		if isMaximized {
			let contentSize = editor.sizeThatFits(CGSize(width: editor.frame.width, height: CGFloat.greatestFiniteMagnitude))
			toolbarHeight += contentSize.height
			toolbarHeight += Constants.EditorVerticlePadding

			// Clamp Height at Half Screen Size
			toolbarHeight = min(toolbarHeight, UIScreen.main.bounds.height / 2.0)
		}

		toolbarHeightConstraint.constant = -toolbarHeight
		view.setNeedsLayout()
		UIView.animate(withDuration: Constants.AnimationDuration) {
			self.view.layoutIfNeeded()
		}
	}
}
