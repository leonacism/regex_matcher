package dfa;
import dfa.DFABuilder.DFA;
import dfa.DFAInput.DFAInputTools;
import haxe.ds.Map;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class DFAOptimizer 
{
	static public function run(dfa:DFA, ?maxNumIteration:Int = 100):DFA
	{
		minimize(dfa, maxNumIteration);
		
		return dfa;
	}
	
	static private function minimize(dfa:DFA, maxNumIteration:Int):Void
	{
		if (maxNumIteration <= 0) return;
		
		var minimum = _minimize(dfa);
		
		if(!minimum) minimize(dfa, maxNumIteration - 1);
	}
	
	static private function _minimize(dfa:DFA):Bool
	{
		var context = new DFAContext();
		
		var stateMap = new Map<DFAState, DFAState>();
		
		dfa.initialState.iter((src1, _, dst1) -> {
			if(!stateMap.exists(src1)) stateMap.set(src1, context.alloc());
			
			var inputs1 = src1.getInputs();
			
			dst1.iter((src2, _, _) -> {
				
				var inputs2 = src2.getInputs();
				
				if (inputs1.equals(inputs2, DFAInputTools.equals) && dfa.finalStates.has(src1) == dfa.finalStates.has(src2))
				{
					var equals = true;
					
					for (input in inputs1) if (src1.get(input) != src2.get(input))
					{
						equals = false;
						break;
					}
					
					if(equals) stateMap[src2] = stateMap[src1];
				}
			});
		});
		
		dfa.initialState.iter((src, input, dst) -> {
			if (!stateMap.exists(dst)) stateMap.set(dst, context.alloc());
			
			if(!stateMap[src].exists(input)) stateMap[src].set(input, stateMap[dst]);
		});
		
		var minimum = true;
		for (src in stateMap.keys()) if (src != stateMap[src])
		{
			minimum = false;
			break;
		}
		
		if (!minimum)
		{
			dfa.initialState = stateMap[dfa.initialState];
			
			var finalStates = [];
			for (src in stateMap.keys()) if(!finalStates.has(stateMap[src]) && dfa.finalStates.has(src)) finalStates.push(stateMap[src]);
			
			dfa.finalStates = finalStates;
		}
		
		return minimum;
	}
	
}