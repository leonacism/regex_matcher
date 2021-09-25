package test.cases;
import nfa.NFABuilder;
import nfa.NFAInput;
import nfa.NFAState;
import parser.Lexer;
import parser.Parser;
import parser.ast.Expression;
import utest.Assert;
import utest.Test;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class NFABuilderSingleTest extends Test
{
	function test()
	{
		var expr:Expression = Parser.run(Lexer.run('(a+a*)+'));
		var string = 'aaaaaaaaaaaaaaa@';
		
		var nfa = NFABuilder.run(expr);
		
		trace('initialState:${nfa.initialState.id}');
		trace('finalStates:${nfa.finalStates.map(s->s.id)}');
		
		var states = [nfa.initialState];
		nfa.initialState.iter((_, _, dst) -> states.unshift(dst));
		trace(states.map(src -> src.getInputs().map(input -> src.get(input).map(dst -> '($src, $input) => $dst')).squeezeArray()).squeezeArray().join('\n'));
		
		Assert.isFalse(match(nfa, string));
		trace(c);
	}
	
	static var c = 0;
	function match(nfa:NFA, s:String)
	{
		return _match(nfa, 0, s, nfa.initialState);
	}
	
	function _match(nfa:NFA, i:Int, s:String, state:NFAState)
	{
		if (i == s.length) return nfa.finalStates.has(state);
		
		for (nextState in state.map.keys())
		{
			switch (state.map[nextState])
			{
				case NFAInput.Any (excludes):
				{
					if (!excludes.has(s.charAt(i)) && _match(nfa, i + 1, s, nextState)) return true;
				}
				case NFAInput.Some(includes):
				{
					if ( includes.has(s.charAt(i)) && _match(nfa, i + 1, s, nextState)) return true;
				}
				case NFAInput.AnyEps (excludes):
				{
					if (!excludes.has(s.charAt(i)) && _match(nfa, i + 1, s, nextState)) return true;
					if (_match(nfa, i    , s, nextState)) return true;
				}
				case NFAInput.SomeEps(includes):
				{
					if ( includes.has(s.charAt(i)) && _match(nfa, i + 1, s, nextState)) return true;
					if (_match(nfa, i    , s, nextState)) return true;
				}
				case NFAInput.Eps:
				{
					if (_match(nfa, i    , s, nextState)) return true;
				}
			}
			c++;
		}
		
		return false;
	}
}