package test.cases;
import matcher.DFAMatcher;
import parser.Symbol;
import utest.Assert;
import utest.Test;

/**
 * ...
 * @author leonaci
 */
class DFAMatcherTest extends Test
{
	function test() 
	{
		Assert.isTrue(new DFAMatcher('a').match('a'));
		Assert.isFalse(new DFAMatcher('a').match('aa'));
		
		Assert.isTrue(new DFAMatcher(Symbol.allEnums().map(s -> '\\$s').join('')).match(Symbol.allEnums().join('')));
		Assert.isTrue(new DFAMatcher('\\\\').match('\\'));
		
		Assert.isTrue(new DFAMatcher('a*b*').match('a'));
		Assert.isTrue(new DFAMatcher('a*b*').match('b'));
		Assert.isTrue(new DFAMatcher('a*b*').match('ab'));
		Assert.isTrue(new DFAMatcher('a*b*').match('aaaaaaaabbbbbbb'));
		Assert.isFalse(new DFAMatcher('a*b*').match('ba'));
		Assert.isFalse(new DFAMatcher('a*b*').match('aaabaaabbbb'));
		
		Assert.isFalse(new DFAMatcher('a+b+').match('a'));
		Assert.isFalse(new DFAMatcher('a+b+').match('b'));
		Assert.isTrue(new DFAMatcher('a+b+').match('ab'));
		Assert.isTrue(new DFAMatcher('a+b+').match('aaaaaaaabbbbbbb'));
		Assert.isFalse(new DFAMatcher('a+b+').match('ba'));
		Assert.isFalse(new DFAMatcher('a+b+').match('aaabaaabbbb'));
		
		Assert.isTrue(new DFAMatcher('(neko)?(inu)?').match('neko'));
		Assert.isTrue(new DFAMatcher('(neko)?(inu)?').match('inu'));
		Assert.isTrue(new DFAMatcher('(neko)?(inu)?').match('nekoinu'));
		Assert.isFalse(new DFAMatcher('(neko)?(inu)?').match('nekoneko'));
		Assert.isFalse(new DFAMatcher('(neko)?(inu)?').match('nekoinuneko'));
		Assert.isFalse(new DFAMatcher('(neko)?(inu)?').match('inuneko'));
		Assert.isFalse(new DFAMatcher('(neko)?(inu)?').match('inuinu'));
		
		Assert.isTrue(new DFAMatcher('(a|b)*').match('a'));
		Assert.isTrue(new DFAMatcher('(a|b)*').match('ba'));
		Assert.isTrue(new DFAMatcher('(a|b)*').match('bbbb'));
		
		Assert.isTrue(new DFAMatcher('(a|b)*ab(a|b)*c').match('abc'));
		Assert.isFalse(new DFAMatcher('(a|b)*ab(a|b)*c').match('bbbbaaaac'));
		Assert.isTrue(new DFAMatcher('(a|b)*ab(a|b)*c').match('babbaabbaabbbc'));
		Assert.isFalse(new DFAMatcher('(a|b)*ab(a|b)*c').match('abccc'));
		
		Assert.isTrue(new DFAMatcher('ny.+n').match('nyaaaaaan'));
		Assert.isTrue(new DFAMatcher('ny.+n').match('nyowaAAawoa2d;Cc01ecaaan'));
		Assert.isFalse(new DFAMatcher('ny.+n').match('nyn'));
		
		Assert.isTrue(new DFAMatcher('(にゃ)+(ー)*ん').match('にゃん'));
		Assert.isTrue(new DFAMatcher('(にゃ)+(ー)*ん').match('にゃにゃにゃん'));
		Assert.isTrue(new DFAMatcher('(にゃ)+(ー)*ん').match('にゃにゃにゃにゃにゃーーーん'));
		Assert.isFalse(new DFAMatcher('(にゃ)+(ー)*ん').match('にゃんにゃん'));
		Assert.isFalse(new DFAMatcher('(にゃ)+(ー)*ん').match('にゃーーにゃにゃーーにゃにゃーーーーん'));
		Assert.isFalse(new DFAMatcher('(にゃ)+(ー)*ん').match('にん'));
		
		Assert.isTrue(new DFAMatcher('\\d+').match('0123456789'));
		Assert.isFalse(new DFAMatcher('\\D+').match('0123456789'));
		Assert.isTrue(new DFAMatcher('\\w+').match('She_is_54_years_old'));
		Assert.isFalse(new DFAMatcher('\\w+').match('Are you serious?'));
		
		Assert.isTrue(new DFAMatcher('[a-d]+').match('abcd'));
		Assert.isFalse(new DFAMatcher('[^a-d]+').match('abcd'));
		Assert.isFalse(new DFAMatcher('[a-d]+').match('efgh'));
		Assert.isTrue(new DFAMatcher('[^a-d]+').match('efgh'));
		
		Assert.isTrue(new DFAMatcher('[1-9]\\d*').match('3818403100484172'));
		Assert.isFalse(new DFAMatcher('[1-9]\\d*').match('048247719193'));
		
		Assert.isTrue(new DFAMatcher('[1-9]\\d*(\\.\\d*)?').match('49419813.191294'));
		Assert.isFalse(new DFAMatcher('[1-9]\\d*(\\.\\d*)?').match('20c11b.113ff'));
		
		Assert.isTrue(new DFAMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('leonacism@gmail.com'));
		Assert.isTrue(new DFAMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('__1234.5678-90@example.com'));
		Assert.isFalse(new DFAMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('-test@example.com'));
		Assert.isFalse(new DFAMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('test@example...com'));
		
		Assert.isTrue(new DFAMatcher('a{0,0}b').match('b'));
		Assert.isFalse(new DFAMatcher('a{0,0}b').match('ab'));
		
		Assert.isTrue(new DFAMatcher('a{0,2}b').match('b'));
		Assert.isTrue(new DFAMatcher('a{0,2}b').match('ab'));
		Assert.isTrue(new DFAMatcher('a{0,2}b').match('aab'));
		Assert.isFalse(new DFAMatcher('a{0,2}b').match('aaab'));
		
		Assert.isFalse(new DFAMatcher('a{1,2}b').match('b'));
		Assert.isTrue(new DFAMatcher('a{1,2}b').match('ab'));
		Assert.isTrue(new DFAMatcher('a{1,2}b').match('aab'));
		Assert.isFalse(new DFAMatcher('a{1,2}b').match('aaab'));
		
		Assert.isFalse(new DFAMatcher('a{2}b').match('ab'));
		Assert.isTrue(new DFAMatcher('a{2}b').match('aab'));
		Assert.isFalse(new DFAMatcher('a{2}b').match('aaab'));
		
		Assert.isTrue(new DFAMatcher('a{0,}b').match('b'));
		Assert.isTrue(new DFAMatcher('a{0,}b').match('ab'));
		Assert.isTrue(new DFAMatcher('a{0,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new DFAMatcher('a{1,}b').match('b'));
		Assert.isTrue(new DFAMatcher('a{1,}b').match('ab'));
		Assert.isTrue(new DFAMatcher('a{1,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new DFAMatcher('a{5,}b').match('b'));
		Assert.isFalse(new DFAMatcher('a{5,}b').match('aaaab'));
		Assert.isTrue(new DFAMatcher('a{5,}b').match('aaaaab'));
		Assert.isTrue(new DFAMatcher('a{5,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new DFAMatcher('(\\w+)+').match('7cb6a025d54b47bcbc93d16e5293f8d2-'));
	}
}