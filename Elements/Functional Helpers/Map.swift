func map<A, B>(_ transform: @escaping (A) -> B) -> ([A]) -> [B] {
    return { xs in xs.map(transform) }
}

func map<A, B>(_ transform: @escaping (A) -> B) -> (A?) -> B? {
    return { $0.map(transform) }
}
