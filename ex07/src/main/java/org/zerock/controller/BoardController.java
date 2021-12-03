package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller //스프링 빈으로 인식
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
	private BoardService service;
	//@Controller BoardController 객체생성해서 생성자에 service 넣는다. 
	
	@GetMapping("/list")
		//public void list(Model model) {
		//log.info("list 요청실행"+cri);
		//List<BoardVO> list = service.getlist();
		//model.addAttribute("list", service.getList());
	public void list(Criteria cri, Model model) {
		log.info("list"+cri);
		model.addAttribute("list", service.getList(cri));//cri변수가 1페이지당 10개 미리 변수값 넣어놓음
		//model.addAttribute("pageMaker", new PageDTO(cri, 123));
		//list 는 목록보여주기
		int total =service.getTotal(cri); //Service.java파일에 있는 getTotal()메소드
		log.info("total: "+ total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		//pageMaker 하단 페이징처리
	}
		
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")

	public void register() { //입력페이지 보여주는 역할만 하기에 별도 처리필요없다.
		//게시글 등록버튼 클릭시 여기로 온다.
		}
		 
	
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		
		System.out.println("================등록:"+board);
		
		log.info("등록:"+board);
		
		if(board.getAttachList() !=null) {
			board.getAttachList().forEach(attach -> log.info(attach));	
		}
		log.info("등록완료=================");
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		
		//rttr 은 리다이렉트 객체.
		return "redirect:/board/list";
	}
	
	
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
		//model.addAttribute("cri",cri); @ModelAttribute("cri")
	}
	
	
	//본인만 수정하수있도록 한다.
	@PreAuthorize("principal.username == #board.wrtier")
	@PostMapping("/modify") //수정과 등록에는 BoardVO 객체가 필요하다.
	public String modify(BoardVO board,@ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("수정: "+ board);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result","success");//1회성
		}
		rttr.addAttribute("pageNum", cri.getPageNum()); //URL로 계속 써먹을수있다.
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list" +cri.getListLink();
	}
	
	
	
	//삭제시 본인만 가능하게 한다.
	@PreAuthorize("principal.username ==#writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri,
			RedirectAttributes rttr, String writer) {
		//param 같다면 @RequestParam("") 사용하지 않아도 된다.
		log.info("게시글 삭제 "+bno);
		System.out.println("게시글 삭제 "+bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {// DB 2개 테이블 삭제, 자식먼저 삭제한뒤 폴더 안의 삭제.
 			//첨부파일삭제
			deleteFiles(attachList); //BoardController deleteFiles() 메소드로 첨부파일을 삭제하겠다.
			
			rttr.addFlashAttribute("result","success");
		}
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list" + cri.getListLink();
	}

	
	
	@GetMapping(value="/getAttachList",
			produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
		@ResponseBody
		public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		System.out.println("BoardController getAttachList() 메소드");
		log.info("첨부파일목록조회: "+ bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	//첨부파일 폴더 삭제처리
	private void deleteFiles(List<BoardAttachVO> attachList) {
		
		if(attachList == null || attachList.size() ==0 ) {
			return;
		}
		
		log.info("첨부파일삭제");
		log.info(attachList);
		
		attachList.forEach(attach ->{
			try {
				Path file =Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\"+ //연도별폴더생성된것.
 			attach.getUuid()+"_"+attach.getFileName()); //이미지이든 아니는 모두 
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")){
					
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+
							"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
			}catch(Exception e) {
				log.error("파일삭제에러" + e.getMessage());
			} //catch문 끝
		});//forEach문 끝
	} //deleteFiles() 메소드 끝
	
	
	
}
