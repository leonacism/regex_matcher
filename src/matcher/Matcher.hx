package matcher;

/**
 * ...
 * @author leonaci
 */
interface Matcher 
{
	public var r(default, null):String;
	
	public function match(s:String):Bool;
}