package matcher;
import dfa2.DFA2State;
import nfa.NFABuilder;
import nfa.NFABuilder.NFA;
import parser.Lexer;
import parser.Parser;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class DFA2Matcher implements Matcher
{
	public var r(default, null):String;
	
	private var nfa:NFA;
	private var initialState:DFA2State;
	
	public function new(r:String) 
	{
		this.r = r;
		
		nfa = NFABuilder.run(Parser.run(Lexer.run(r)));
		initialState = new DFA2State([nfa.initialState]);
	}
	
	public function match(s:String):Bool
	{
		var i = 0;
		var state:Null<DFA2State> = initialState;
		while (i < s.length)
		{
			var c = s.charAt(i);
			state = state.map.exists(c)? state.map[c] : state.simulate(c, initialState);
			
			if (state == null) return false;
			
			i++;
		}
		
		return !nfa.finalStates.excludes(state.internalState);
	}
}