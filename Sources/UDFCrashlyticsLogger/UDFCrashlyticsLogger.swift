import UDF
import FirebaseCrashlytics

/// `CrashlyticsLogger` is a custom logger that conforms to `ActionLogger` and integrates with Firebase Crashlytics.
/// It logs actions to Firebase Crashlytics, with special handling for errors and memory warnings.
///
/// This logger:
/// - Filters out irrelevant actions, such as `UpdateFormField` actions.
/// - Logs errors to Crashlytics with detailed information, including error codes and descriptions.
/// - Logs standard actions to Crashlytics as simple log entries.
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
    /// This method handles the following cases:
    /// - Logs `Actions.Error` with the error ID and description to Crashlytics as an `NSError`.
    /// - Logs `Actions.ApplicationDidReceiveMemoryWarning` as an `NSError`.
    /// - Logs other actions as simple log entries to Crashlytics.
    public func log(_ action: LoggingAction, description: String) {
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
            // Log other actions as simple log entries
            Crashlytics.crashlytics().log(description)
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
