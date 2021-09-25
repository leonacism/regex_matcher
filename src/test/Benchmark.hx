package test;
import haxe.Timer;
import matcher.DFA2Matcher;
import matcher.DFAMatcher;
import matcher.Matcher;
import matcher.NFAMultipleMatcher;
import matcher.NFASingleMatcher;

/**
 * ...
 * @author leonaci
 */
class Benchmark 
{
	static private var r:String = '[12]\\d{3}\\-[01]\\d\\-[0-3]\\d (([^\\[]*)?)\\[(([^\\]]*)?)\\]:.*';
	static private var s:String = '2014-08-26 app[web.1]: 50.0.134.125 - - [26/Aug/2014 00:27:41] "GET/HTTP/1.1" 200 14 0.0005';

	static public function main() 
	{
		benchmark(DFAMatcher);
		benchmark(NFASingleMatcher);
		benchmark(NFAMultipleMatcher);
		benchmark(DFA2Matcher);
	}
	
	static private function benchmark(cl:Class<Matcher>):Void
	{
		var N = 100;
		
		var eregCreationTime:Float = 0;
		var eregMatchingTime:Float = 0;
		var eregTotalTime:Float = 0;
		
		var start1 = Timer.stamp();
		for (i in 0...N)
		{
			var start2 = Timer.stamp();
			var m:Matcher = Type.createInstance(cl, [r]);
			eregCreationTime += Timer.stamp() - start2;
			
			var start3 = Timer.stamp();
			m.match(s);
			eregMatchingTime += Timer.stamp() - start3;
		}
		eregTotalTime += Timer.stamp() - start1;
		
		var output = [
			'${Type.getClassName(cl)}',
			'Creation Time: ${Math.round(1000 * eregCreationTime)} ms / $N times',
			'Matching Time: ${Math.round(1000 * eregMatchingTime)} ms / $N times',
			'Total Time: ${Math.round(1000 * eregTotalTime)} ms / $N times',
			'',
		].join('\n');
		
		trace(output);
	}
}