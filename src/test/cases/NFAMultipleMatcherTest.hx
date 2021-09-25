package test.cases;
import matcher.NFAMultipleMatcher;
import parser.Symbol;
import utest.Assert;
import utest.Test;

/**
 * ...
 * @author leonaci
 */
class NFAMultipleMatcherTest extends Test
{
	function test() 
	{
		Assert.isTrue(new NFAMultipleMatcher('a').match('a'));
		Assert.isFalse(new NFAMultipleMatcher('a').match('aa'));
		
		Assert.isTrue(new NFAMultipleMatcher(Symbol.allEnums().map(s -> '\\$s').join('')).match(Symbol.allEnums().join('')));
		Assert.isTrue(new NFAMultipleMatcher('\\\\').match('\\'));
		
		Assert.isTrue(new NFAMultipleMatcher('a*b*').match('a'));
		Assert.isTrue(new NFAMultipleMatcher('a*b*').match('b'));
		Assert.isTrue(new NFAMultipleMatcher('a*b*').match('ab'));
		Assert.isTrue(new NFAMultipleMatcher('a*b*').match('aaaaaaaabbbbbbb'));
		Assert.isFalse(new NFAMultipleMatcher('a*b*').match('ba'));
		Assert.isFalse(new NFAMultipleMatcher('a*b*').match('aaabaaabbbb'));
		
		Assert.isFalse(new NFAMultipleMatcher('a+b+').match('a'));
		Assert.isFalse(new NFAMultipleMatcher('a+b+').match('b'));
		Assert.isTrue(new NFAMultipleMatcher('a+b+').match('ab'));
		Assert.isTrue(new NFAMultipleMatcher('a+b+').match('aaaaaaaabbbbbbb'));
		Assert.isFalse(new NFAMultipleMatcher('a+b+').match('ba'));
		Assert.isFalse(new NFAMultipleMatcher('a+b+').match('aaabaaabbbb'));
		
		Assert.isTrue(new NFAMultipleMatcher('(neko)?(inu)?').match('neko'));
		Assert.isTrue(new NFAMultipleMatcher('(neko)?(inu)?').match('inu'));
		Assert.isTrue(new NFAMultipleMatcher('(neko)?(inu)?').match('nekoinu'));
		Assert.isFalse(new NFAMultipleMatcher('(neko)?(inu)?').match('nekoneko'));
		Assert.isFalse(new NFAMultipleMatcher('(neko)?(inu)?').match('nekoinuneko'));
		Assert.isFalse(new NFAMultipleMatcher('(neko)?(inu)?').match('inuneko'));
		Assert.isFalse(new NFAMultipleMatcher('(neko)?(inu)?').match('inuinu'));
		
		Assert.isTrue(new NFAMultipleMatcher('(a|b)*').match('a'));
		Assert.isTrue(new NFAMultipleMatcher('(a|b)*').match('ba'));
		Assert.isTrue(new NFAMultipleMatcher('(a|b)*').match('bbbb'));
		
		Assert.isTrue(new NFAMultipleMatcher('(a|b)*ab(a|b)*c').match('abc'));
		Assert.isFalse(new NFAMultipleMatcher('(a|b)*ab(a|b)*c').match('bbbbaaaac'));
		Assert.isTrue(new NFAMultipleMatcher('(a|b)*ab(a|b)*c').match('babbaabbaabbbc'));
		Assert.isFalse(new NFAMultipleMatcher('(a|b)*ab(a|b)*c').match('abccc'));
		
		Assert.isTrue(new NFAMultipleMatcher('ny.+n').match('nyaaaaaan'));
		Assert.isTrue(new NFAMultipleMatcher('ny.+n').match('nyowaAAawoa2d;Cc01ecaaan'));
		Assert.isFalse(new NFAMultipleMatcher('ny.+n').match('nyn'));
		
		Assert.isTrue(new NFAMultipleMatcher('(にゃ)+(ー)*ん').match('にゃん'));
		Assert.isTrue(new NFAMultipleMatcher('(にゃ)+(ー)*ん').match('にゃにゃにゃん'));
		Assert.isTrue(new NFAMultipleMatcher('(にゃ)+(ー)*ん').match('にゃにゃにゃにゃにゃーーーん'));
		Assert.isFalse(new NFAMultipleMatcher('(にゃ)+(ー)*ん').match('にゃんにゃん'));
		Assert.isFalse(new NFAMultipleMatcher('(にゃ)+(ー)*ん').match('にゃーーにゃにゃーーにゃにゃーーーーん'));
		Assert.isFalse(new NFAMultipleMatcher('(にゃ)+(ー)*ん').match('にん'));
		
		Assert.isTrue(new NFAMultipleMatcher('\\d+').match('0123456789'));
		Assert.isFalse(new NFAMultipleMatcher('\\D+').match('0123456789'));
		Assert.isTrue(new NFAMultipleMatcher('\\w+').match('She_is_54_years_old'));
		Assert.isFalse(new NFAMultipleMatcher('\\w+').match('Are you serious?'));
		
		Assert.isTrue(new NFAMultipleMatcher('[a-d]+').match('abcd'));
		Assert.isFalse(new NFAMultipleMatcher('[^a-d]+').match('abcd'));
		Assert.isFalse(new NFAMultipleMatcher('[a-d]+').match('efgh'));
		Assert.isTrue(new NFAMultipleMatcher('[^a-d]+').match('efgh'));
		
		Assert.isTrue(new NFAMultipleMatcher('[1-9]\\d*').match('3818403100484172'));
		Assert.isFalse(new NFAMultipleMatcher('[1-9]\\d*').match('048247719193'));
		
		Assert.isTrue(new NFAMultipleMatcher('[1-9]\\d*(\\.\\d*)?').match('49419813.191294'));
		Assert.isFalse(new NFAMultipleMatcher('[1-9]\\d*(\\.\\d*)?').match('20c11b.113ff'));
		
		Assert.isTrue(new NFAMultipleMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('leonacism@gmail.com'));
		Assert.isTrue(new NFAMultipleMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('__1234.5678-90@example.com'));
		Assert.isFalse(new NFAMultipleMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('-test@example.com'));
		Assert.isFalse(new NFAMultipleMatcher('\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*').match('test@example...com'));
		
		Assert.isTrue(new NFAMultipleMatcher('a{0,0}b').match('b'));
		Assert.isFalse(new NFAMultipleMatcher('a{0,0}b').match('ab'));
		
		Assert.isTrue(new NFAMultipleMatcher('a{0,2}b').match('b'));
		Assert.isTrue(new NFAMultipleMatcher('a{0,2}b').match('ab'));
		Assert.isTrue(new NFAMultipleMatcher('a{0,2}b').match('aab'));
		Assert.isFalse(new NFAMultipleMatcher('a{0,2}b').match('aaab'));
		
		Assert.isFalse(new NFAMultipleMatcher('a{1,2}b').match('b'));
		Assert.isTrue(new NFAMultipleMatcher('a{1,2}b').match('ab'));
		Assert.isTrue(new NFAMultipleMatcher('a{1,2}b').match('aab'));
		Assert.isFalse(new NFAMultipleMatcher('a{1,2}b').match('aaab'));
		
		Assert.isFalse(new NFAMultipleMatcher('a{2}b').match('ab'));
		Assert.isTrue(new NFAMultipleMatcher('a{2}b').match('aab'));
		Assert.isFalse(new NFAMultipleMatcher('a{2}b').match('aaab'));
		
		Assert.isTrue(new NFAMultipleMatcher('a{0,}b').match('b'));
		Assert.isTrue(new NFAMultipleMatcher('a{0,}b').match('ab'));
		Assert.isTrue(new NFAMultipleMatcher('a{0,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new NFAMultipleMatcher('a{1,}b').match('b'));
		Assert.isTrue(new NFAMultipleMatcher('a{1,}b').match('ab'));
		Assert.isTrue(new NFAMultipleMatcher('a{1,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new NFAMultipleMatcher('a{5,}b').match('b'));
		Assert.isFalse(new NFAMultipleMatcher('a{5,}b').match('aaaab'));
		Assert.isTrue(new NFAMultipleMatcher('a{5,}b').match('aaaaab'));
		Assert.isTrue(new NFAMultipleMatcher('a{5,}b').match('aaaaaaaaaaab'));
		
		Assert.isFalse(new NFAMultipleMatcher('(\\w+)+').match('7cb6a025d54b47bcbc93d16e5293f8d2-'));
	}
}