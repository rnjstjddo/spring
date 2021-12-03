package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor //모든 속성을 사용하는 생성자
@NoArgsConstructor //비어있는 생성자
public class SampleVO {	//XML과 JSON 방식의 데이터를 생성할수 있도록 작성.

	private Integer mno;
	private String firstName;
	private String lastName;
	
}
	