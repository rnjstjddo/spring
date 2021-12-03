package org.zerock.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml",
	//mapper파일, service scan base-package
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
	//controller파일 scan base-package
@Log4j

public class BoardControllerTests {
	@Setter(onMethod_ = {@Autowired})
	private WebApplicationContext ctx;
	private MockMvc mockMvc;
	
	@Before
	public void setup() {
		this.mockMvc =MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void testList() throws Exception{
		log.info(mockMvc.perform(MockMvcRequestBuilders
					.get("/board/list"))
				.andReturn()
				.getModelAndView() //Model List들어있고 View는  jsp
				.getModelMap());
	//Model 안에 List 객체 들어있다. modle.addAttribute("list",list) 키와 값 가지는 맵형태로 Model 구성.
	}
	
	@Test
	public void testRegister() throws Exception {
		String resultPage = mockMvc.perform(MockMvcRequestBuilders
					.post("/board/register")
					.param("title", "테스트 새글제목")
					.param("content","테스트 새글내용")
					.param("writer","user00"))
				//form에서 name과 value 각각 의미. form은 post방식.
				.andReturn()
				.getModelAndView()
				.getViewName(); //redirect
				//set 메소드로 BoardVO 에 담겨진다. 이들 내용이.
		log.info(resultPage); //"redirect:/board/list/"
	}
	
	@Test
	public void testGet() throws Exception{
		
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/get")
					.param("bno","2"))
				.andReturn()
				.getModelAndView()
				.getModelMap()); //get
	}
	
	@Test
	public void testModify() throws Exception{
		
		String resultPage =mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
				.param("bno","1").param("title","수정된 테스트 새글제목").param("content","수정된 테스트 새글내용").param("writer","user00"))
				.andReturn().getModelAndView().getViewName();
		log.info(resultPage);
	}
	
	@Test
	public void testRemove() throws Exception{
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
				.param("bno", "1"))
				.andReturn().getModelAndView().getViewName();//list로 갈거기에 ViewName
		log.info(resultPage);
	}
	
	@Test
	public void testListPaging() throws Exception{
		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list")
				.param("pageNum", "2") //2번 페이지 10개 게시글만 보겠다
				.param("amount","10"))
				.andReturn().getModelAndView().getModelMap());
	}
}
