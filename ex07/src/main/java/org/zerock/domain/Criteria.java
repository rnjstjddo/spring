package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {

	private int pageNum;
	private int amount;
	
	private String type;
	private String keyword;
	
	public Criteria() {
		this(1,10);
		//this.pageNum =1;
		//this.amount =10;
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum =pageNum;
		this.amount =amount;
	}
	
	public String[] getTypeArr() {
		return type == null ? new String [] {} : type.split("");
		
	}
	
	public String getListLink() {//노출된다.get
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				//.queryParam("pageNum", pageNum) 같은
				.queryParam("amount", this.getAmount())
				//.queryParam("amount", amount)
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
				return builder.toUriString();	
	}
	
}
