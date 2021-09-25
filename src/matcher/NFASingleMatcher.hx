package matcher;
import nfa.NFABuilder;
import nfa.NFAInput;
import nfa.NFAState;
import parser.Lexer;
import parser.Parser;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class NFASingleMatcher implements Matcher
{
	public var r(default, null):String;
	
	private var nfa:NFA;
	
	public function new(r:String) 
	{
		this.r = r;
		
		nfa = NFABuilder.run(Parser.run(Lexer.run(r)));
	}
	
	public function match(s:String)
	{
		return _match(0, s, nfa.initialState);
	}
	
	private function _match(i:Int, s:String, state:NFAState)
	{
		if (i == s.length) return nfa.finalStates.has(state);
		
		for (nextState in state.map.keys())
		{
			switch (state.map[nextState])
			{
				case NFAInput.Any (excludes):
				{
					if (!excludes.has(s.charAt(i)) && _match(i + 1, s, nextState)) return true;
				}
				case NFAInput.Some(includes):
				{
					if ( includes.has(s.charAt(i)) && _match(i + 1, s, nextState)) return true;
				}
				case NFAInput.AnyEps (excludes):
				{
					if (!excludes.has(s.charAt(i)) && _match(i + 1, s, nextState)) return true;
					if (_match(i, s, nextState)) return true;
				}
				case NFAInput.SomeEps(includes):
				{
					if ( includes.has(s.charAt(i)) && _match(i + 1, s, nextState)) return true;
					if (_match(i, s, nextState)) return true;
				}
				case NFAInput.Eps:
				{
					if (_match(i, s, nextState)) return true;
				}
			}
		}
		
		return false;
	}
}