
import UDF
import FirebaseCrashlytics

/// `CrashlyticsLogger` is a custom ActionLogger for SwiftUI-UDF that logs all actions directly to FirebaseCrashlytics.
/// CrashlyticsLogger is ignoring all `UpdateFormField` actions
public struct CrashlyticsLogger: ActionLogger {
    public var actionFilters: [ActionFilter]
    public var actionDescriptor: ActionDescriptor

    public init(
        actionFilters: [ActionFilter] = [UpdateFormFieldActionFilter()],
        actionDescriptor: ActionDescriptor = StringDescribingActionDescriptor()
    ) {
        self.actionFilters = actionFilters
        self.actionDescriptor = actionDescriptor
    }

    public func log(_ action: LoggingAction, description: String) {
        switch action.value {
        case let errorAction as Actions.Error:
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString(description, comment: ""),
                "error_id": errorAction.id
            ]

            let error = NSError(
                domain: "Actions.Error",
                code: errorAction.code,
                userInfo: userInfo
            )

            Crashlytics.crashlytics().record(error: error)

        case is Actions.ApplicationDidReceiveMemoryWarning:
            let error = NSError(
                domain: "Actions.ApplicationDidReceiveMemoryWarning",
                code: 101,
                userInfo: nil
            )

            Crashlytics.crashlytics().record(error: error)

        default:
            Crashlytics.crashlytics().log(description)
        }
    }
}

public extension ActionLogger where Self == CrashlyticsLogger {
    static var crashlytics: ActionLogger { CrashlyticsLogger() }
}
