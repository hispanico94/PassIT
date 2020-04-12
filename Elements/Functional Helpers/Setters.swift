prefix func ^ <Root, Value>(_ kp: WritableKeyPath<Root, Value>)
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

// MARK:

typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

// Apply a transformation f to a setter (via a keyPath)

func over<S, T, A, B>(
    _ setter: Setter<S, T, A, B>,
    _ f: @escaping (A) -> B
    ) -> (S) -> T {
    
    return setter(f)
}

// Set a value (via a keyPath)

func set<S, T, A, B>(
    _ setter: Setter<S, T, A, B>,
    _ value: B
    ) -> (S) -> T {
    
    return over(setter, { _ in value })
}

// MARK: - Mutable (inout) setters

prefix func ^ <Root, Value>(_ kp: WritableKeyPath<Root, Value>)
    -> (@escaping (inout Value) -> Void)
    -> (inout Root) -> Void {
        
        return { update in
            return { root in
                update(&root[keyPath: kp])
            }
        }
}

// MARK:

typealias MutableSetter<S, A> = (@escaping (inout A) -> Void) -> (inout S) -> Void

// Apply a transformation f to a setter (via a keyPath)

func mver<S, A>(
    _ setter: MutableSetter<S, A>,
    _ f: @escaping (inout A) -> Void
    ) -> (inout S) -> Void {
    
    return setter(f)
}

func mut<S, A>(
    _ setter: MutableSetter<S, A>,
    _ value: A
    ) -> (inout S) -> Void {
    
    return mver(setter, { $0 = value })
}

// MARK: - Mutable (reference types) setters

prefix func ^ <Root: AnyObject, Value>(_ kp: ReferenceWritableKeyPath<Root, Value>)
    -> (@escaping (Value) -> Void)
    -> (Root) -> Void {
    return { update in
        { root in
            update(root[keyPath: kp])
        }
    }
}

// MARK:
// Apply a transformation f to a setter (via a keyPath)

func mver<S: AnyObject, A: AnyObject>(
    _ setter: (@escaping (A) -> Void) -> (S) -> Void,
    _ set: @escaping (A) -> Void
    ) -> (S) -> Void {
    return setter(set)
}

func mver<S: AnyObject, A>(
    _ setter: (@escaping (inout A) -> Void) -> (S) -> Void,
    _ set: @escaping (inout A) -> Void
    ) -> (S) -> Void {
    
    return setter(set)
}

func mut<S: AnyObject, A>(
    _ setter: (@escaping (inout A) -> Void) -> (S) -> Void,
    _ value: A
    ) -> (S) -> Void {
    return mver(setter) { $0 = value }
}
