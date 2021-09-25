package nfa;

/**
 * ...
 * @author leonaci
 */
class NFAContext
{
	private var nfaStateUID:Int;
	
	public function new ()
	{
		nfaStateUID = 0;
	}
	
	public function alloc():NFAState
	{
		return new NFAState(nfaStateUID++);
	}
}