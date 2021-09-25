package dfa2;
import haxe.ds.Map;
import nfa.NFAInput;
import nfa.NFAState;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class DFA2State 
{
	private var left:Null<DFA2State>;
	private var right:Null<DFA2State>;
	
	public var map(default, null):Map<String, DFA2State>;
	
	public var internalState(default, null):Array<NFAState>;
	
	public function new(internalState:Array<NFAState>)
	{
		map = new Map();
		this.internalState = internalState;
	}
	
	public function simulate(char:String, root:DFA2State):Null<DFA2State>
	{
		var nextInternalState:Array<NFAState> = internalState.map(src -> src.getReachable(NFAInput.Eps).map(src -> src.simulate(char)).squeezeArray()).squeezeArray();
		
		if (nextInternalState.length == 0) return null;
		
		nextInternalState.sort(Reflect.compare);
		
		var nextState:DFA2State = null;
		
		var node:DFA2State = root;
		while (true)
		{
			switch(compare(nextInternalState, node.internalState))
			{
				case c if (c < 0):
				{
					if (node.left != null) node = node.left
					else
					{
						nextState = node.left = new DFA2State(nextInternalState);
						break;
					}
				}
				case c if (c > 0):
				{
					if (node.right != null) node = node.right
					else
					{
						nextState = node.right = new DFA2State(nextInternalState);
						break;
					}
				}
				case _:
				{
					nextState = node;
					break;
				}
			}
		}
		
		map.set(char, nextState);
		
		return nextState;
	}
	
	static private function compare(a:Array<NFAState>, b:Array<NFAState>):Int
	{
		if (a.length < b.length) return -1;
		if (a.length > b.length) return  1;
		
		var i = 0;
		for (i in 0...a.length)
		{
			if (a[i].id < b[i].id) return -1;
			if (a[i].id > b[i].id) return  1;
		}
		
		return 0;
	}
	
	public function toString():String
	{
		return Std.string(internalState);
	}
}