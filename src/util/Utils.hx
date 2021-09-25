package util;
import haxe.ds.Option;

using util.Utils;

/**
 * ...
 * @author leonaci
 */
class Utils 
{
	static public function filterMap<A, B>(as:Array<A>, func:A->Option<B>):Array<B>
	{
		var results:Array<B> = [];

		for (a in as) switch (func(a))
		{
			case Option.Some(b): results.push(b);
			case Option.None:
		}

		return results;
	}
	
	static public inline function iterIfSome<A>(option:Option<A>, func:A -> Void):Void
	{
		switch(option)
		{
			case Option.Some(a): func(a);
			case Option.None:
		}
	}
	
	static public inline function mapIfSome<A, B>(option:Option<A>, func:A -> B):Option<B>
	{
		return switch(option)
		{
			case Option.Some(a): Option.Some(func(a));
			case Option.None: Option.None;
		}
	}
	
	static public inline function getOrElse<A>(option:Option<A>, value:A):A
	{
		return switch (option)
		{
			case Option.Some(a): a;
			case Option.None: value;
		}
	}
	
	static public function squeeze<A>(as:Array<A>, merge:A->A->A):Option<A>
	{
		var result:Option<A> = Option.None;
		
		for(v in as) result = switch(result)
		{
			case Option.None: Option.Some(v);
			case Option.Some(dst): Option.Some(merge(v, dst));
		}
		
		return result;
	}
	
	static public function squeezeArray<A>(as:Array<Array<A>>, ?equals:A->A->Bool):Array<A>
	{
		return as.squeeze((a1, a2) -> a1.union(a2, equals)).getOrElse([]);
	}
	
	static public function has<A>(as:Array<A>, e:A, ?equals:A->A->Bool):Bool
	{
		return if (equals == null) as.indexOf(e) != -1
		else
		{
			var result = false;
			
			for (a in as) if(equals(a, e))
			{
				result = true;
				break;
			}
			
			result;
		}
	}
	
	static public function includes<A>(as:Array<A>, es:Array<A>, ?equals:A->A->Bool):Bool
	{
		if (es.length > as.length) return false;
		
		var result = true;
		
		for (e in es) if (!as.has(e, equals))
		{
			result = false;
			break;
		}
		
		return result;
	}
	
	static public function excludes<A>(as:Array<A>, es:Array<A>, ?equals:A->A->Bool):Bool
	{
		var result = true;
		
		for (e in es) if (as.has(e, equals))
		{
			result = false;
			break;
		}
		
		return result;
	}
	
	static public function unique<A>(as:Array<A>, ?equals:A->A->Bool):Array<A>
	{
		var result:Array<A> = [];
		
		for (a in as) if (!result.has(a, equals)) result.push(a);
		
		return result;
	}
	
	static public function isUnique<A>(as:Array<A>, ?equals:A->A->Bool):Bool
	{
		return as.length == as.unique(equals).length;
	}
	
	static public function union<A>(as:Array<A>, es:Array<A>, ?equals:A->A->Bool):Array<A>
	{
		return as.concat(es).unique(equals);
	}
	
	static public inline function equals<A>(a:Array<A>, b:Array<A>, ?deepEquals:A->A->Bool):Bool
	{
		return a.length == b.length && a.includes(b, deepEquals) && b.includes(a, deepEquals);
	}
}