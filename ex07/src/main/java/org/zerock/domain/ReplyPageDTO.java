package org.zerock.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter //Lombok
public class ReplyPageDTO {

	private int replyCnt; //댓글의 수
	private List<ReplyVO> list; //댓글전체
}
