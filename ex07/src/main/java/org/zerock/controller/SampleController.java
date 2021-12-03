package org.zerock.controller;

import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Log4j
@RequestMapping("/sample/*")
@Controller
public class SampleController {
	
	@GetMapping("/all")
	public void doAll() {
		log.info("전체 접근");
	}
	
	@GetMapping("/member")
	public void doMember() {
		log.info("멤버 접근");
	}
	
	@GetMapping("/admin")
	public void doAdmin() {
		log.info("관리자 접근");
	}
	
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_MEMBER')")
	@GetMapping("/annoMember") //sample 폴더안에 annoMember.jsp 파일 만들지않았기에 서버는 에러  info 콘솔만출력.
	public void doMember2() {
		log.info("로그인한 어노테이션 멤버");
	}

	@Secured({"ROLE_ADMIN"})
	@GetMapping("/annoAdmin")//sample 폴더안에 annoAdmin.jsp 파일 만들지않았기에 서버는 에러  info 콘솔만출력.
	public void doAdmin2() {
		log.info("admin 만 어노테이션");
	}

}



