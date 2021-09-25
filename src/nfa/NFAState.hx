package nfa;
import haxe.ds.Map;
import nfa.NFAInput.NFAInputTools;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class NFAState
{
	public var id(default, null):Int;
	public var map(default, null):Map<NFAState, NFAInput>;
	
	@:allow(nfa.NFAContext)
	private function new(id:Int)
	{
		this.id = id;
		map = new Map();
	}
	
	public function get(input:NFAInput):Array<NFAState>
	{
		return [for (dst in map.keys()) if (input.isSubsetOf(map[dst])) dst];
	}
	
	public function set(input:NFAInput, dst:NFAState):Void
	{
		map.set(dst, map.exists(dst)? input.sum(map[dst]) : input);
	}
	
	public function remove(?dst:NFAState):Void
	{
		map.remove(dst);
	}
	
	public function exists(dst:NFAState):Bool
	{
		return map.exists(dst);
	}
	
	public function getReachable(?via:NFAInput):Array<NFAState>
	{
		var reachable = [this];
		
		iter(via, (_, _, dst) -> reachable.push(dst));
		
		return reachable;
	}
	
	public function getInputs():Array<NFAInput>
	{
		return [for (dst in map.keys()) map[dst]].unique(NFAInputTools.equals);
	}
	
	public inline function iter(?via:NFAInput, func:NFAState->NFAInput->NFAState->Void):Void
	{
		_iter(via, func, new Map());
	}
	
	private function _iter(?via:NFAInput, func:NFAState->NFAInput->NFAState->Void, completed:Map<NFAState, Bool>):Void
	{
		completed.set(this, true);
		
		for (dst in map.keys()) if (via == null || via != null && via.isSubsetOf(map[dst])) 
		{
			func(this, map[dst], dst);
				
			if (!completed.exists(dst)) dst._iter(via, func, completed);
		}
	}
	
	public function simulate(char:String):Array<NFAState>
	{
		return [for (nextState in map.keys())
		{
			switch (map[nextState])
			{
				case NFAInput.Any (excludes) if (!excludes.has(char)): nextState;
				case NFAInput.Some(includes) if ( includes.has(char)): nextState;
				case _: continue;
			}
		}];
	}
	
	public function toString():String
	{
		return Std.string(id);
	}
}