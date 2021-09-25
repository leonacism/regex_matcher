package nfa;
import nfa.NFAInput.NFAInputTools;
import parser.ExtraSymbol;
import parser.ast.Either;
import parser.ast.Expression;
import parser.ast.Factor;
import parser.ast.Sequence;
import parser.ast.Suffix;
import parser.ast.Union;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class NFABuilder 
{
	static public function run(expr:Expression):NFA
	{
		var context = new NFAContext();
		
		return switch(expr)
		{
			case Expression.EUnion(union): buildUnionNFA(context, union);
		}
	}
	
	static private function buildUnionNFA(context:NFAContext, union:Union):NFA
	{
		return switch(union)
		{
			case Union.ESequence(seqs):
			{
				var nfas:Array<NFA> = seqs.map(seq -> buildSequenceNFA(context, seq));
				
				var q0 = context.alloc();
				
				var length = nfas.length;
				var s0:Array<NFAState> = nfas.map(nfa -> nfa.initialState);
				var s1s:Array<Array<NFAState>> = nfas.map(nfa -> nfa.finalStates);
				
				for (i in 0...length) q0.set(NFAInput.Eps, s0[i]);
				
				{
					initialState : q0,
					finalStates : Lambda.flatten(s1s),
				}
			}
		}
	}
	
	static private function buildSequenceNFA(context:NFAContext, seq:Sequence):NFA
	{
		return switch(seq)
		{
			case Sequence.ESuffix(suffixes):
			{
				var nfas:Array<NFA> = suffixes.map(suffix -> buildSuffixNFA(context, suffix));
				
				var length = nfas.length;
				var s0:Array<NFAState> = nfas.map(nfa -> nfa.initialState);
				var s1s:Array<Array<NFAState>> = nfas.map(nfa -> nfa.finalStates);
				
				for (i in 0...length-1)
				{
					for(s1 in s1s[i]) s1.set(NFAInput.Eps, s0[i + 1]);
				}
				
				{
					initialState : s0[0],
					finalStates : s1s[length-1],
				}
			}
		}
	}
	
	static private function buildSuffixNFA(context:NFAContext, suffix:Suffix):NFA
	{
		return switch(suffix)
		{
			case Suffix.EFactor(factor, null): buildFactorNFA(context, factor);
			case Suffix.EFactor(factor, SuffixOp.Star | SuffixOp.Range(0, null)):
			{
				var nfa:NFA = buildFactorNFA(context, factor);
				
				var q0 = context.alloc();
				var q1 = context.alloc();
				
				var s0 = nfa.initialState;
				q0.set(NFAInput.Eps, q1);
				q0.set(NFAInput.Eps, s0);
				
				for (s1 in nfa.finalStates)
				{
					s1.set(NFAInput.Eps, s0);
					s1.set(NFAInput.Eps, q1);
				}
				
				{
					initialState : q0,
					finalStates : [q1],
				}
			}
			case Suffix.EFactor(factor, SuffixOp.Plus | SuffixOp.Range(1, null)):
			{
				var nfa:NFA = buildFactorNFA(context, factor);
				
				var q1 = context.alloc();
				
				var s0 = nfa.initialState;
				
				for (s1 in nfa.finalStates)
				{
					s1.set(NFAInput.Eps, s0);
					s1.set(NFAInput.Eps, q1);
				}
				
				{
					initialState : s0,
					finalStates : [q1],
				}
			}
			case Suffix.EFactor(factor, SuffixOp.Question):
			{
				var nfa:NFA = buildFactorNFA(context, factor);
				
				var s0 = nfa.initialState;
				var s1s = nfa.finalStates;
				
				for (s1 in s1s) s0.set(NFAInput.Eps, s1);
				
				{
					initialState : s0,
					finalStates : s1s,
				}
			}
			case Suffix.EFactor(factor, SuffixOp.Range(length, null)):
			{
				var nfas:Array<NFA> = [for(i in 0...length) buildFactorNFA(context, factor)];
				
				var s0:Array<NFAState> = nfas.map(nfa -> nfa.initialState);
				var s1s:Array<Array<NFAState>> = nfas.map(nfa -> nfa.finalStates);
				
				var q1 = context.alloc();
				
				for (i in 0...length-1) for(s1 in s1s[i]) s1.set(NFAInput.Eps, s0[i + 1]);
				
				for (s1 in s1s[length - 1])
				{
					s1.set(NFAInput.Eps, s0[length-1]);
					s1.set(NFAInput.Eps, q1);
				}
				
				{
					initialState : s0[0],
					finalStates : [q1],
				}
			}
			case Suffix.EFactor(factor, SuffixOp.Range(min, max)):
			{
				var length = max;
				
				var nfas:Array<NFA> = [for(i in 0...length) buildFactorNFA(context, factor)];
				
				var s0:Array<NFAState> = nfas.map(nfa -> nfa.initialState);
				var s1s:Array<Array<NFAState>> = nfas.map(nfa -> nfa.finalStates);
				
				var q1 = max == 0? context.alloc() : s0[0];
				
				for (i in 0...length-1) for(s1 in s1s[i]) s1.set(NFAInput.Eps, s0[i + 1]);
				
				{
					initialState : q1,
					finalStates : (min == 0? [q1] : [for (s1 in s1s[min - 1]) s1]).concat([for (i in min...max) for (s1 in s1s[i]) s1]),
				}
			}
		}
	}
	
	static private function buildFactorNFA(context:NFAContext, factor:Factor):NFA
	{
		return switch(factor)
		{
			case Factor.EUnion(union): buildUnionNFA(context, union);
			case Factor.EEither(either): buildEitherNFA(context, either);
			case Factor.EDot:
			{
				var q0 = context.alloc();
				var q1 = context.alloc();
				
				q0.set(NFAInput.Any([]), q1);
				
				{
					initialState : q0,
					finalStates : [q1],
				}
			}
			case Factor.EIdentifier(c):
			{
				var q0 = context.alloc();
				var q1 = context.alloc();
				
				q0.set(NFAInput.Some([c]), q1);
				
				{
					initialState : q0,
					finalStates : [q1],
				}
			}
			case Factor.EExtraSymbol(c):
			{
				var q0 = context.alloc();
				var q1 = context.alloc();
				
				q0.set(toInput(c), q1);
				
				{
					initialState : q0,
					finalStates : [q1],
				}
			}
		}
	}
	
	static private function buildEitherNFA(context:NFAContext, either:Either):NFA
	{
		return switch(either)
		{
			case Either.EEither(es, negative):
			{
				var input:NFAInput = es.map(e -> switch(e) {
					case EitherType.Symbol(s): NFAInput.Some([s]);
					case EitherType.ExtraSymbol(c): toInput(c);
					case EitherType.Identifier(c, null): NFAInput.Some([c]);
					case EitherType.Identifier(c1, c2):
					{
						var begin = c1.charCodeAt(0);
						var end = c2.charCodeAt(0);
						if (begin > end) throw 'error: invalid character range';
						NFAInput.Some([for (code in begin...end+1) String.fromCharCode(code)]);
					}
				}).squeeze(NFAInputTools.sum).getOrElse(null);
				
				var q0 = context.alloc();
				var q1 = context.alloc();
				
				q0.set(negative? input.flip() : input, q1);
				
				{
					initialState : q0,
					finalStates : [q1],
				}
			}
		}
	}
	
	static private function toInput(c:ExtraSymbol):NFAInput
	{
		return switch(c)
		{
			case d: NFAInput.Some('0123456789'.split(''));
			case D: NFAInput.Any ('0123456789'.split(''));
			case w: NFAInput.Some('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789'.split(''));
			case W: NFAInput.Any ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789'.split(''));
		}
	}
}

typedef NFA =
{
	var initialState:NFAState;
	var finalStates:Array<NFAState>;
}