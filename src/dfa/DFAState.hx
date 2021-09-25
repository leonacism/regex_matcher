package dfa;
import haxe.ds.Map;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class DFAState
{
	public var id(default, null):Int;
	
	public var map(default, null):Map<DFAInput, DFAState>;
	
	@:allow(dfa.DFAContext)
	public function new(id:Int)
	{
		this.id = id;
		map = new Map();
	}
	
	public function get(input:DFAInput):Null<DFAState>
	{
		return map[input];
	}
	
	public function set(input:DFAInput, dst:DFAState):Void
	{
		for (_input in map.keys()) if (map[_input] == dst)
		{
			map.remove(_input);
			input = input.sum(_input);
		}
		
		map.set(input, dst);
	}
	
	public function remove(?input:DFAInput):Void
	{
		map.remove(input);
	}
	
	public function exists(input:DFAInput):Bool
	{
		return map.exists(input);
	}
	
	public function getReachable(?via:DFAInput):Array<DFAState>
	{
		var reachable = [this];
		
		iter(via, (_, _, dst) -> reachable.push(dst));
		
		return reachable;
	}
	
	public function getInputs():Array<DFAInput>
	{
		return [for (input in map.keys()) input];
	}
	
	public inline function iter(?via:DFAInput, func:DFAState->DFAInput->DFAState->Void):Void
	{
		_iter(via, func, new Map());
	}
	
	private function _iter(?via:DFAInput, func:DFAState->DFAInput->DFAState->Void, completed:Map<DFAState, Bool>):Void
	{
		completed.set(this, true);
		
		for (input in map.keys()) if(via == null || via != null && via.isSubsetOf(input))
		{
			var dst = map[input];
			
			func(this, input, dst);
				
			if(!completed.exists(dst)) dst._iter(func, completed);
		}
	}
	
	public function simulate(char:String):Null<DFAState>
	{
		for (input in map.keys())
		{
			return switch (input)
			{
				case DFAInput.Any (excludes) if (!excludes.has(char)): map[input];
				case DFAInput.Some(includes) if ( includes.has(char)): map[input];
				case _: continue;
			}
		}
		
		return null;
	}
	
	public function toString():String
	{
		return Std.string(id);
	}
}