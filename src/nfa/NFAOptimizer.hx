package nfa;
import haxe.ds.Map;
import nfa.NFABuilder.NFA;
import nfa.NFAInput.NFAInputTools;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class NFAOptimizer 
{
	static public function run(nfa:NFA):NFA
	{
		removeEpsTransition(nfa);
		
		return nfa;
	}
	
	static private function removeEpsTransition(nfa:NFA):Void
	{
		var context = new NFAContext();
		
		var srcs:Array<NFAState> = [];
		var stateMap:Map<NFAState, NFAState> = new Map();
		
		nfa.initialState.iter((src, _, dst) -> {
			srcs.push(src);
			if (!stateMap.exists(src)) stateMap.set(src, context.alloc());
			if (!stateMap.exists(dst)) stateMap.set(dst, context.alloc());
		});
		
		var inputs:Array<NFAInput> = srcs.map(src -> src.getInputs().filterMap(input -> input.sub(NFAInput.Eps))).squeezeArray(NFAInputTools.equals);
		
		for(src in srcs) for (input in inputs)
		{
			var reachable:Array<NFAState> = src.getReachable(NFAInput.Eps);
			
			//trace('($src, ε*) => $reachable');
			
			reachable = reachable.map(dst -> dst.get(input)).squeezeArray();
			
			//trace('($src, ε*${input}) => $reachable');
			
			reachable = reachable.map(dst -> dst.getReachable(NFAInput.Eps)).squeezeArray();
			
			//trace('($src, ε*${input}ε*) => $reachable');
			
			for (dst in reachable) stateMap[src].set(input, stateMap[dst]);
		}
		
		nfa.initialState = stateMap[nfa.initialState];
		nfa.finalStates = nfa.finalStates.map(s -> stateMap[s]);
	}
}