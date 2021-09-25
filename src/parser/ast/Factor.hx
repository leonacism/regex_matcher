package parser.ast;

/**
 * @author leonaci
 */
enum Factor
{
	EUnion(union:Union);
	EEither(either:Either);
	EIdentifier(c:String);
	EDot;
	EExtraSymbol(s:ExtraSymbol);
}