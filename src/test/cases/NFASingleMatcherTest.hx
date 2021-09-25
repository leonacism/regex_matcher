package test.cases;
import matcher.NFASingleMatcher;
import parser.Symbol;
import utest.Assert;
import utest.Test;

/**
 * ...
 * @author leonaci
 */
class NFASingleMatcherTest extends Test
{
	function test() 
	{
		Assert.isTrue(new NFASingleMatcher('a').match('a'));
		Assert.isFalse(new NFASingleMatcher('a').match('aa'));
		
		Assert.isTrue(new NFASingleMatcher(Symbol.allEnums().map(s -> '\\$s').join('')).match(Symbol.allEnums().join('')));
		Assert.isTrue(new NFASingleMatcher('\\\\').match('\\'));
		
		Assert.isTrue(new NFASingleMatcher('a*b*').match('a'));
		Assert.isTrue(new NFASingleMatcher('a*b*').match('b'));
		Assert.isTrue(new NFASingleMatcher('a*b*').match('ab'));
		Assert.isTrue(new NFASingleMatcher('a*b*').match('aaaaaaaabbbbbbb'));
		Assert.isFalse(new NFASingleMatcher('a*b*').match('ba'));
		Assert.isFalse(new NFASingleMatcher('a*b*').match('aaabaaabbbb'));
		
		Assert.isFalse(new NFASingleMatcher('a+b+').match('a'));
		Assert.isFalse(new NFASingleMatcher('a+b+').match('b'));
		Assert.isTrue(new NFASingleMatcher('a+b+').match('ab'));
		Assert.isTrue(new NFASingleMatcher('a+b+').match('aaaaaaaabbbbbbb'));
		Assert.isFalse(new NFASingleMatcher('a+b+').match('ba'));
		Assert.isFalse(new NFASingleMatcher('a+b+').match('aaabaaabbbb'));
		
		Assert.isTrue(new NFASingleMatcher('(neko)?(inu)?').match('neko'));
		Assert.isTrue(new NFASingleMatcher('(neko)?(inu)?').match('inu'));
		Assert.isTrue(new NFASingleMatcher('(neko)?(inu)?').match('nekoinu'));
		Assert.isFalse(new NFASingleMatcher('(neko)?(inu)?').match('nekoneko'));
		Assert.isFalse(new NFASingleMatcher('(neko)?(inu)?').match('nekoinuneko'));
		Assert.isFalse(new NFASingleMatcher('(neko)?(inu)?').match('inuneko'));
		Assert.isFalse(new NFASingleMatcher('(neko)?(inu)?').match('inuinu'));
		
		Assert.isTrue(new NFASingleMatcher('(a|b)*').match('a'));
		Assert.isTrue(new NFASingleMatcher('(a|b)*').match('ba'));
		Assert.isTrue(new NFASingleMatcher('(a|b)*').match('bbbb'));
		
		Assert.isTrue(new NFASingleMatcher('(a|b)*ab(a|b)*c').match('abc'));
		Assert.isFalse(new NFASingleMatcher('(a|b)*ab(a|b)*c').match('bbbbaaaac'));
		Assert.isTrue(new NFASingleMatcher('(a|b)*ab(a|b)*c').match('babbaabbaabbbc'));
		Assert.isFalse(new NFASingleMatcher('(a|b)*ab(a|b)*c').match('abccc'));
		
		Assert.isTrue(new NFASingleMatcher('ny.+n').match('nyaaaaaan'));
		Assert.isTrue(new NFASingleMatcher('ny.+n').match('nyowaAAawoa2d;Cc01ecaaan'));
		Assert.isFalse(new NFASingleMatcher('ny.+n').match('nyn'));
		
		Assert.isTrue(new NFASingleMatcher('(にゃ)+(ー)*ん').match('にゃん'));
		Assert.isTrue(new NFASingleMatcher('(にゃ)+(ー)*ん').match('にゃにゃにゃん'));
		Assert.isTrue(new NFASingleMatcher('(にゃ)+(ー)*ん').match('にゃにゃにゃにゃにゃーーーん'));
		Assert.isFalse(new NFASingleMatcher('(にゃ)+(ー)*ん').match('にゃんにゃん'));
		Assert.isFalse(new NFASingleMatcher('(にゃ)+(ー)*ん').match('にゃーーにゃにゃーーにゃにゃーーーーん'));
		Assert.isFalse(new NFASingleMatcher('(にゃ)+(ー)*ん').match('にん'));
		
		Assert.isTrue(new NFASingleMatcher('\\d+').match('0123456789'));
		Assert.isFalse(new NFASingleMatcher('\\D+').match('0123456789'));
		Assert.isTrue(new NFASingleMatcher('\\w+').match('She_is_54_years_old'));
		Assert.isFalse(new NFASingleMatcher('\\w+').match('Are you serious?'));
		
		Assert.isTrue(new NFASingleMatcher('[a-d]+').match('abcd'));
		Assert.isFalse(new NFASingleMatcher('[^a-d]+').match('abcd'));
		Assert.isFalse(new NFASingleMatcher('[a-d]+').match('efgh'));
		Assert.isTrue(new NFASingleMatcher('[^a-d]+').match('efgh'));
		
		Assert.isTrue(new NFASingleMatcher('[1-9]\\d*').match('3818403100484172'));
		Assert.isFalse(new NFASingleMatcher('[1-9]\\d*').match('048247719193'));
		
		Assert.isTrue(new NFASingleMatcher('[1-9]\\d*(\\.\\d*)?').match('49419813.191294'));
		Assert.isFalse(new NFASingleMatcher('[1-9]\\d*(\\.\\d*)?').match('20c11b.113ff'));
		
		Assert.isTrue(new NFASingleMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('leonacism@gmail.com'));
		Assert.isTrue(new NFASingleMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('__1234.5678-90@example.com'));
		Assert.isFalse(new NFASingleMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('-test@example.com'));
		Assert.isFalse(new NFASingleMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('test@example...com'));
		
		Assert.isTrue(new NFASingleMatcher('a{0,0}b').match('b'));
		Assert.isFalse(new NFASingleMatcher('a{0,0}b').match('ab'));
		
		Assert.isTrue(new NFASingleMatcher('a{0,2}b').match('b'));
		Assert.isTrue(new NFASingleMatcher('a{0,2}b').match('ab'));
		Assert.isTrue(new NFASingleMatcher('a{0,2}b').match('aab'));
		Assert.isFalse(new NFASingleMatcher('a{0,2}b').match('aaab'));
		
		Assert.isFalse(new NFASingleMatcher('a{1,2}b').match('b'));
		Assert.isTrue(new NFASingleMatcher('a{1,2}b').match('ab'));
		Assert.isTrue(new NFASingleMatcher('a{1,2}b').match('aab'));
		Assert.isFalse(new NFASingleMatcher('a{1,2}b').match('aaab'));
		
		Assert.isFalse(new NFASingleMatcher('a{2}b').match('ab'));
		Assert.isTrue(new NFASingleMatcher('a{2}b').match('aab'));
		Assert.isFalse(new NFASingleMatcher('a{2}b').match('aaab'));
		
		Assert.isTrue(new NFASingleMatcher('a{0,}b').match('b'));
		Assert.isTrue(new NFASingleMatcher('a{0,}b').match('ab'));
		Assert.isTrue(new NFASingleMatcher('a{0,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new NFASingleMatcher('a{1,}b').match('b'));
		Assert.isTrue(new NFASingleMatcher('a{1,}b').match('ab'));
		Assert.isTrue(new NFASingleMatcher('a{1,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new NFASingleMatcher('a{5,}b').match('b'));
		Assert.isFalse(new NFASingleMatcher('a{5,}b').match('aaaab'));
		Assert.isTrue(new NFASingleMatcher('a{5,}b').match('aaaaab'));
		Assert.isTrue(new NFASingleMatcher('a{5,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new NFASingleMatcher('(\\w+)+').match('7cb6a025d54b47bcbc93d16e5293f8d2-'));
	}
}