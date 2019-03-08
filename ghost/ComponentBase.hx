package ghost;

import ghost.Disposable.IDisposable;

@:generic
class ComponentBase<T> implements IDisposable {
  @:allow(EntityBase)
  public var entity(default, null):EntityBase<T>;
  public var name:String;

  public function new(name:String) {
    this.name = name;
  }

  public function added(entity:EntityBase<T>) this.entity = entity;

  public function removed() entity = null;

  public function pre_step(dt:Float) {}

  public function step(dt:Float) {}

  public function post_step(dt:Float) {}

  function send(event:String, ?data:Dynamic) if (entity != null) entity.handle(event, data);

  @:allow(ghost.EntityBase.send)
  function handle(event:String, ?data:Dynamic) {}

  public function dispose() {
    if (entity != null) entity.remove(name);
  }
}
