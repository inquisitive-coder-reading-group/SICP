
public enum List<T> {
    case Empty
    indirect case Cons(T, List<T>)
}
