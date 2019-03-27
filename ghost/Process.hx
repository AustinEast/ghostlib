package ghost;

import ghost.Disposable.IDisposable;

class Process implements IDisposable {
  static var root:Array<Process> = [];
  static var ids:Int = 0;

  public var id(default, null):Int;
  public var name:String;
  public var age(default, null):Float;
  public var parent(default, set):Null<Process>;
  public var paused:Bool;
  public var persist:Bool;
  public var time_scale:Float;
  public var created(default, null):Bool;
  public var closed(default, null):Bool;
  public var disposed(default, null):Bool;

  var children:Array<Process>;

  public function new(?parent:Process) {
    id = ids++;
    age = 0;
    name = 'Process #$id';
    root.push(this);
    this.parent = parent;
    paused = false;
    persist = true;
    time_scale = 1;
    created = false;
    closed = false;
    disposed = false;
    children = [];
  }

  public static inline function update(dt:Float) for (r in root) r.try_update(dt);

  public static inline function shutdown() for (r in root) r.close();

  public function create() created = true;

  inline function try_update(dt:Float) {
    age += dt;
    if (!created) create();
    if (closed) {
      dispose();
      return;
    }
    if (paused) return;
    for (child in children) if (!child.created) child.create();
    if (children.length == 0 || persist) {
      pre_step(dt * time_scale);
      step(dt * time_scale);
      post_step(dt * time_scale);
    }
    for (child in children) if (child.created) child.try_update(dt * time_scale);
  }

  function pre_step(dt:Float) {}

  function step(dt:Float) {}

  function post_step(dt:Float) {}

  public inline function close() {
    closed = true;
    for (child in children) child.close();
  }

  public function dispose() {
    if (!closed) throw '`close()` $name instead of disposing it directly';
    for (child in children) child.dispose();
    children = null;
    parent = null;
    disposed = true;
  }

  public inline function pause() paused = true;

  public inline function resume() paused = false;

  public inline function toggle_paused() paused = !paused;

  inline function set_parent(value) {
    if (parent != null && parent.children != null) parent.children.remove(this);
    parent = value;
    if (parent != null) {
      root.remove(this);
      parent.children.push(this);
    }
    if (closed) root.remove(this);
    return parent;
  }
}
