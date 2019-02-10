import Foundation
import MapKit
import RxSwift

// Error codes
//MKError.unknown = 1
//MKError.serverFailure = 2
//MKError.loadingThrottled = 3
//MKError.placemarkNotFound = 4
//MKError.directionsNotFound = 5

enum RxMKDirectionsError: Error {
    case emptyResponse
}

extension Reactive where Base: MKDirections {
    var calculateETA: Single<MKDirections.ETAResponse> {
        return Single.create { single in
            self.base.calculateETA { response, error in
                guard error == nil else {
                    single(.error(error!))
                    return
                }
                guard let response = response else {
                    single(.error(RxMKDirectionsError.emptyResponse))
                    return
                }
                single(.success(response))
            }
            return Disposables.create()
        }
    }
}
