import UDF

/// `UpdateFormFieldActionFilter` is a custom action filter that ignores all actions related to form field updates, specifically actions that contain "UpdateFormField" in their description.
///
/// This filter is useful when logging actions in an application but you want to exclude the `UpdateFormField` actions from being logged, as they may be frequent and unnecessary to track.
/// This example creates a `CrashlyticsLogger` that ignores all actions containing "UpdateFormField".
open class UpdateFormFieldActionFilter: @unchecked Sendable, ActionFilter {
    
    /// Initializes a new instance of `UpdateFormFieldActionFilter`.
    public init() {}
    
    /// Determines whether the given `LoggingAction` should be included in logging.
    ///
    /// - Parameter action: The action to check.
    /// - Returns: `true` if the action should be logged, `false` if the action should be excluded (i.e., if it contains "UpdateFormField").
    open func include(action: LoggingAction) -> Bool {
        let description = String(describing: action)
        return !description.contains("UpdateFormField")
    }
}
