import Foundation

extension Measurement {
    var integerDescription: String {
        let integerValueString = String(Int(self.value))
        let symbolString = self.unit.symbol
        return integerValueString + " " + symbolString
    }
}
