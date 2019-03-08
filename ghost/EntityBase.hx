package ghost;

import ghost.Disposable;

@:generic
class EntityBase<T> implements IDisposable {
  public var active:Bool;
  public var base:T;
  public var time_scale:Float;
  public var disposed(default, null):Bool;

  var components:Map<String, ComponentBase<T>>;
  var component_arr:Array<ComponentBase<T>>;

  public function new(?base:T) {
    active = true;
    disposed = false;
    components = [];
    component_arr = [];
    if (base != null) this.base = base;
  }

  public function add(component:ComponentBase<T>, ?name:String):ComponentBase<T> {
    remove(name == null ? component.name : name);
    components.set(name == null ? component.name : name, component);
    component_arr.push(component);
    component.added(this);
    return component;
  }

  public function remove(name:String):Null<ComponentBase<T>> {
    var component = get(name);
    if (component != null) {
      components.remove(component.name);
      component_arr.remove(component);
      component.removed();
      return component;
    }
    return null;
  }

  public inline function has(name:String):Bool return components.exists(name);

  public inline function get(name:String):Null<ComponentBase<T>> return components[name];

  public function pre_step(dt:Float) for (component in component_arr) component.pre_step(dt);

  public function step(dt:Float) for (component in component_arr) component.step(dt);

  public function post_step(dt:Float) for (component in component_arr) component.post_step(dt);

  function send(event:String, ?data:Dynamic) for (component in component_arr) component.handle(event, data);

  @:allow(ghost.ComponentBase.send)
  function handle(event:String, ?data:Dynamic) send(event, data);

  public function dispose() {
    active = false;
    disposed = true;
    components = null;
    Disposable.disposeArray(component_arr);
  }
}
