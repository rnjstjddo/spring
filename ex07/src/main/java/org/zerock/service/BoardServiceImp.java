package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
//@AllArgsConstructor //Lombok 생성자를 자동으로 만들어준다. 스프링4.3부터 @Autowired  @Setter 생략.
public class BoardServiceImp implements BoardService {
	
	@Setter(onMethod_= @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_= @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("게시글등록"+board);
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() ==null || board.getAttachList().size() <=0) {
			return;		
		}	
		
		board.getAttachList().forEach(attach ->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		System.out.println("게시글 수정"+board);
		log.info("게시글수정"+board);
		
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult =mapper.update(board) ==1;
		
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() >0) {
			//매개변수로 넘오온 BoardVO 객체인 board
			board.getAttachList().forEach(attach ->{
				
				attach.setBno(board.getBno());
				attachMapper.insert(attach); //기존꺼 DB 첨부파일 tbl_attach 지우고 새로 insert 된다.
			}); //forEach(attach -> {}) 끝
			
		} // if문 끝
		return modifyResult;
		//return mapper.update(board) ==1;
	}

	
	/*
	 * @Override public List<BoardVO> getList() {
	 * System.out.println("===================getList=============="); return
	 * mapper.getList(); }
	 */
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		System.out.println("게시글삭제"+bno);
		log.info("삭제"+bno);
		
		attachMapper.deleteAll(bno);
		
		return mapper.delete(bno) ==1;
		//remove() 메소드의 반환값이 boolean이기에 true/false 로 return 값이
		//나오려면 처리결과 int의 수의 정상적으로 수정, 삭제시 1값이 되기에 다시 타입을 boolean으로
		//맞추기위해서다.
	}

	@Override
	public BoardVO get(Long bno) {
		System.out.println("게시글조회"+bno);
		return mapper.read(bno);
	}
	

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("criteria +게시글목록조회" + cri);
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotal(Criteria cri) {
		log.info("게시글총개수 조회");
		return mapper.getTotalCount(cri);
		
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {

		log.info("게시글번호에 해당하는 첨부파일목록 조회"+ bno);
		System.out.println("BoardServiceImp getAttachList() 메소드 ");
		return attachMapper.findByBno(bno);
	}
}
