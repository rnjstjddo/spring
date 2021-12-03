package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.domain.CustomUser;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {

	@Setter(onMethod_ =@Autowired)
	private MemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		
		log.warn("UserName으로 사용자 로드" +userName);
		
		MemberVO vo = memberMapper.read(userName); //userName은 userid를 의미한다.
		
		log.warn("멤버매퍼 쿼리" +vo);

		return vo == null? null : new CustomUser(vo);
	}

}
