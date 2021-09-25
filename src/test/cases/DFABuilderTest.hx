package test.cases;
import dfa.DFABuilder;
import dfa.DFAOptimizer;
import dfa.DFAState;
import nfa.NFABuilder;
import nfa.NFAOptimizer;
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
class DFABuilderTest extends Test
{
	function test()
	{
		var expr:Expression = Parser.run(Lexer.run('(a+a*)+'));
		var string = 'aaaaaaaaaab';
		
		var nfa = NFABuilder.run(expr);
		
		trace('initialState:${nfa.initialState.id}');
		trace('finalStates:${nfa.finalStates.map(s->s.id)}');
		
		var states = [nfa.initialState];
		nfa.initialState.iter((_, _, dst) -> states.unshift(dst));
		trace(states.map(src -> src.getInputs().map(input -> src.get(input).map(dst -> '($src, $input) => $dst')).squeezeArray()).squeezeArray().join('\n'));
		
		nfa = NFAOptimizer.run(nfa);
		
		trace('initialState:${nfa.initialState.id}');
		trace('finalStates:${nfa.finalStates.map(s->s.id)}');
		
		var states = [nfa.initialState];
		nfa.initialState.iter((_, _, dst) -> states.unshift(dst));
		trace(states.map(src -> src.getInputs().map(input -> src.get(input).map(dst -> '($src, $input) => $dst')).squeezeArray()).squeezeArray().join('\n'));
		
		var dfa = DFABuilder.run(nfa);
		
		trace('initialState:${dfa.initialState.id}');
		trace('finalStates:${dfa.finalStates.map(s->s.id)}');
		
		var states = [dfa.initialState];
		dfa.initialState.iter((_, _, dst) -> states.unshift(dst));
		trace(states.map(src -> src.getInputs().map(input -> '($src, $input) => ${src.get(input)}')).squeezeArray().join('\n'));
		
		dfa = DFAOptimizer.run(dfa);
		
		trace('initialState:${dfa.initialState.id}');
		trace('finalStates:${dfa.finalStates.map(s->s.id)}');
		
		var states = [dfa.initialState];
		dfa.initialState.iter((_, _, dst) -> states.unshift(dst));
		trace(states.map(src -> src.getInputs().map(input -> '($src, $input) => ${src.get(input)}')).squeezeArray().join('\n'));
		
		Assert.isFalse(match(dfa, string));
	}
	
	function match(dfa:DFA, s:String)
	{
		var i = 0;
		var state:Null<DFAState> = dfa.initialState;
		trace(state);
		while (i < s.length)
		{
			state = state.simulate(s.charAt(i));
			
			trace(state);
			
			if (state == null) return false;
			
			i++;
		}
		
		return dfa.finalStates.has(state);
	}
}