
public enum List<T> {
    case empty
    indirect case cons(T, List<T>)
}
