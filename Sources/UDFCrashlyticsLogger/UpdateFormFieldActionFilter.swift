
import UDF

/// `UpdateFormFieldActionFilter` is the filter to ignore all `UpdateFormField` actions
open class UpdateFormFieldActionFilter: @unchecked Sendable, ActionFilter {
    public init() {}

    open func include(action: LoggingAction) -> Bool {
        let description = String(describing: action)
        return !description.contains("UpdateFormField")
    }
}
