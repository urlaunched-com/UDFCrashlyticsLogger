# UDFCrashlyticsLogger

**A custom logger for SwiftUI-UDF applications with Firebase Crashlytics integration.**

UDFCrashlyticsLogger is a custom logger built for SwiftUI-UDF that sends logs and error reports directly to Firebase Crashlytics. This integration provides real-time logging for actions and error reporting, allowing for more effective debugging and issue tracking in production applications.

## Features

- **Firebase Crashlytics integration**: Automatically logs actions and errors to Firebase Crashlytics.
- **Action filtering**: Ignore unnecessary actions like `UpdateFormField` to reduce log noise.
- **Error handling**: Automatically logs detailed error information, including error codes and descriptions.
- **Memory warnings**: Special handling for memory warning actions (`Actions.ApplicationDidReceiveMemoryWarning`).
  
---

## Installation

### Setup Firebase following official Firebase Crashlytics guide.
  - Add library via package manager.
  - Init via reducer.

``` swift
        import UDF
        struct AppState: AppReducer {
            // MARK: - Frameworks reducers
            var firebase = FirebaseReducer()
        }
        
        import UDF
        import FirebaseCore

        struct FirebaseReducer: Reducible {
            mutating func reduce(_ action: some Action) {
                switch action {
                case is Actions.ApplicationDidLaunchWithOptions:
                    configureFirebase()
                default:
                    break
                }
            }
        }

        // MARK: - configureFirebase
        private extension FirebaseReducer {
            func configureFirebase() {
                let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
                let options = FirebaseOptions(contentsOfFile: filePath)
                FirebaseApp.configure(options: options!)
            }
        }
```
  - Add New Run Script Phase as described in Firebase Crashlytics [guide](https://firebase.google.com/docs/crashlytics/get-started?platform=ios).
    

### Add **UDFCrashlyticsLogger** to your project via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/youarelaunched/UDFCrashlyticsLogger.git", from: "1.0.0")
]
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Contributing

Contributions are welcome! If you have any bug reports, feature requests, or suggestions, please open an issue or submit a pull request.

## Contact

For questions or support, feel free to contact us at [youarelaunched.com](https://youarelaunched.com).​
