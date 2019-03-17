package ghost;

import ghost.Disposable.IDisposable;

@:generic
class ComponentBase<T> implements IDisposable {
  public var owner(default, null):T;
  public var components(default, null):ComponentsBase<T>;
  public var name:String;

  public function new(name:String) {
    this.name = name;
  }

  public function added(components:ComponentsBase<T>) {
    this.components = components;
    this.owner = components.owner;
  }

  public function removed() {
    components = null;
    owner = null;
  }

  public function pre_step(dt:Float) {}

  public function step(dt:Float) {}

  public function post_step(dt:Float) {}

  function send(event:String, ?data:Dynamic) if (components != null) components.handle(event, data);

  @:allow(ghost.ComponentsBase.send)
  function handle(event:String, ?data:Dynamic) {}

  public function dispose() {
    if (components != null) components.remove(name);
  }
}

@:generic
class ComponentsBase<T> implements IDisposable {
  public var active:Bool;
  public var owner:T;

  var members:Map<String, ComponentBase<T>>;
  var members_fast:Array<ComponentBase<T>>;

  public function new(owner:T) {
    this.owner = owner;
    active = true;
    members = [];
    members_fast = [];
  }

  public function add(component:ComponentBase<T>, ?name:String):ComponentBase<T> {
    remove(name == null ? component.name : name);
    members.set(name == null ? component.name : name, component);
    members_fast.push(component);
    component.added(this);
    return component;
  }

  public function remove(name:String):Null<ComponentBase<T>> {
    var component = get(name);
    if (component != null) {
      members.remove(component.name);
      members_fast.remove(component);
      component.removed();
      return component;
    }
    return null;
  }

  public inline function has(name:String):Bool return members.exists(name);

  public inline function get(name:String):Null<ComponentBase<T>> return members[name];

  public function pre_step(dt:Float) for (component in members_fast) component.pre_step(dt);

  public function step(dt:Float) for (component in members_fast) component.step(dt);

  public function post_step(dt:Float) for (component in members_fast) component.post_step(dt);

  function send(event:String, ?data:Dynamic) for (component in members_fast) component.handle(event, data);

  @:allow(ghost.ComponentBase.send)
  function handle(event:String, ?data:Dynamic) send(event, data);

  public function dispose() {
    active = false;
    members = null;
    Disposable.disposeArray(members_fast);
  }
}
