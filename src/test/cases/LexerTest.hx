package test.cases;
import parser.Lexer;
import parser.Symbol;
import parser.Token;
import utest.Assert;
import utest.Test;

/**
 * ...
 * @author leonaci
 */
class LexerTest extends Test
{
	function testAnalysis() 
	{
		var result = Lexer.run('');
		
		Assert.isTrue(result.length == 1);
		Assert.equals(result[0], Token.EOF);
	}
	
	function testSymbols() 
	{
		var result = Lexer.run('|+*.?()[]');
		
		Assert.equals(Std.string(result[0]), Std.string(Token.Symbol(Union)));
		Assert.equals(Std.string(result[1]), Std.string(Token.Symbol(Plus)));
		Assert.equals(Std.string(result[2]), Std.string(Token.Symbol(Star)));
		Assert.equals(Std.string(result[3]), Std.string(Token.Symbol(Dot)));
		Assert.equals(Std.string(result[4]), Std.string(Token.Symbol(Question)));
		Assert.equals(Std.string(result[5]), Std.string(Token.Symbol(LeftParen)));
		Assert.equals(Std.string(result[6]), Std.string(Token.Symbol(RightParen)));
		Assert.equals(Std.string(result[7]), Std.string(Token.Symbol(LeftBracket)));
		Assert.equals(Std.string(result[8]), Std.string(Token.Symbol(RightBracket)));
	}
	
	function testEscape() 
	{
		var result = Lexer.run('\\|\\+\\*\\.\\?\\(\\)\\[\\]\\\\\\d\\D\\w\\W');
		
		Assert.equals(Std.string(result[ 0]), Std.string(Token.Identifier('|')));
		Assert.equals(Std.string(result[ 1]), Std.string(Token.Identifier('+')));
		Assert.equals(Std.string(result[ 2]), Std.string(Token.Identifier('*')));
		Assert.equals(Std.string(result[ 3]), Std.string(Token.Identifier('.')));
		Assert.equals(Std.string(result[ 4]), Std.string(Token.Identifier('?')));
		Assert.equals(Std.string(result[ 5]), Std.string(Token.Identifier('(')));
		Assert.equals(Std.string(result[ 6]), Std.string(Token.Identifier(')')));
		Assert.equals(Std.string(result[ 7]), Std.string(Token.Identifier('[')));
		Assert.equals(Std.string(result[ 8]), Std.string(Token.Identifier(']')));
		Assert.equals(Std.string(result[ 9]), Std.string(Token.Identifier('\\')));
		Assert.equals(Std.string(result[10]), Std.string(Token.ExtraSymbol(d)));
		Assert.equals(Std.string(result[11]), Std.string(Token.ExtraSymbol(D)));
		Assert.equals(Std.string(result[12]), Std.string(Token.ExtraSymbol(w)));
		Assert.equals(Std.string(result[13]), Std.string(Token.ExtraSymbol(W)));
	}
}