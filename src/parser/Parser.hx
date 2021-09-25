package parser;
import parser.ast.Either;
import parser.ast.Expression;
import parser.ast.Factor;
import parser.ast.Sequence;
import parser.ast.Suffix;
import parser.ast.Suffix.SuffixOp;
import parser.ast.Union;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class Parser 
{
	static private var DIGITS:Array<String> = '0123456789'.split('');
	
	static public function run(tokens:Array<Token>):Expression
	{
		var it = new TokenReader(tokens).iterator();
		
		return switch(parseExpression(it))
		{
			case ParseResult.Success(expr): expr;
			case ParseResult.Failure(actual): throw 'syntax error: unexpected token: $actual';
		}
	}
	
	/*
	 * <expr> := <union><eof>
	 */
	static private function parseExpression(it:TokenIterator):ParseResult<Expression>
	{
		return switch(parseUnion(it))
		{
			case ParseResult.Success(union):
			{
				nextWithValidation(it, Token.EOF);
				
				ParseResult.Success(Expression.EUnion(union));
			}
			case ParseResult.Failure(token): ParseResult.Failure(token);
		}
	}
	
	/*
	 * <union> := <seq>('|'<seq>)*
	 */
	static private function parseUnion(it:TokenIterator):ParseResult<Union>
	{
		return switch(parseSequence(it))
		{
			case ParseResult.Success(seq):
			{
				var seqs:Array<Sequence> = [seq];
				
				while (true)
				{
					switch(it.peek())
					{
						case Token.Symbol(Union):
						{
							it.next();
							
							switch(parseSequence(it))
							{
								case ParseResult.Success(seq): seqs.push(seq);
								case ParseResult.Failure(actual): throw 'syntax error: unexpected token: $actual';
							}
						}
						case _: break;
					}
				}
				
				ParseResult.Success(Union.ESequence(seqs));
			}
			case ParseResult.Failure(token): ParseResult.Failure(token);
		}
	}
	
	/*
	 * <seq> := <suffix>+
	 */
	static private function parseSequence(it:TokenIterator):ParseResult<Sequence>
	{
		return switch(parseSuffix(it))
		{
			case ParseResult.Success(suffix):
			{
				var suffixes:Array<Suffix> = [suffix];
				
				while (true)
				{
					switch(parseSuffix(it))
					{
						case ParseResult.Success(suffix): suffixes.push(suffix);
						case ParseResult.Failure(_): break;
					}
				}
				
				ParseResult.Success(Sequence.ESuffix(suffixes));
			}
			case ParseResult.Failure(token): ParseResult.Failure(token);
		}
	}
	
	/*
	 * <suffix> := <factor>|<factor>('*'|'+'|'?'|'{'<range>'}')
	 */
	static private function parseSuffix(it:TokenIterator):ParseResult<Suffix>
	{
		return switch(parseFactor(it))
		{
			case ParseResult.Success(factor):
			{
				var op = switch(it.peek())
				{
					case Token.Symbol(Star):
					{
						it.next();
						
						SuffixOp.Star;
					}
					case Token.Symbol(Plus):
					{
						it.next();
						
						SuffixOp.Plus;
					}
					case Token.Symbol(Question):
					{
						it.next();
						
						SuffixOp.Question;
					}
					case Token.Symbol(LeftCurlyBracket):
					{
						it.next();
						
						switch(parseRange(it))
						{
							case ParseResult.Success(range):
							{
								nextWithValidation(it, Token.Symbol(RightCurlyBracket));
								
								range;
							}
							case ParseResult.Failure(actual): throw 'syntax error: unexpected token: $actual';
						}
					}
					case _: null;
				}
				
				ParseResult.Success(Suffix.EFactor(factor, op));
			}
			case ParseResult.Failure(token): ParseResult.Failure(token);
		}
	}
	
	/*
	 * <range> := <number>(','<number>?)?
	 */
	static private function parseRange(it:TokenIterator):ParseResult<SuffixOp>
	{
		return switch(parseNumber(it))
		{
			case ParseResult.Success(min):
			{
				switch(it.peek())
				{
					case Token.Symbol(Comma):
					{
						it.next();
						
						var max:Null<Int> = switch(parseNumber(it))
						{
							case ParseResult.Success(max):
							{
								if (max < min) throw 'syntax error: invalid repeatation range';
								max;
							}
							case ParseResult.Failure(_): null;
						}
						
						ParseResult.Success(SuffixOp.Range(min, max));
					}
					case _: ParseResult.Success(SuffixOp.Range(min, min));
				}
			}
			case ParseResult.Failure(token): ParseResult.Failure(token);
		}
	}
	
	/*
	 * <number> ('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9')+
	 */
	static private function parseNumber(it:TokenIterator):ParseResult<Int>
	{
		var digits:String = '';
		
		while (true) switch(it.peek())
		{
			case Token.Identifier(d) if(DIGITS.has(d)):
			{
				it.next();
				
				digits += d;
			}
			case Token.Identifier(d) if (StringTools.isSpace(d, 0)):
			{
				it.next();
			}
			case _: break;
		}
		
		var num = Std.parseInt(digits);
		
		return num != null? ParseResult.Success(num) : ParseResult.Failure(it.peek());
	}
	
	/*
	 * <factor> := '('<union>')'|'['<either>']'|'.'|<identifier>|<extended_symbol>
	 */
	static private function parseFactor(it:TokenIterator):ParseResult<Factor>
	{
		return switch(it.peek())
		{
			case Token.Symbol(LeftParen):
			{
				it.next();
				
				switch(parseUnion(it))
				{
					case ParseResult.Success(union):
					{
						nextWithValidation(it, Token.Symbol(RightParen));
						
						ParseResult.Success(Factor.EUnion(union));
					}
					case ParseResult.Failure(actual): throw 'syntax error: unexpected token: $actual';
				}
			}
			case Token.Symbol(LeftBracket):
			{
				it.next();
				
				switch(parseEither(it))
				{
					case ParseResult.Success(either):
					{
						nextWithValidation(it, Token.Symbol(RightBracket));
						
						ParseResult.Success(Factor.EEither(either));
					}
					case ParseResult.Failure(actual): throw 'syntax error: unexpected token: $actual';
				}
			}
			case Token.Identifier(c):
			{
				it.next();
				
				ParseResult.Success(Factor.EIdentifier(c));
			}
			case Token.Symbol(Dot):
			{
				it.next();
				
				ParseResult.Success(Factor.EDot);
			}
			case Token.ExtraSymbol(c):
			{
				it.next();
				
				ParseResult.Success(Factor.EExtraSymbol(c));
			}
			case token: ParseResult.Failure(token);
		}
	}
	
	/*
	 * <either> := '^'?(<identifier>('-'<identifier>)?|<symbol>|<extended_symbol>)+
	 */
	static private function parseEither(it:TokenIterator):ParseResult<Either>
	{
		var es = [];
		
		var negative:Bool = switch(it.peek())
		{
			case Token.Symbol(Circumflex):
			{
				it.next();
				
				true;
			}
			case _: false;
		}
		
		do
		{
			var e = switch(it.peek())
			{
				case Token.Symbol(RightBracket): break;
				case Token.Identifier(c1):
				{
					it.next();
					
					switch(it.peek())
					{
						case Token.Symbol(Hyphen):
						{
							it.next();
							
							switch(it.peek())
							{
								case Token.Identifier(c2):
								{
									it.next();
									
									EitherType.Identifier(c1, c2);
								}
								case actual: throw 'syntax error: unexpected token: $actual';
							}
						}
						case _: EitherType.Identifier(c1, null);
					}
				}
				case Token.Symbol(s):
				{
					it.next();
					
					EitherType.Symbol(s);
				}
				case Token.ExtraSymbol(s):
				{
					it.next();
					
					EitherType.ExtraSymbol(s);
				}
				case token: break;
			}
			
			if (!es.has(e, eitherTypeEquals)) es.push(e);
		}
		while (true);
		
		return es.length > 0? ParseResult.Success(Either.EEither(es, negative)) : ParseResult.Failure(it.peek());
	}
	
	static private function eitherTypeEquals(e1:EitherType, e2:EitherType):Bool
	{
		return switch [e1, e2]
		{
			case [EitherType.Identifier(c1, c2), EitherType.Identifier(c3, c4)] if (c1 == c3 && c2 == c4): true;
			case [EitherType.Symbol(s1), EitherType.Symbol(s2)] if (s1 == s2): true;
			case [EitherType.ExtraSymbol(s1), EitherType.ExtraSymbol(s2)] if (s1 == s2): true;
			case _: false;
		}
	}
	
	static private function nextWithValidation(it:TokenIterator, expect:Token):Void
	{
		switch [it.next(), expect]
		{
			case [Token.Symbol(s1), Token.Symbol(s2)] if(s1 == s2):
			case [Token.Identifier(s1), Token.Identifier(s2)] if(s1 == s2):
			case [Token.EOF, Token.EOF]:
			case [actual, expect]:
			{
				throw 'syntax error: $expect is expected, but $actual.';
			}
		}
	}
}

abstract TokenReader(Array<Token>)
{
	public inline function new(v:Array<Token>) this = v;
	
	public inline function iterator():TokenIterator
	{
		var i = 0;
		return {
			hasNext : () -> i < this.length,
			next : () -> this[i++],
			peek : () -> this[i],
		}
	}
}

private typedef TokenIterator = {
	function hasNext():Bool;
	function next():Token;
	function peek():Token;
}

private enum ParseResult<T>
{
	Success(result:T);
	Failure(token:Token);
}