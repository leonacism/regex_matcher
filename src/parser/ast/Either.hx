package parser.ast;

/**
 * @author leonaci
 */
enum Either 
{
	EEither(es:Array<EitherType>, negative:Bool);
}

enum EitherType
{
	Identifier(c1:String, c2:Null<String>);
	Symbol(s:Symbol);
	ExtraSymbol(s:ExtraSymbol);
}