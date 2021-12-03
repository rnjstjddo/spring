package org.zerock.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	
		private ReplyService service;

		
		
		@PreAuthorize("isAuthenticated()")
		@PostMapping(value="/new", consumes="application/json",
				produces= {MediaType.TEXT_PLAIN_VALUE})
		public ResponseEntity<String> create(@RequestBody ReplyVO vo){
			
			log.info("ReplyVO: "+ vo);
			int insertCount =service.register(vo);
			log.info("답글 등록수"+insertCount);
			return insertCount ==1
					? new ResponseEntity<>("success", HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); 

		}
		
		//특정게시물의 댓글목록확인
		
		@GetMapping(value ="/pages/{bno}/{page}", 
				produces= {MediaType.APPLICATION_XML_VALUE,
				MediaType.APPLICATION_JSON_UTF8_VALUE})
		public ResponseEntity<ReplyPageDTO> getList( @PathVariable("page") int page, @PathVariable("bno") Long bno ) {
		
			Criteria cri = new Criteria(page,10);
			log.info("댓글 전체목록가져오기" +bno);
			log.info("cri: "+cri);
			return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
			//페이징된 전체 댓글수와 댓글전체목록을 가져온다.
		}
		
		//댓글조회
		
		@GetMapping(value="/{rno}",
				produces= {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
		public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
			log.info("조회:" +rno);
			return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
			
		}
		
		
		//댓글삭제처리시 댓글작성자인지 확인
		@PreAuthorize("principal.username ==#vo.replyer")
		@DeleteMapping(value="{rno}", produces={MediaType.TEXT_PLAIN_VALUE})
		public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno){
			log.info("댓글삭제:" +rno);
			
			//댓글작성자도 확인하자
			log.info("댓글작성자:"+vo.getReplyer());
			
			return service.remove(rno)==1 ? new ResponseEntity<>("success",HttpStatus.OK)
					: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
			
		}
		
		
		//댓글수정
		//스프링 시큐리티 어노테이션 사용해서 댓글작성자 본인인지 확인 후 처리가능하게 한다.
		@PreAuthorize("principal.username ==#vo.replyer")
		@RequestMapping(method= {RequestMethod.PUT, RequestMethod.PATCH},
				value="/{rno}", consumes="application/json")
				//교재에 삭제되어서 주석처리함 produces= {MediaType.TEXT_PLAIN_VALUE}
		public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno){
			vo.setRno(rno);
			log.info("댓글번호: "+rno);
			log.info("수정댓글: "+vo);
			
			return service.modify(vo) ==1 ? new ResponseEntity<>("success",HttpStatus.OK)
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
}
