package org.zerock.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	
	private Long[] bnoArr = {256L, 255L, 254L };
	
	@Test
	public void testCreate() {
		
		IntStream.rangeClosed(1,10).forEach(i->{
			ReplyVO vo = new ReplyVO();
			vo.setBno(bnoArr[i%5]);
			vo.setReply("댓글테스트:"+i);
			vo.setReplyer("replyer: "+i);
			mapper.insert(vo);
		});
	}
	
	
	@Test
	public void testMapper() {		
		log.info(mapper);	
	}
	
	@Test
	public void testRead() {
		Long targetRno =3L;
		ReplyVO vo = mapper.read(targetRno);
		log.info(vo);
		//System.out.println("3L 3번댓글"+ vo);
	}
	
	@Test
	public void testDelete() {
		Long targetRno = 3L;
		mapper.delete(targetRno);
	}
	
	@Test
	public void testUpdate() {
		Long targetRno =2L;
		ReplyVO vo = mapper.read(targetRno);
		vo.setReply("수정1");
		int count = mapper.update(vo);
		log.info("수정 게시글수: "+count);
	}
	
	@Test
	public void testList() {
		Criteria cri = new Criteria();
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
		replies.forEach(reply -> log.info(reply));
	}
	
	@Test
	public void testList2() {
		Criteria cri = new Criteria(2,10);
		List<ReplyVO> replies = mapper.getListWithPaging(cri, 255L); //255번 댓글 가져온다.
		replies.forEach(reply -> log.info(reply));
		
	}
	
	

}
