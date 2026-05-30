/// Estados posibles de una vista — base de la idea **ui = f(state)**.
///
/// La vista NO toma decisiones por sí sola: sólo lee este estado y dibuja.
enum ViewState { idle, loading, success, error }
