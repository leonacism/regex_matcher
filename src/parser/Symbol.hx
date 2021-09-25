package parser;

/**
 * ...
 * @author leonaci
 */
enum abstract Symbol(String) from String to String {
	var Union = '|';
	var Star = '*';
	var Plus = '+';
	var Question = '?';
	var Dot = '.';
	var Comma = ',';
	var LeftParen = '(';
	var RightParen = ')';
	var LeftBracket = '[';
	var RightBracket = ']';
	var LeftCurlyBracket = '{';
	var RightCurlyBracket = '}';
	var Circumflex = '^';
	var Hyphen = '-';
	
	static public function allEnums():Array<Symbol>
	{
		return [
			Union,
			Star,
			Plus,
			Question,
			Dot,
			Comma,
			LeftParen,
			RightParen,
			LeftBracket,
			RightBracket,
			LeftCurlyBracket,
			RightCurlyBracket,
			Circumflex,
			Hyphen,
		];
	}
}