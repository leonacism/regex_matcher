package matcher;
import dfa.DFABuilder;
import dfa.DFABuilder.DFA;
import dfa.DFAOptimizer;
import dfa.DFAState;
import nfa.NFABuilder;
import nfa.NFAOptimizer;
import parser.Lexer;
import parser.Parser;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class DFAMatcher implements Matcher
{
	public var r(default, null):String;
	
	private var dfa:DFA;
	
	public function new(r:String) 
	{
		this.r = r;
		
		var nfa = NFAOptimizer.run(NFABuilder.run(Parser.run(Lexer.run(r))));
		
		dfa = DFAOptimizer.run(DFABuilder.run(nfa));
	}
	
	public function match(s:String):Bool
	{
		var i = 0;
		var state:Null<DFAState> = dfa.initialState;
		while (i < s.length)
		{
			state = state.simulate(s.charAt(i));
			
			if (state == null) return false;
			
			i++;
		}
		
		return dfa.finalStates.has(state);
	}
}