package glib;

/**
 *	Implementing this interface will create a getter/setter for each field that doesnt have one.
**/
@:remove
@:autoBuild(glib.Macros.proxy())
interface IProxy {}
