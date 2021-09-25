package parser;

using Lambda;

/**
 * ...
 * @author leonaci
 */
class Lexer 
{
	private static var SYMBOLS:Array<Symbol> = Symbol.allEnums();
	private static var EX_SYMBOLS:Array<ExtraSymbol> = ExtraSymbol.allEnums();
	
	static public function run(string:String):Array<Token>
	{
		var reader = new StringReader(string);
		
		var tokens:Array<Token> = [];
		
		var it:StringIterator = reader.iterator();
		while (it.hasNext())
		{
			readToken(it.next(), it, tokens);
		}
		
		tokens.push(Token.EOF);
		
		return tokens;
	}
	
	static private function readToken(s:String, it:StringIterator, tokens:Array<Token>):Void
	{
		switch(s)
		{
			case _ if (SYMBOLS.has(s)): readSymbol(s, it, tokens);
			case '\\': it.hasNext()? readEscape(it.next(), it, tokens) : throw 'no escape character is found.';
			case _: tokens.push(Token.Identifier(s));
		}
	}
	
	static private function readSymbol(s:Symbol, it:StringIterator, tokens:Array<Token>):Void
	{
		switch(s)
		{
			case Union | Star | Plus | Question | Dot | Comma | LeftParen | RightParen | LeftBracket | RightBracket | LeftCurlyBracket | RightCurlyBracket | Circumflex | Hyphen: tokens.push(Token.Symbol(s));
		}
	}
	
	static private function readEscape(s:String, it:StringIterator, tokens:Array<Token>):Void
	{
		switch(s)
		{
			case _ if (EX_SYMBOLS.has(s)): readExtraSymbol(s, it, tokens);
			case _: tokens.push(Token.Identifier(s));
		}
	}
	
	static private function readExtraSymbol(s:ExtraSymbol, it:StringIterator, tokens:Array<Token>):Void
	{
		switch(s)
		{
			case d | D | w | W: tokens.push(Token.ExtraSymbol(s));
		}
	}
}

abstract StringReader(String)
{
	public inline function new(v:String) this = v;
	
	public inline function iterator():StringIterator
	{
		var i = 0;
		return {
			hasNext : () -> i < this.length,
			next : () -> this.charAt(i++),
			peek : () -> this.charAt(i),
		}
	}
}

private typedef StringIterator = {
	function hasNext():Bool;
	function next():String;
	function peek():String;
}