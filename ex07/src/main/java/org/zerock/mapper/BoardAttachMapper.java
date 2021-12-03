package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardAttachVO;

public interface BoardAttachMapper {
	
	public void insert(BoardAttachVO vo);
	
	public void delete(String uuid);
	
	public List<BoardAttachVO> findByBno(Long bno);
	
	public void deleteAll(Long bno);

	//첨부파일 목록을 가져오는 메소드 추가. 잘못업로드된 파일삭제시  필요.
	public List<BoardAttachVO> getOldFiles();

}
