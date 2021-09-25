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
class NFABuilderMultipleTest extends Test
{
	function test()
	{
		var expr:Expression = Parser.run(Lexer.run('(a+a*)+'));
		var string = 'aaaaaaaaaaaaaaaaaaaaaaaaaa@';
		
		var nfa = NFABuilder.run(expr);
		
		trace('initialState:${nfa.initialState.id}');
		trace('finalStates:${nfa.finalStates.map(s->s.id)}');
		
		var states = [nfa.initialState];
		nfa.initialState.iter((_, _, dst) -> states.unshift(dst));
		trace(states.map(src -> src.getInputs().map(input -> src.get(input).map(dst -> '($src, $input) => $dst')).squeezeArray()).squeezeArray().join('\n'));
		
		Assert.isFalse(match(nfa, string));
	}
	
	function match(nfa:NFA, s:String)
	{
		var i = 0;
		var state:Array<NFAState> = [nfa.initialState];
		trace(state);
		while (i < s.length)
		{
			state = state.map(src -> src.getReachable(NFAInput.Eps).map(src -> src.simulate(s.charAt(i))).squeezeArray()).squeezeArray();
			
			trace(state);
			
			if (state.length == 0) return false;
			
			i++;
		}
		
		return !nfa.finalStates.excludes(state);
	}
}