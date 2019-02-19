package glib;

class State<T> {
  public function enter(parent:T) {}

  public function update(parent:T, dt:Float) {}

  public function exit(parent:T) {}
}

class FSM<T> {
  var parent:T;
  var current:State<T>;
  var requested:State<T>;

  public function new(parent:T, initialState:State<T>) {
    this.parent = parent;
    requested = initialState;
  }

  public function set(state:State<T>):State<T> return requested = state;

  public function update(dt:Float) {
    if (requested != null) {
      if (current != null) {
        current.exit(parent);
      }
      current = requested;
      current.enter(parent);
      requested = null;
    }

    current.update(parent, dt);
  }
}
