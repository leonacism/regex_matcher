package parser;

/**
 * @author leonaci
 */
enum Token
{
	Symbol(s:Symbol);
	Identifier(c:String);
	ExtraSymbol(c:ExtraSymbol);
	EOF;
}