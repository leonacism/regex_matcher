package dfa;

/**
 * ...
 * @author leonaci
 */
class DFAContext
{
	private var dfaStateUID:Int;
	
	public function new ()
	{
		dfaStateUID = 0;
	}
	
	public function alloc():DFAState
	{
		return new DFAState(dfaStateUID++);
	}
}