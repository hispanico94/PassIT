import RxDataSources

struct PassTableSection {
    var header: Region
    var items: [Item]
    
    init(passes: [Pass], title: Region) {
        self.header = title
        self.items = passes
    }
    
}

extension PassTableSection: SectionModelType {
    typealias Item = Pass
    
    init(original: PassTableSection, items: [Pass]) {
        self = original
        self.items = items
    }
}

