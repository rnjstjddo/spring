/**
 * 
 */

/*console.log("답변모듈");
var replyService =(function(){
	
	return {name:"AAAA"};
});
*/

/*console.log("답변모듈");
var replyService=(function(){
		
	function add(reply, callback){ //reply는 JSON 포맷.
		console.log("답글");
	}
	
	return {add:add};// 앞변수, 뒤는값인데 메소드 add와 동일하기에 함수 주소값 리턴된다.
})();*/


console.log("답변모듈");
var replyService =(function(){
	
	//add함수
	function add(reply, callback, error){
	console.log("답변추가");
	
	$.ajax({
		type:'post',
		url:'/replies/new',
		data:JSON.stringify(reply),
		contentType:"application/json; charset=utf-8",
		success:function(result, status, xhr){
			//성공했을때 result가 success 가 들어가고. status에 OK들어간다. 
			if(callback){// 서버에서 보내준 함수. 
				callback(result);
			}
		},
		error:function(xhr, status, er){
			if(error) error(er);
		}
	}) //ajax 끝
	} //fuction() add 끝
	
	
	//댓글목록
	function getList(param, callback, error){
		var bno =param.bno;
		var page =param.page || 1;
		
		$.getJSON("/replies/pages/" +bno+"/" +page+".json", 
				function(data){ //data에 객체가 담긴다. ReplPageDTO
					if(callback){
					//{callback(data);} 댓글 목록만 가져오는 경우
						callback(data.replyCnt, data.list); //댓글숫자와 목록을 가져오는 경우	
						}
					}).fail(function(xhr, status, err){
						
					if(error)
						{error();
						}	
				});
		}
	
	//댓글삭제와 갱신
	//replyer 도 같이 전송해야한다. 매개변수에 추가
	function remove(rno, replyer, callback, error){
		$.ajax({
			type:'delete',
			url: '/replies/'+rno,
			
			data:JSON.stringify({rno:rno, replyer:replyer}),
			contentType:"application/json; charset=urf-8",
			
			success :function(deleteResult, status, xhr){
				if(callback){callback(deleteResult);
				}
				},
			error: function(xhr, status, er){
				if(error){error(er);}
				}	
		}); //$.ajax 끝
		
	}//remove() 함수 끝
	
	
	//댓글수정
	function update(reply, callback, error){ //get.jsp 수정버튼 클릭시 reply 객체가 넘어온다.
		
		console.log("RNO:"+ reply.rno);
		$.ajax({
			type:'put',
			url:'/replies/' +reply.rno,
			data: JSON.stringify(reply),
			contentType:"application/json; charset=utf-8",
			success:function(result, status, xhr){
				if(callback){callback(result)};	
		},
		error: function(xhr, status, er){
			if(error){error(er);
				}
		}
		});
		
	}
	
	//댓글조회처리
	function get(rno, callback, error){
		$.get("/replies/"+rno+".json", function(result){
			if(callback){callback(result);}
		}).fail(function(xhr, status, err){
			if(error){error()}
		});
	}
	
	
	//시간에 대한 처리
	function displayTime(timeValue){
		
		var today = new Date();
		var gap =today.getTime()-timeValue; //오늘날짜 시간으로 알려준다.
		var dateObj = new Date(timeValue);
		var str="";
		
		if(gap <(1000*60*60*24)){
		//1일 =1000x60x60x24 1일을 초로 
		
			var hh =dateObj.getHours();
			var mi =dateObj.getMinutes();
			var ss =dateObj.getSeconds();
			
			return [(hh>9 ? '' : '0') +hh , ':', (mi >9 ? '' :'0') +mi,
				':', (ss>9 ? '' :'0') +ss].join('');
		}else{
			
			var yy =dateObj.getFullYear();
			var mm =dateObj.getMonth()+1;
			var dd =dateObj.getDate();
			
			return [yy, '/', (mm > 9 ? '' :'0') +mm ,'/',
				(dd > 9 ? '' :'0')+dd].join('');
			
		}
		}
	
		return {
			add:add,
			getList:getList,
			remove:remove,
			update:update,
			get:get,
			displayTime:displayTime
		};
	})(); //replyService 즉시실행함수 끝

