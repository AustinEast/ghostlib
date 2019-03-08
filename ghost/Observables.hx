package ghost;

/**
 * Implements the Observer Pattern as detailed: https://code.haxe.org/category/design-patterns/observer.html
 */
interface Observer {
  public function notified(sender:{}, ?data:Any):Void;
}
/**
 * Implements the Observer Pattern as detailed: https://code.haxe.org/category/design-patterns/observer.html
 */
class Observable {
  private var observers:Array<Observer> = [];

  private function notify<T>(?data:T) {
    for (obs in observers) obs.notified(this, data);
  }

  public function add_observer(observer:Observer) {
    observers.push(observer);
  }

  public function remove_observer(observer:Observer) {
    observers.remove(observer);
  }
}
