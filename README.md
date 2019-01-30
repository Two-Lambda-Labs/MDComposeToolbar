# MDComposeToolbar
> Drop-in Toolbar UI for inputting markdown based text. Made in Swift for iOS.


A very simple UI component that allows users to input markdown styled text. A delegate callback makes it really easy to embed this in your project and get running in minutes.


## Installation

Cocoapods:

```bash
pod 'MDComposeToolbar', :git => 'https://github.com/Two-Lambda-Labs/MDComposeToolbar'
```

```bash
pod install
```
```swift
let toolbar = MDComposeToolbar()
toolbar.view.frame = view.bounds
toolbar.delegate = self
view.addSubview(toolbar.view)
```

Optional (Implement Toolbar Delegate):
```swift
extension ViewController: MDComposeToolbarDelegate {
	func toolbarDidFinish(with string: String?) {
		label.text = string
	}
}
```

## Usage example

See `MDComposeToolbar-Example` directory for an example and demo of the toolbar.

## Release History

* 0.0.1
    * Initial Working Version

## Meta

Jonathan Danek – [Website](https://danek.me/) – Jonathan@Danek.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[Github](https://github.com/jdanek4/)

## Contributing

1. Fork it (<https://github.com/Two-Lambda-Labs/MDComposeToolbar/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

