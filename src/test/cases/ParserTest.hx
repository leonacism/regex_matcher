package test.cases;
import parser.Lexer;
import parser.Parser;
import parser.ast.Either;
import parser.ast.Expression;
import parser.ast.Factor;
import parser.ast.Sequence;
import parser.ast.Suffix;
import parser.ast.Union;
import utest.Assert;
import utest.Test;

/**
 * ...
 * @author leonaci
 */
class ParserTest extends Test
{
	function testParseIdentifier() 
	{
		var ast = Parser.run(Lexer.run('a'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EIdentifier('a'),
							null
						),
					]),
				])
			)
		), Std.string(ast));
	}
	
	function testParseDot()
	{
		var ast = Parser.run(Lexer.run('.'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EDot,
							null
						),
					]),
				])
			)
		), Std.string(ast));
	}
	
	function testParseExtraSymbol()
	{
		var ast = Parser.run(Lexer.run('\\d\\D\\w\\W'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EExtraSymbol(d),
							null
						),
						Suffix.EFactor(
							Factor.EExtraSymbol(D),
							null
						),
						Suffix.EFactor(
							Factor.EExtraSymbol(w),
							null
						),
						Suffix.EFactor(
							Factor.EExtraSymbol(W),
							null
						),
					]),
				])
			)
		), Std.string(ast));
	}
	
	function testParseParensis()
	{
		var ast = Parser.run(Lexer.run('(a)'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EUnion(
								Union.ESequence([
									Sequence.ESuffix([
										Suffix.EFactor(
											Factor.EIdentifier('a'),
											null
										),
									]),
								])
							),
							null
						),
					]),
				])
			)
		), Std.string(ast));
	}
	
	function testParseBracket()
	{
		var ast = Parser.run(Lexer.run('[a-zA-Z0-9\\w.]'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EEither(
								Either.EEither(
									[
										EitherType.Identifier('a', 'z'),
										EitherType.Identifier('A', 'Z'),
										EitherType.Identifier('0', '9'),
										EitherType.ExtraSymbol(w),
										EitherType.Symbol(Dot),
									],
									true
								)
							),
							null
						),
					]),
				])
			)
		), Std.string(ast));
	}
	
	function testParseSequence() 
	{
		var ast = Parser.run(Lexer.run('a.(b)'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EIdentifier('a'),
							null
						),
						Suffix.EFactor(
							Factor.EDot,
							null
						),
						Suffix.EFactor(
							Factor.EUnion(
								Union.ESequence([
									Sequence.ESuffix([
										Suffix.EFactor(
											Factor.EIdentifier('b'),
											null
										)
									])
								])
							),
							null
						),
					]),
				])
			)
		), Std.string(ast));
	}
	
	function testParseSuffix() 
	{
		var ast = Parser.run(Lexer.run('a+b*c?d'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EIdentifier('a'),
							SuffixOp.Plus
						),
						Suffix.EFactor(
							Factor.EIdentifier('b'),
							SuffixOp.Star
						),
						Suffix.EFactor(
							Factor.EIdentifier('c'),
							SuffixOp.Question
						),
						Suffix.EFactor(
							Factor.EIdentifier('d'),
							null
						),
					]),
				])
			)
		), Std.string(ast));
	}
	
	function testParseUnion() 
	{
		var ast = Parser.run(Lexer.run('a|b*|.'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EIdentifier('a'),
							null
						),
					]),
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EIdentifier('b'),
							SuffixOp.Star
						),
					]),
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EDot,
							null
						),
					]),
				])
			)
		), Std.string(ast));
	}
	
	function testParseExpr() 
	{
		var ast = Parser.run(Lexer.run('a(b|c)+'));
		
		Assert.equals(Std.string(
			Expression.EUnion(
				Union.ESequence([
					Sequence.ESuffix([
						Suffix.EFactor(
							Factor.EIdentifier('a'),
							null
						),
						Suffix.EFactor(
							Factor.EUnion(
								Union.ESequence([
									Sequence.ESuffix([
										Suffix.EFactor(
											Factor.EIdentifier('b'),
											null
										),
									]),
									Sequence.ESuffix([
										Suffix.EFactor(
											Factor.EIdentifier('c'),
											null
										),
									]),
								])
							),
							SuffixOp.Plus
						),
					]),
				])
			)
		), Std.string(ast));
	}
}