package nfa;
import haxe.ds.Option;

using util.Utils;

/**
 * @author leonaci
 */
@:using(NFAInput.NFAInputTools)
enum NFAInput 
{
	Eps;
	Any(excludes:Array<String>);
	Some(includes:Array<String>);
	AnyEps(excludes:Array<String>);
	SomeEps(includes:Array<String>);
}

class NFAInputTools
{
	static public inline function isSubsetOf(input1:NFAInput, input2:NFAInput):Bool
	{
		return switch [input1, input2]
		{
			case [NFAInput.Eps, NFAInput.Eps]: true;
			case [NFAInput.Eps, NFAInput.Any(_)]: false;
			case [NFAInput.Eps, NFAInput.Some(_)]: false;
			case [NFAInput.Eps, NFAInput.AnyEps(_)]: true;
			case [NFAInput.Eps, NFAInput.SomeEps(_)]: true;
			
			case [NFAInput.Any(_), NFAInput.Eps]: false;
			case [NFAInput.Any(exs1), NFAInput.Any(exs2)]: exs1.includes(exs2);
			case [NFAInput.Any(_), NFAInput.Some(_)]: false;
			case [NFAInput.Any(exs1), NFAInput.AnyEps(exs2)]: exs1.includes(exs2);
			case [NFAInput.Any(_), NFAInput.SomeEps(_)]: false;
			
			case [NFAInput.Some([]), NFAInput.Eps]: true;
			case [NFAInput.Some(_), NFAInput.Eps]: false;
			case [NFAInput.Some(ins), NFAInput.Any(exs)]: exs.excludes(ins);
			case [NFAInput.Some(ins1), NFAInput.Some(ins2)]: ins2.includes(ins1);
			case [NFAInput.Some(ins), NFAInput.AnyEps(exs)]: exs.excludes(ins);
			case [NFAInput.Some(ins1), NFAInput.SomeEps(ins2)]: ins2.includes(ins1);
			
			case [NFAInput.AnyEps(_), NFAInput.Eps]: false;
			case [NFAInput.AnyEps(_), NFAInput.Any(_)]: false;
			case [NFAInput.AnyEps(_), NFAInput.Some(_)]: false;
			case [NFAInput.AnyEps(exs1), NFAInput.AnyEps(exs2)]: exs1.includes(exs2);
			case [NFAInput.AnyEps(_), NFAInput.SomeEps(_)]: false;
			
			case [NFAInput.SomeEps([]), NFAInput.Eps]: true;
			case [NFAInput.SomeEps(_), NFAInput.Eps]: false;
			case [NFAInput.SomeEps(ins), NFAInput.Any(exs)]: false;
			case [NFAInput.SomeEps(ins1), NFAInput.Some(ins2)]: false;
			case [NFAInput.SomeEps(ins), NFAInput.AnyEps(exs)]: exs.excludes(ins);
			case [NFAInput.SomeEps(ins1), NFAInput.SomeEps(ins2)]: ins2.includes(ins1);
		}
	}
	
	static public inline function equals(input1:NFAInput, input2:NFAInput):Bool
	{
		return switch [input1, input2]
		{
			case [NFAInput.Eps, NFAInput.Eps]: true;
			case [NFAInput.Any(exs1), NFAInput.Any(exs2)]: exs1.equals(exs2);
			case [NFAInput.Some(ins1), NFAInput.Some(ins2)]: ins1.equals(ins2);
			case [NFAInput.AnyEps(exs1), NFAInput.AnyEps(exs2)]: exs1.equals(exs2);
			case [NFAInput.SomeEps(ins1), NFAInput.SomeEps(ins2)]: ins1.equals(ins2);
			
			case _: false;
		}
	}
	
	static public inline function sum(input1:NFAInput, input2:NFAInput):NFAInput
	{
		return switch [input1, input2]
		{
			case [NFAInput.Eps, NFAInput.Eps]: NFAInput.Eps;
			
			case [NFAInput.Eps, NFAInput.Any   (exs) ]: NFAInput.AnyEps (exs.copy());
			case [NFAInput.Eps, NFAInput.AnyEps(exs) ]: NFAInput.AnyEps (exs.copy());
			case [NFAInput.Eps, NFAInput.Some   (ins)]: NFAInput.SomeEps(ins.copy());
			case [NFAInput.Eps, NFAInput.SomeEps(ins)]: NFAInput.SomeEps(ins.copy());
			
			case [NFAInput.Any   (exs1), NFAInput.Any   (exs2)]: NFAInput.Any   ([for (ex2 in exs2) if (exs1.has(ex2)) ex2]);
			case [NFAInput.Any   (exs1), NFAInput.AnyEps(exs2)]: NFAInput.AnyEps([for (ex2 in exs2) if (exs1.has(ex2)) ex2]);
			case [NFAInput.AnyEps(exs1), NFAInput.AnyEps(exs2)]: NFAInput.AnyEps([for (ex2 in exs2) if (exs1.has(ex2)) ex2]);
			
			case [NFAInput.Any   (exs), NFAInput.Some   (ins)]: NFAInput.Any   ([for (ex in exs) if (!ins.has(ex)) ex]);
			case [NFAInput.Any   (exs), NFAInput.SomeEps(ins)]: NFAInput.AnyEps([for (ex in exs) if (!ins.has(ex)) ex]);
			case [NFAInput.AnyEps(exs), NFAInput.Some   (ins)]: NFAInput.AnyEps([for (ex in exs) if (!ins.has(ex)) ex]);
			case [NFAInput.AnyEps(exs), NFAInput.SomeEps(ins)]: NFAInput.AnyEps([for (ex in exs) if (!ins.has(ex)) ex]);
			
			case [NFAInput.Some   (ins1), NFAInput.Some   (ins2)]: NFAInput.Some   (ins1.union(ins2));
			case [NFAInput.Some   (ins1), NFAInput.SomeEps(ins2)]: NFAInput.SomeEps(ins1.union(ins2));
			case [NFAInput.SomeEps(ins1), NFAInput.SomeEps(ins2)]: NFAInput.SomeEps(ins1.union(ins2));
			
			case _: sum(input2, input1);
		}
	}
	
	static public inline function sub(input1:NFAInput, input2:NFAInput):Option<NFAInput>
	{
		return switch [input1, input2]
		{
			case [NFAInput.Eps, NFAInput.Eps       ]: Option.None;
			case [NFAInput.Eps, NFAInput.Any(exs)  ]: Option.Some(NFAInput.Eps);
			case [NFAInput.Eps, NFAInput.AnyEps(_) ]: Option.None;
			case [NFAInput.Eps, NFAInput.Some(ins) ]: Option.Some(NFAInput.Eps);
			case [NFAInput.Eps, NFAInput.SomeEps(_)]: Option.None;
			
			case [NFAInput.Any   (exs) , NFAInput.Eps]: Option.Some(NFAInput.Any (exs.copy()));
			case [NFAInput.AnyEps(exs) , NFAInput.Eps]: Option.Some(NFAInput.Any (exs.copy()));
			case [NFAInput.Some   (ins), NFAInput.Eps]: Option.Some(NFAInput.Some(ins.copy()));
			case [NFAInput.SomeEps(ins), NFAInput.Eps]: Option.Some(NFAInput.Some(ins.copy()));
			
			case [NFAInput.Any   (exs1), NFAInput.Any   (exs2)]: exs1.includes(exs2)? Option.None               : Option.Some(NFAInput.Some   ([for (ex2 in exs2) if (!exs1.has(ex2)) ex2]));
			case [NFAInput.AnyEps(exs1), NFAInput.Any   (exs2)]: exs1.includes(exs2)? Option.Some(NFAInput.Eps) : Option.Some(NFAInput.SomeEps([for (ex2 in exs2) if (!exs1.has(ex2)) ex2]));
			case [NFAInput.Any   (exs1), NFAInput.AnyEps(exs2)]: exs1.includes(exs2)? Option.None               : Option.Some(NFAInput.Some   ([for (ex2 in exs2) if (!exs1.has(ex2)) ex2]));
			case [NFAInput.AnyEps(exs1), NFAInput.AnyEps(exs2)]: exs1.includes(exs2)? Option.None               : Option.Some(NFAInput.Some   ([for (ex2 in exs2) if (!exs1.has(ex2)) ex2]));
			
			case [NFAInput.Any   (exs), NFAInput.Some   (ins)]: Option.Some(NFAInput.Any   (exs.union(ins)));
			case [NFAInput.AnyEps(exs), NFAInput.Some   (ins)]: Option.Some(NFAInput.AnyEps(exs.union(ins)));
			case [NFAInput.Any   (exs), NFAInput.SomeEps(ins)]: Option.Some(NFAInput.Any   (exs.union(ins)));
			case [NFAInput.AnyEps(exs), NFAInput.SomeEps(ins)]: Option.Some(NFAInput.Any   (exs.union(ins)));
			
			case [NFAInput.Some   (ins), NFAInput.Any   (exs)]: ins.includes(exs)? Option.None               : Option.Some(NFAInput.Some   ([for (ex in exs) if(ins.has(ex)) ex]));
			case [NFAInput.SomeEps(ins), NFAInput.Any   (exs)]: ins.includes(exs)? Option.Some(NFAInput.Eps) : Option.Some(NFAInput.SomeEps([for (ex in exs) if(ins.has(ex)) ex]));
			case [NFAInput.Some   (ins), NFAInput.AnyEps(exs)]: ins.includes(exs)? Option.None               : Option.Some(NFAInput.Some   ([for (ex in exs) if(ins.has(ex)) ex]));
			case [NFAInput.SomeEps(ins), NFAInput.AnyEps(exs)]: ins.includes(exs)? Option.None               : Option.Some(NFAInput.SomeEps([for (ex in exs) if(ins.has(ex)) ex]));
			
			case [NFAInput.Some   (ins1), NFAInput.Some   (ins2)]: ins2.includes(ins1)? Option.None               : Option.Some(NFAInput.Some   ([for (in1 in ins1) if(!ins2.has(in1)) in1]));
			case [NFAInput.SomeEps(ins1), NFAInput.Some   (ins2)]: ins2.includes(ins1)? Option.Some(NFAInput.Eps) : Option.Some(NFAInput.SomeEps([for (in1 in ins1) if(!ins2.has(in1)) in1]));
			case [NFAInput.Some   (ins1), NFAInput.SomeEps(ins2)]: ins2.includes(ins1)? Option.None               : Option.Some(NFAInput.Some   ([for (in1 in ins1) if(!ins2.has(in1)) in1]));
			case [NFAInput.SomeEps(ins1), NFAInput.SomeEps(ins2)]: ins2.includes(ins1)? Option.None               : Option.Some(NFAInput.SomeEps([for (in1 in ins1) if(!ins2.has(in1)) in1]));
		}
	}
	
	static public inline function flip(input:NFAInput):NFAInput
	{
		return switch(input)
		{
			case NFAInput.Eps: NFAInput.Eps;
			case NFAInput.Any(ins): NFAInput.Some(ins);
			case NFAInput.Some(exs): NFAInput.Any(exs);
			case NFAInput.AnyEps(ins): NFAInput.SomeEps(ins);
			case NFAInput.SomeEps(exs): NFAInput.AnyEps(exs);
		}
	}
}