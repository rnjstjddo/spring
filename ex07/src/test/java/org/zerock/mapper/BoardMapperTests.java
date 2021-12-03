package org.zerock.mapper;

import static org.junit.Assert.fail;

import java.sql.Connection;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapper;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	
	@Autowired
	private BoardMapper mapper;
	
	@Test
	public void testGetList() {
		mapper.getList().forEach(board->log.info(board));
	}
	
	@Test
	public void testInsert() {
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글");
		board.setContent("새로 작성하는 내용");
		board.setWriter("newbie");
		mapper.insert(board);
		log.info(board);
		//Lombok이 만들어주는 toString() 이용해서 bno 멤버변수의(인스턴스변수) 값을
		//알아보기 위해서다.	
	}
	
	@Test
	public void testRead() {
		BoardVO board =mapper.read(5L);
		log.info(board);
	}
	
	@Test
	public void testDelete() {
		System.out.println("Delete count =" +mapper.delete(8L));	
	}
	
	@Test
	public void testUpdate() {
		BoardVO board = new BoardVO();
		board.setBno(3L);
		board.setTitle("수정된 제목");
		board.setContent("수정된 내용");
		board.setWriter("user00");
		
		int count =mapper.update(board);
		System.out.println("update count: "+ count);
	}
	/*
	 * @Test public void testPaging() { Criteria cri = new Criteria(); List<BoardVO>
	 * list = mapper.getListWithPaging(cri); list.forEach(board -> log.info(board));
	 * 
	 * }
	 */
	
	@Test
	public void testPaging() {
		Criteria cri = new Criteria();
		//10개씩 3페이지
		 cri.setPageNum(3);
		 cri.setAmount(5);
		
		 
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board.getBno()));	
		
		/*
		 * for(BoardVO board:list) { System.out.println(board); }
		 */
		
		//mapper.getListWithPaging(cri).forEach(board->log.info(board));
	}
	
	@Test
	public void testSearch() {
		Criteria cri = new Criteria();
		cri.setKeyword("테스트");
		cri.setType("T");
		
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board));	
	}
	
}
