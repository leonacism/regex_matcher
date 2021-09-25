package parser.ast;

/**
 * @author leonaci
 */
enum Suffix
{
	EFactor(factor:Factor, op:Null<SuffixOp>);
}

enum SuffixOp
{
	Star;
	Plus;
	Question;
	Range(min:Int, max:Null<Int>);
}