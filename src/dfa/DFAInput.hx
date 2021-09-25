package dfa;
import haxe.ds.Option;

using util.Utils;

/**
 * @author leonaci
 */

@:using(DFAInput.DFAInputTools)
enum DFAInput 
{
	Any(excludes:Array<String>);
	Some(includes:Array<String>);
}

class DFAInputTools
{
	static public inline function isSubsetOf(input1:DFAInput, input2:DFAInput):Bool
	{
		return switch [input1, input2]
		{
			case [DFAInput.Any (exs1), DFAInput.Any (exs2)]: exs1.includes(exs2);
			case [DFAInput.Any (   _), DFAInput.Some(   _)]: false;
			case [DFAInput.Some(ins ), DFAInput.Any (exs )]: exs.excludes(ins);
			case [DFAInput.Some(ins1), DFAInput.Some(ins2)]: ins2.includes(ins1);
		}
	}
	
	static public inline function equals(input1:DFAInput, input2:DFAInput):Bool
	{
		return switch [input1, input2]
		{
			case [DFAInput.Any(exs1), DFAInput.Any(exs2)]: exs1.equals(exs2);
			case [DFAInput.Some(ins1), DFAInput.Some(ins2)]: ins1.equals(ins2);
			
			case _: false;
		}
	}
	
	static public inline function sum(input1:DFAInput, input2:DFAInput):DFAInput
	{
		return switch [input1, input2]
		{
			case [DFAInput.Any (exs1), DFAInput.Any (exs2)]: DFAInput.Any ([for (ex2 in exs2) if (exs1.has(ex2)) ex2]);
			case [DFAInput.Any (exs ), DFAInput.Some(ins )]: DFAInput.Any ([for (ex in exs) if (!ins.has(ex)) ex]);
			case [DFAInput.Some(ins ), DFAInput.Any (exs )]: DFAInput.Any ([for (ex in exs) if (!ins.has(ex)) ex]);
			case [DFAInput.Some(ins1), DFAInput.Some(ins2)]: DFAInput.Some(ins1.union(ins2));
		}
	}
	
	static public inline function sub(input1:DFAInput, input2:DFAInput):Option<DFAInput>
	{
		return switch [input1, input2]
		{
			case [DFAInput.Any (exs1), DFAInput.Any (exs2)]: exs1.includes(exs2)? Option.None : Option.Some(DFAInput.Some([for (ex2 in exs2) if (!exs1.has(ex2)) ex2]));
			case [DFAInput.Any (exs ), DFAInput.Some(ins )]: Option.Some(DFAInput.Any(exs.union(ins)));
			case [DFAInput.Some(ins ), DFAInput.Any (exs )]: ins .includes(exs )? Option.None : Option.Some(DFAInput.Some([for (ex in exs) if(ins.has(ex)) ex]));
			case [DFAInput.Some(ins1), DFAInput.Some(ins2)]: ins2.includes(ins1)? Option.None : Option.Some(DFAInput.Some([for (in1 in ins1) if(!ins2.has(in1)) in1]));
		}
	}
}