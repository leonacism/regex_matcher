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
class NFAMultipleMatcher implements Matcher
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
		var i = 0;
		var state:Array<NFAState> = [nfa.initialState];
		while (i < s.length)
		{
			state = state.map(src -> src.getReachable(NFAInput.Eps).map(src -> src.simulate(s.charAt(i))).squeezeArray()).squeezeArray();
			
			if (state.length == 0) return false;
			
			i++;
		}
		
		return !nfa.finalStates.excludes(state);
	}
}