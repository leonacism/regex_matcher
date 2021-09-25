package test;
import test.cases.DFA2MatcherTest;
import test.cases.DFABuilderTest;
import test.cases.DFAMatcherTest;
import test.cases.LexerTest;
import test.cases.NFABuilderMultipleTest;
import test.cases.NFABuilderSingleTest;
import test.cases.NFAMultipleMatcherTest;
import test.cases.NFASingleMatcherTest;
import test.cases.ParserTest;
import utest.UTest;

/**
 * ...
 * @author leonaci
 */
class TestMain 
{

	static public function main() 
	{
		UTest.run([
			new LexerTest(),
			new ParserTest(),
			//new NFABuilderSingleTest(),
			//new NFASingleMatcherTest(),
			new NFABuilderMultipleTest(),
			new NFAMultipleMatcherTest(),
			new DFABuilderTest(),
			//new DFAMatcherTest(),
			new DFA2MatcherTest(),
		]);
	}
	
}