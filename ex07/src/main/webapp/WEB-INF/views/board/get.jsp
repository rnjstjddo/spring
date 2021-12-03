<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>    
    
<%@include file="../includes/header.jsp" %>


<div class="row">
	<div class="col-lg-12">
		<h1 class='page-header'>Board Read</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
		<div class="paenl-heading">Board Read Page</div>
		
		<!-- /.panel-heading -->
		<div class="panel-body">
		
			<div class="form-group">
				<label>Bno</label> <input class="form-control" name='bno'
				value='<c:out value="${board.bno}"/>' readonly="readonly">
			</div>
		
			<div class="form-group">
				<label>Title</label> <input class="form-contorl" name='title'
				value='<c:out value="${board.title}"/>' readonly="readonly">
			</div>
			
			<div class="form-group">
				<label>Text area</label> <textarea class="form-control" rows="3"
				name='content' readonly="readonly"><c:out value="${board.content}"/>
				</textarea>
			</div>	
			
			<div class="form-group">
				<label>Writer</label> <input class="form-control" name='writer'
				value='<c:out value="${board.writer} "/>' readonly="readonly">
			</div>
			
				<%-- <button data-oper='modify' class="btn btn-default"
				onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button> --%>
				
				
				<sec:authentication property="principal" var="pinfo"/>
				<sec:authorize access="isAuthenticated()">
				<c:if test="${pinfo.username eq board.writer} ">
				<button data-oper='modify' class="btn btn-default">수정</button>
				</c:if>
				</sec:authorize>
				
				<button data-oper='list' class="btn btn-info" onclick="location.href='/board/list'">목록으로</button>
				
				
				
				<form id='operForm' action="/board/modify" method="get">
					<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno }"/>'>
					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
					<input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>	
					<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>
					<input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
				
				</form>
	 		</div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<!-- 조회시 화면에 보여질 첨부파일 이미지영역 -->
<div class='bigPictureWrapper'>
	<div class='bigPicture'>
	</div>
</div>

<style>
.uploadResult{width:100%; background-color:gray;}
.uploadResult ul{display:flex; flex-flow:row; justify-content:center; align-items:center;}
.uploadResult ul li{list-style:none; padding:10px; align-content:center; text-align:center; }
.uploadResult ul li img{width:100px;}
.uploadResult ul lil span{color:white;}
.bigPictureWrapper{position:absolute; display:none; justify-content:center; align-items:center; top:0%; width:100%;
height:100%; background-color:gray; z-index:100; background:rgba(255,255,255,0.5); }
.bigPicture{position:relative; display:flex; justify-content:center; align-items:center;}
.bigPicture img{width:600px;}

</style>

<!-- 첨부파일 공간 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel paenl-default">

			<div class="panel-heading">
				첨부파일들
			</div>
		
			<div class="panel-body">
				<div class="uploadResult"> <!-- 첨부파일 목록보여주는 부분 -->
					<ul>
					</ul>
				</div>
			</div> <!-- 패널바디끝 -->
		</div><!-- 패널디폴트끝 -->	
	</div><!-- col 끝 -->
</div><!--row 끝 -->

<div class='row'>
	<div class="col-lg-12">
	
		<div class="panel panel-default">
		
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> 댓글
				
				<!-- 로그인한 사용자만 댓글달수있게 코드추가 -->
				<sec:authorize access="isAuthenticated()">
				<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>댓글등록</button>
				</sec:authorize>
			</div>
	
			<div class="panel-body">
				<ul class="chat">

					<li class="left clearfix" data-rno='12'>
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong>
								<small-class="pull-right text-muted">2018-01-01 13:11</small>
							</div>
							<p>Good job!</p>
						</div>
					</li> 
				</ul>
			</div> <!-- panel-body 끝 -->
			
			<div class="panel-footer">
			<!-- 자바스크립트로 페이지 계산해서 페이지 끼워넣겠다. -->
			</div> <!-- panel-footer 끝 -->
		
		
		</div><!-- panel panel-default -->
	</div> <!-- col-lg-12 -->
</div> <!-- row끝 -->


<!-- 모달창 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
		
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">댓글 MODAL</h4>
			</div>
			
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name="reply" value="New Reply!!!">
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name="replyer" value="replyer">
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name="replyDate" value="">
				</div>
			</div>
			
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">수정</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">삭제</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary">등록</button>
				<button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			</div>
			
		</div>
	</div>
</div>
					
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
$(document).ready(function(){
	var bnoValue='${board.bno}';
	var replyUL=$(".chat");
	
	showList(1);
	
	function showList(page){ //reply.js 이용해서 댓글페이지 호출
		replyService.getList(
				{bno:bnoValue,page:page||1},
				
				function(replyCnt, list){
					console.log("replyCnt: "+ replyCnt);
					console.log("list: "+list);
					console.log(list);
			
			if(page == -1){
				pageNum =Math.ceil(replyCnt/10.0);
				showList(pageNum);
				return;
			}
			
						
			var str="";
			if(list == null || list.length ==0){
				return;
				}
			
			for(var i=0,len=list.length||0;i<len;i++){
				str+="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
				str+="	<div>";
				str+="		<div class='header'>";
				str+="			<strong class='primary-font'>"+list[i].replyer+"</strong>";
				str+="			<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small>";
				str+="		</div>";
				str+="		<p>"+list[i].reply+"</p>";
				str+="	</div>";
				str+="</li>";		
				
			}
			replyUL.html(str);
			
			showReplyPage(replyCnt);
		}); //function 끝
		
	} //showList(page) 끝
	
	
	/* 모달 */
	var modal=$(".modal");
	var modalInputReply=modal.find("input[name='reply']");
	var modalInputReplyer=modal.find("input[name='replyer']");
	var modalInputReplyDate=modal.find("input[name='replyDate']");
	
	var modalModBtn=$("#modalModBtn");
	var modalRemoveBtn=$("#modalRemoveBtn");
	var modalRegisterBtn=$("#modalRegisterBtn");
	
	//로그인한 멤버가 댓글 작성자가 되도록 코드추가
	var replyer =null;
	
	<sec:authorize access="isAuthenticated()">
	replyer='<sec:authentication property="principal.username"/>'
	</sec:authorize>
	
	var csrfHeaderName ="${_csrf.headerName}";
	var csrfTokenValue="${_csrf.token}";
	
	
	$("#addReplyBtn").on("click",function(e){
		modal.find("input").val("");
		
		//현재 로그인한 사용자의 이름으로 replyer 항목이 고정되도록 한다.
		modal.find("input[name='replyer']").val(replyer);
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id != 'modalCloseBtn']").hide();
		
		modalRegisterBtn.show()
		
		$(".modal").modal("show");	
	}); //#addReplyBtn
	
	//$.ajax 이용해 CSRF 토큰처리 기본설정
	//모든 ajax 전송시 CSRF 토큰을 같이 전송하도록 세팅
	$(document).ajaxSend(function(e, xhr, options){
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	
	//새로운 댓글추가처리
	modalRegisterBtn.on("click",function(e){
		var reply={
				reply:modalInputReply.val(),
				replyer:modalInputReplyer.val(),
				bno:bnoValue
		};
		replyService.add(reply,function(result){
			alert(result);
			
			modal.find("input").val("");
			modal.modal("hide")
			
			showList(-1);
		});
	});//modalRegisterBtn.on() 종료
	
	
	//댓글이벤트처리
	$(".chat").on("click", "li", function(e){
		var rno = $(this).data("rno");
		
		console.log(rno);
		replyService.get(rno, function(reply){
			modalInputReply.val(reply.reply);
			modalInputReplyer.val(reply.replyer);
			modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
			modal.data("rno", reply.rno);
			
			modal.find("button[id != 'modalCloseBtn']").hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			
			$(".modal").modal("show");
		});
	});
	
	//댓글수정
	modalModBtn.on("click", function(e){
		
		//댓글작성도 함께 전달된다.	
	
		var originalReplyer = modalInputReplyer.val();
		var reply ={
				rno:modal.data("rno"),
				replyer:modalInputReply.val(),
				replyer:originalReplyer();
		
		if(!replyer){
			alert("로그인후 댓글수정이 가능합니다.");
			modal.modal("hide");
			return;	
		}
		console.log("댓글작성자"+originalReplyer);
		
		if(replyer !=originalReplyer){
			alert("본인 댓글만 수정가능합니다.");
			modal.modal("hide");
			return;
		}
		
		}
		
		replyService.update(reply, function(result){
			alert(result);
			modal.modal("hide");
			showList(pageNum);
		});
	});
	
	//댓글삭제
	modalRemoveBtn.on("click", function(e){
		console.log("Modal 댓글삭제클릭");
		var rno = modal.data("rno");
		
		//rno, replyer 고정시켰는데 브라우저에서 콘솔로 확인
		console.log("RNO댓글번호"+rno);
		console.log("REPLYER 작성자"+replyer);
		
		//댓글작성자만 댓글삭제가능하도록 한다.
		if(!replyer){ //로그인한 사람 =replyer 댓글을 달사람
			alert("로그인 후 삭제가능합니다");
			modal.modal("hide");
			return;
		}
		
		var originalReplyer = modalInputReplyer.val();
		console.log("기존 댓글작성자:"+originReplyer);
		
		if(replyer != originReplyer){ //기존 댓글작성자. 로그인한 멤버와는 다를수 있다.
			alert("댓글 작성자 본인만 삭제 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		replyService.remove(rno, orginalReplyer, function(result){
			alert(result);//경고창으로 결과를 보인다.
			modal.modal("hide");//모달창은 숨긴다.
			showList(pageNum);//댓글삭제처리후 기존 페이지로 돌아가자
		});
	});
	
	
	//댓글페이지번호출력
	
	
	var pageNum =1;
	var replyPageFooter =$(".panel-footer");
	
	function showReplyPage(replyCnt){
		
		var endNum =Math.ceil(pageNum /10.0) *10;
		var startNum =endNum-9;
		
		var prev =startNum != 1; //1이면 이전표시 안보인다. =! 먼저계산된다.
		var next=false;
		
			if(endNum *10 >=replyCnt){ //endPage=10,20,30
				endNum =Math.ceil(replyCnt/10.0);
			}
			
			if(endNum *10 <replyCnt){
				next =true;
			}
			
		
		var str ="<ul class='pagination pull-right'>";
		
			if(prev){ //댓글이전페이지
				str += "<li class='page-item'>";
				str += "<a class='page-link' href='"+(startNum -1)+"'>이전</a></li>";
			}
		
			for(var i= startNum; i<=endNum; i++){
				var active = pageNum == i ? "active" : "";
				
				str+="<li class='page-item"+active+"'>"; //페이지 파란색으로 번호활성화시켜주는 코드 댓글페이징디자인
				str+="<a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}
		
		
			if(next){//댓글다음페이지
				str+="<li class='page-item'>";
				str+="<a class='page-link' href='"+(endNum+1)+"'>다음</a></li>";
			}
		
		str +="</ul></div>";
			
		console.log(str);
		replyPageFooter.html(str);	
	}//showReplyPage(replyCnt) 함수 끝
	
	//replyPageFooter는 $(".panel-footer") 대입.
	replyPageFooter.on("click", "li a",  function(e){ //번호있는 것을 클릭-> li a
		e.preventDefault();
		console.log("페이지클릭");
		
		var targetPageNum =$(this).attr("href"); //this는 a를 가리킨다. 하이퍼링크 속성.
		
		console.log("targetPageNum:" + targetPageNum);
		
		pageNum =targetPageNum;
		
		showList(pageNum);
	});
	
	
}); // $(document).ready(function(){}) 종료


/* console.log("=============================");
console.log("자바스크립트 테스트");
 */
//댓글 자바스크립트 등록테스트
//var bnoValue = '<c:out value="${board.bno}"/>';


//테스트를 위한 replyService add
/* replyService.add( //객체의 메소드 함수호출
		{reply:"자바스크립트 테스트",replyer:"테스터", bno:bnoValue},
		function(result){alert("결과: "+result);
		}
		);
 */

//댓글조회
/* replyService.getList({bno:bnoValue, page:1}, function(list){
	
	for(var i=0, len=list.length||0; i<len; i++){
		console.log(list[i]);
	}
}); */

//20번 댓글삭제테스트
/* replyService.remove(22, function(count){
	
	console.log(count);
	if(count ==="success"){
		alert("삭제완료");
	}
}, function(err){alert('에러발생');
}); */

//19번데이터 수정
/* replyService.update({
	rno:23,
	bno:bnoValue,
	reply:"댓글수정1"
}, function(result){
	alert("수정완료");
});
 */

/* replyService.get(10, function(data){
	console.log(data);
}); */

</script>



<script type="text/javascript">
$(document).ready(function(){
	var operForm =$("#operForm");
	
	$("button[data-oper='modify']").on("click", function(e){
		operForm.attr("action","/board/modify").submit();
	});
	
	$("button[data-oper='list']").on("click",function(e){
		modal.find("input").val("");
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id='modalModBtn']").hide();
		modal.find("button[id='modalRemoveBtn']").hide();
		
		$(".modal").modal("show");
	});
});
</script>  			

<script type="text/javascript">
$(document).ready(function(){
	(function(){
		var bno ='<c:out value="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
			//요청URI, 넘어온 게시글번호, 요청결과
			console.log(arr);
			
			var str="";
			$(arr).each(function(i, attach){
				//for문 돈다. i인덱스번호, attach 객체값.
				//이미지타입 여부 
				if(attach.fileType){
					var fileCallPath=encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
					//웨브라우저에서 알수있는 형태로 바꿔준다. 역슬래시 사용못하기 때문에.
					str+="<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
					str+="<img src='/display?fileName="+fileCallPath+"'></div></li>";
				}else{
					str+="<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' ";
					str+="data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
					str+="<span>"+attach.fileName+"</span><br/>";
					str+="<img src='/resources/img/attach.png'></div></li>";
					//내 폴더에 있는 이미지를 가져올거기에 encodeURIComopnent() 메소드 사용해서 역슬래시 바꿀필요없다.
				}
			}); //$(arr).each 끝
			$(".uploadResult ul").html(str);
			
		});//$.getJSON 끝
	})();//function 끝


$(".uploadResult").on("click", "li",function(e){
	console.log("이미지 보기");
	
	var liObj =$(this); //li를 말한다.
	
	var path =encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
	
	if(liObj.data("type")){
		showImage(path.replace(new RegExp(/\\/g), "/")); //역슬래시 2개를 슬래시로 바꾸자.
	}else{
		self.location="/download?fileName="+path;
	}
	
});

function showImage(fileCallPath){
	
	alert(fileCallPath);
	$(".bigPictureWrapper").css("display", "flex").show();
	$(".bigPicture")
	.html("<img src='/display?fileName="+fileCallPath+"'>")
	.animate({width:'100%', height:'100%'},1000);
	}//showImage() 함수 끝

	$(".bigPictureWrapper").on("click", function(e){
	$(".bigPicture").animate({width:'0%', height:'0%'},1000);
	setTimeout(function(){
		$('.bigPictureWrapper').hide();}, 1000);
	});//bigPictureWrapper.on() 제이쿼리 끝
	});//$(document).ready()끝
</script> 


<%@include file="../includes/footer.jsp" %>
			
			