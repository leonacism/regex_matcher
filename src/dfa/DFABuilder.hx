package dfa;
import haxe.ds.Map;
import nfa.NFABuilder.NFA;
import nfa.NFAInput;
import nfa.NFAState;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class DFABuilder 
{
	static public function run(nfa:NFA):DFA 
	{
		var context = new DFAContext();
		
		var srcs:Array<NFAState> = [];
		var stateMap:DFAStateMap = new DFAStateMap();
		
		nfa.initialState.iter((src, _, _) -> {
			srcs.push(src);
			addNewDestination(context, [src], stateMap);
		});
		
		var any = false;
		var interests:Array<String> = [];
		for (input in srcs.map(src -> src.getInputs()).squeezeArray(NFAInputTools.equals))
		{
			switch(input)
			{
				case NFAInput.Any(excludes): for (e in excludes) if (!interests.has(e)) interests.push(e); any = true;
				case NFAInput.Some(includes): for (i in includes) if (!interests.has(i)) interests.push(i);
				case NFAInput.Eps | NFAInput.AnyEps(_) | NFAInput.SomeEps(_): throw '!?';
			}
		}
		
		var inputMap:Map<NFAInput, DFAInput> = [for (i in interests) NFAInput.Some([i]) => DFAInput.Some([i])];
		if (any) inputMap.set(NFAInput.Any(interests), DFAInput.Any(interests));
		
		for (src in stateMap.keys()) for (input in inputMap.keys())
		{
			var dst = src.map(s -> s.get(input)).squeezeArray();
			if (dst.length > 0)
			{
				//trace('($src, $input) => $dst');
				
				if (!stateMap.exists(dst)) stateMap.set(dst, context.alloc());
				
				stateMap[src].set(inputMap[input], stateMap[dst]);
			}
		}
		
		//trace(Std.string(stateMap));
		
		var initialState = stateMap[[nfa.initialState]];
		var finalStates = [for (src in stateMap.keys()) src].filter(src -> !src.excludes(nfa.finalStates)).map(src -> stateMap[src]);
		
		return {
			initialState : initialState,
			finalStates : finalStates,
		}
	}
	
	static private function addNewDestination(context:DFAContext, dst:Array<NFAState>, stateMap:DFAStateMap):Void
	{
		if (stateMap.exists(dst) || dst.length == 0) return;
		
		stateMap.set(dst, context.alloc());
		
		var inputs:Array<NFAInput> = dst.map(s -> s.getInputs()).squeezeArray(NFAInputTools.equals);
		
		for (input in inputs)
		{
			var newDst = dst.map(src -> src.get(input)).squeezeArray();
			
			addNewDestination(context, newDst, stateMap);
		}
	}
}

@:forward(keys)
private abstract DFAStateMap(Map<Array<NFAState>, DFAState>)
{
	public inline function new() this = new Map<Array<NFAState>, DFAState>();
	
	@:arrayAccess
	public function get(key:Array<NFAState>):Null<DFAState>
	{
		for (src in this.keys()) if (src.equals(key))
		{
			return this[src];
		}
		
		return null;
	}
	
	public function set(key:Array<NFAState>, value:DFAState):Void
	{
		var exists = false;
		
		for (src in this.keys()) if (src.equals(key))
		{
			this.set(src, value);
			exists = true;
			break;
		}
		
		if (!exists) this.set(key, value);
	}
	
	public function exists(key:Array<NFAState>):Bool
	{
		var result = false;
		
		for (src in this.keys()) if (src.equals(key))
		{
			result = true;
			break;
		}
		
		return result;
	}
}

typedef DFA =
{
	var initialState:DFAState;
	var finalStates:Array<DFAState>;
}