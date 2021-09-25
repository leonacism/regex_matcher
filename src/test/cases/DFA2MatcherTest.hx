package test.cases;
import matcher.DFA2Matcher;
import parser.Symbol;
import utest.Assert;
import utest.Test;

/**
 * ...
 * @author leonaci
 */
class DFA2MatcherTest extends Test
{
	function test() 
	{
		Assert.isTrue(new DFA2Matcher('a').match('a'));
		Assert.isFalse(new DFA2Matcher('a').match('aa'));
		
		Assert.isTrue(new DFA2Matcher(Symbol.allEnums().map(s -> '\\$s').join('')).match(Symbol.allEnums().join('')));
		Assert.isTrue(new DFA2Matcher('\\\\').match('\\'));
		
		Assert.isTrue(new DFA2Matcher('a*b*').match('a'));
		Assert.isTrue(new DFA2Matcher('a*b*').match('b'));
		Assert.isTrue(new DFA2Matcher('a*b*').match('ab'));
		Assert.isTrue(new DFA2Matcher('a*b*').match('aaaaaaaabbbbbbb'));
		Assert.isFalse(new DFA2Matcher('a*b*').match('ba'));
		Assert.isFalse(new DFA2Matcher('a*b*').match('aaabaaabbbb'));
		
		Assert.isFalse(new DFA2Matcher('a+b+').match('a'));
		Assert.isFalse(new DFA2Matcher('a+b+').match('b'));
		Assert.isTrue(new DFA2Matcher('a+b+').match('ab'));
		Assert.isTrue(new DFA2Matcher('a+b+').match('aaaaaaaabbbbbbb'));
		Assert.isFalse(new DFA2Matcher('a+b+').match('ba'));
		Assert.isFalse(new DFA2Matcher('a+b+').match('aaabaaabbbb'));
		
		Assert.isTrue(new DFA2Matcher('(neko)?(inu)?').match('neko'));
		Assert.isTrue(new DFA2Matcher('(neko)?(inu)?').match('inu'));
		Assert.isTrue(new DFA2Matcher('(neko)?(inu)?').match('nekoinu'));
		Assert.isFalse(new DFA2Matcher('(neko)?(inu)?').match('nekoneko'));
		Assert.isFalse(new DFA2Matcher('(neko)?(inu)?').match('nekoinuneko'));
		Assert.isFalse(new DFA2Matcher('(neko)?(inu)?').match('inuneko'));
		Assert.isFalse(new DFA2Matcher('(neko)?(inu)?').match('inuinu'));
		
		Assert.isTrue(new DFA2Matcher('(a|b)*').match('a'));
		Assert.isTrue(new DFA2Matcher('(a|b)*').match('ba'));
		Assert.isTrue(new DFA2Matcher('(a|b)*').match('bbbb'));
		
		Assert.isTrue(new DFA2Matcher('(a|b)*ab(a|b)*c').match('abc'));
		Assert.isFalse(new DFA2Matcher('(a|b)*ab(a|b)*c').match('bbbbaaaac'));
		Assert.isTrue(new DFA2Matcher('(a|b)*ab(a|b)*c').match('babbaabbaabbbc'));
		Assert.isFalse(new DFA2Matcher('(a|b)*ab(a|b)*c').match('abccc'));
		
		Assert.isTrue(new DFA2Matcher('ny.+n').match('nyaaaaaan'));
		Assert.isTrue(new DFA2Matcher('ny.+n').match('nyowaAAawoa2d;Cc01ecaaan'));
		Assert.isFalse(new DFA2Matcher('ny.+n').match('nyn'));
		
		Assert.isTrue(new DFA2Matcher('(にゃ)+(ー)*ん').match('にゃん'));
		Assert.isTrue(new DFA2Matcher('(にゃ)+(ー)*ん').match('にゃにゃにゃん'));
		Assert.isTrue(new DFA2Matcher('(にゃ)+(ー)*ん').match('にゃにゃにゃにゃにゃーーーん'));
		Assert.isFalse(new DFA2Matcher('(にゃ)+(ー)*ん').match('にゃんにゃん'));
		Assert.isFalse(new DFA2Matcher('(にゃ)+(ー)*ん').match('にゃーーにゃにゃーーにゃにゃーーーーん'));
		Assert.isFalse(new DFA2Matcher('(にゃ)+(ー)*ん').match('にん'));
		
		Assert.isTrue(new DFA2Matcher('\\d+').match('0123456789'));
		Assert.isFalse(new DFA2Matcher('\\D+').match('0123456789'));
		Assert.isTrue(new DFA2Matcher('\\w+').match('She_is_54_years_old'));
		Assert.isFalse(new DFA2Matcher('\\w+').match('Are you serious?'));
		
		Assert.isTrue(new DFA2Matcher('[a-d]+').match('abcd'));
		Assert.isFalse(new DFA2Matcher('[^a-d]+').match('abcd'));
		Assert.isFalse(new DFA2Matcher('[a-d]+').match('efgh'));
		Assert.isTrue(new DFA2Matcher('[^a-d]+').match('efgh'));
		
		Assert.isTrue(new DFA2Matcher('[1-9]\\d*').match('3818403100484172'));
		Assert.isFalse(new DFA2Matcher('[1-9]\\d*').match('048247719193'));
		
		Assert.isTrue(new DFA2Matcher('[1-9]\\d*(\\.\\d*)?').match('49419813.191294'));
		Assert.isFalse(new DFA2Matcher('[1-9]\\d*(\\.\\d*)?').match('20c11b.113ff'));
		
		Assert.isTrue(new DFA2Matcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('leonacism@gmail.com'));
		Assert.isTrue(new DFA2Matcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('__1234.5678-90@example.com'));
		Assert.isFalse(new DFA2Matcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('-test@example.com'));
		Assert.isFalse(new DFA2Matcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('test@example...com'));
		
		Assert.isTrue(new DFA2Matcher('a{0,0}b').match('b'));
		Assert.isFalse(new DFA2Matcher('a{0,0}b').match('ab'));
		
		Assert.isTrue(new DFA2Matcher('a{0,2}b').match('b'));
		Assert.isTrue(new DFA2Matcher('a{0,2}b').match('ab'));
		Assert.isTrue(new DFA2Matcher('a{0,2}b').match('aab'));
		Assert.isFalse(new DFA2Matcher('a{0,2}b').match('aaab'));
		
		Assert.isFalse(new DFA2Matcher('a{1,2}b').match('b'));
		Assert.isTrue(new DFA2Matcher('a{1,2}b').match('ab'));
		Assert.isTrue(new DFA2Matcher('a{1,2}b').match('aab'));
		Assert.isFalse(new DFA2Matcher('a{1,2}b').match('aaab'));
		
		Assert.isFalse(new DFA2Matcher('a{2}b').match('ab'));
		Assert.isTrue(new DFA2Matcher('a{2}b').match('aab'));
		Assert.isFalse(new DFA2Matcher('a{2}b').match('aaab'));
		
		Assert.isTrue(new DFA2Matcher('a{0,}b').match('b'));
		Assert.isTrue(new DFA2Matcher('a{0,}b').match('ab'));
		Assert.isTrue(new DFA2Matcher('a{0,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new DFA2Matcher('a{1,}b').match('b'));
		Assert.isTrue(new DFA2Matcher('a{1,}b').match('ab'));
		Assert.isTrue(new DFA2Matcher('a{1,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new DFA2Matcher('a{5,}b').match('b'));
		Assert.isFalse(new DFA2Matcher('a{5,}b').match('aaaab'));
		Assert.isTrue(new DFA2Matcher('a{5,}b').match('aaaaab'));
		Assert.isTrue(new DFA2Matcher('a{5,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new DFA2Matcher('(\\w+)+').match('7cb6a025d54b47bcbc93d16e5293f8d2-'));
	}
}