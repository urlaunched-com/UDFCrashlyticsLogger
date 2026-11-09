import UDF
import FirebaseCrashlytics

/// `CrashlyticsLogger` is a custom logger that conforms to `ActionLogger` and integrates with Firebase Crashlytics.
/// It logs actions to Firebase Crashlytics, with special handling for errors and memory warnings.
///
/// This logger:
/// - Filters out irrelevant actions, such as `UpdateFormField` actions.
/// - Logs every action to Crashlytics as a simple log entry, so the action log also includes errors and memory warnings.
/// - Records errors to Crashlytics as non-fatal errors with detailed information, including error codes and descriptions.
///
/// Usage Example:
/// ```swift
/// @main
/// struct MyApp: App {
///     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
///     @Environment(\.scenePhase) var scenePhase
///
///     let store: EnvironmentStore<AppState, AppEnvironment>
///
///     init() {
///         store = EnvironmentStore(
///             initial: AppState(),
///             loggers: [.crashlytics] // Using CrashlyticsLogger
///         )
///     }
/// }
/// ```
///
/// You can also customize `CrashlyticsLogger` by providing custom filters or action descriptors.
public struct CrashlyticsLogger: ActionLogger {
    
    /// Filters applied to log actions. By default, it filters out `UpdateFormField` actions.
    public var actionFilters: [ActionFilter]
    
    /// Describes the logged action in string format. By default, it uses `StringDescribingActionDescriptor`.
    public var actionDescriptor: ActionDescriptor
    
    /// Initializes a new `CrashlyticsLogger`.
    ///
    /// - Parameters:
    ///   - actionFilters: An array of filters to apply to actions. Defaults to filtering out `UpdateFormField` actions.
    ///   - actionDescriptor: A descriptor that formats actions as strings. Defaults to `StringDescribingActionDescriptor`.
    public init(
        actionFilters: [ActionFilter] = [UpdateFormFieldActionFilter()],
        actionDescriptor: ActionDescriptor = StringDescribingActionDescriptor()
    ) {
        self.actionFilters = actionFilters
        self.actionDescriptor = actionDescriptor
    }
    
    /// Logs the given action to Firebase Crashlytics.
    ///
    /// - Parameters:
    ///   - action: The action to be logged.
    ///   - description: A string description of the action.
    ///
    /// Every action is first added to the Crashlytics action log. Then the following cases are also recorded as non-fatal errors:
    /// - `Actions.Error` with the error ID and description, as an `NSError`.
    /// - `Actions.ApplicationDidReceiveMemoryWarning`, as an `NSError`.
    public func log(_ action: LoggingAction, description: String) {
        // Log the action itself, including errors and memory warnings, so it is part of the action log
        Crashlytics.crashlytics().log(description)

        switch action.value {
        case let errorAction as Actions.Error:
            // Prepare error information to log with Crashlytics
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString(description, comment: ""),
                "error_id": errorAction.id
            ]
            
            // Create an NSError for the error action and log it
            let error = NSError(
                domain: "Actions.Error",
                code: errorAction.code,
                userInfo: userInfo
            )
            
            // Log the error to Firebase Crashlytics
            Crashlytics.crashlytics().record(error: error)
            
        case is Actions.ApplicationDidReceiveMemoryWarning:
            // Log memory warnings as NSError
            let error = NSError(
                domain: "Actions.ApplicationDidReceiveMemoryWarning",
                code: 101,
                userInfo: nil
            )
            
            Crashlytics.crashlytics().record(error: error)
            
        default:
            break
        }
    }
}

/// Extension for `ActionLogger` to easily access `CrashlyticsLogger` as the default logger.
public extension ActionLogger where Self == CrashlyticsLogger {
    
    /// A convenience property to instantiate `CrashlyticsLogger`.
    ///
    /// Example usage:
    /// ```swift
    /// let logger: ActionLogger = .crashlytics
    /// ```
    static var crashlytics: ActionLogger { CrashlyticsLogger() }
}
