package parser;

/**
 * ...
 * @author leonaci
 */
enum abstract ExtraSymbol(String) from String to String {
	var d;
	var D;
	var w;
	var W;
	
	static public function allEnums():Array<ExtraSymbol>
	{
		return [
			d,
			D,
			w,
			W,
		];
	}
}