precedencegroup ForwardApplication {
    associativity: left
}

// Pipe Forward operator
infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

// Forward Compose (or Right Arrow) operator
infix operator >>>: ForwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in
        g(f(a))
    }
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

// Diamond operator
infix operator <>: SingleTypeComposition

func <> <A>(
    f: @escaping (A) -> A,
    g: @escaping (A) -> A)
    -> ((A) -> A) {
        return f >>> g
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { a in { b in { c in f(a, b, c) } } }
}

func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    
    return { b in { a in f(a)(b) } }
}

func flip<A, C>(_ f: @escaping (A) -> () -> C) -> () -> (A) -> C {
    
    return { { a in f(a)() } }
}

func zurry<A>(_ f: () -> A) -> A {
    return f()
}

precedencegroup BackwardsComposition {
    associativity: left
}

// Backward Compose (or Left Arrow) operator
infix operator <<<: BackwardsComposition

func <<< <A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
    return { f(g($0)) }
}

public func map<A, B>(_ transform: @escaping (A) -> B) -> ([A]) -> [B] {
    return { xs in xs.map(transform) }
}

func map<A, B>(_ transform: @escaping (A) -> B) -> (A?) -> B? {
    return { $0.map(transform) }
}

func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
    -> (@escaping (Value) -> Value)
    -> (Root) -> Root {
        
        return { update in
            { root in
                var copy = root
                copy[keyPath: kp] = update(copy[keyPath: kp])
                return copy
            }
        }
}

func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return { root in
        root[keyPath: kp]
    }
}

func their<Root, Value>(_ f: @escaping (Root) -> Value, _ g: @escaping (Value, Value) -> Bool) -> (Root, Root) -> Bool {
    
    return { g(f($0), f($1)) }
}

func their<Root, Value: Comparable>(_ f: @escaping (Root) -> Value) -> (Root, Root) -> Bool {
    
    return their(f, <)
}

func combining<Root, Value>(
    _ f: @escaping (Root) -> Value,
    by g: @escaping (Value, Value) -> Value
    )
    -> (Value, Root)
    -> Value {
        
        return { value, root in
            g(value, f(root))
        }
}

prefix operator ^
prefix func ^ <Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
    return get(kp)
}
