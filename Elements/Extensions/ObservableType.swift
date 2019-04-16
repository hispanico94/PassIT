import Foundation
import RxSwift

extension ObservableType {
    func compactMap<R>(_ transform: @escaping (E) -> R?) -> Observable<R> {
        return self
            .map(transform)
            .filter { $0 != nil }
            .map { $0! }
    }
}
