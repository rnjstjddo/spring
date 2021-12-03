package org.zerock.service;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.service.BoardService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;



@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
//AllArgsConstructor
//@Service 없기에 수동으로 @Setter, @Autowired 사용해서 수동으로 등록해야한다.

public class BoardServiceTests {
	@Setter(onMethod_ = {@Autowired})
	private BoardService service;
	
	@Test
	public void testExist() {
		System.out.println(service);
		assertNotNull(service);
	}
	
	@Test
	public void testGetList() {
		//service.getList().forEach(board->log.info(board));
	
	service.getList(new Criteria(2,10)).forEach(board->log.info(board));
	}
	
	@Test
	public void testGet() {
		System.out.println("===testGet()============"+service.get(3L));
	}
	
	@Test
	public void testDelete() {
		System.out.println("===testDelete()============"+service.remove(10L));
	}
	
	@Test
	public void testUpdate() { //Service()메소드
		BoardVO board =service.get(4L); //Long타입이라 L 붙였다.
		if(board ==null) {return;}
		
		board.setTitle("제목을수정합니다");
		System.out.println("=======================Modify result=========="+service.modify(board));
	}
}
