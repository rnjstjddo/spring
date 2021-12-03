<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>    
    
<%@include file="../includes/header.jsp" %>


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


<script type="text/javascript">
$(document).ready(function(){
	
	var formObj =$("form");
	//form 전체 객체값을 가져온다. form roll="form" 의 form
	$('button').on("click", function(e){
		e.preventDefault();
		
		var operation =$(this).data("oper");
		//button 클릭된 버튼 3개중에
		console.log(operation);
		
		if(operation ==='remove'){
			//객체. 
			formObj.attr("action", "/board/remove");
			//attr 속성. form의 action 속성의 값을 "/board/remove" 로 이동.
			
		}else if(operation === 'list'){
			//move to list
			//self.location ="/board/list";-> get방식 하이퍼이링크로 이동.
			//return;
			
			formObj.attr("action","/board/list").attr("method","get");
			//attr 속성. list 로 가기에  form 태그의 method 속성의 값을 get으로 수정.
			
			var pageNumTag =$("input[name='pageNum']").clone();
			var amountTag = $("input[name='amount']").clone();
			var keywordTag =$("input[name='keyword']").close();
			var typeTag=$("input[name='type']").close();
			
			formObj.empty();
			
			//객체값 var
			formObj.empty();// <form>태그의 모든 내용은 지운다. 자신만 남아있다. 속성2개만 남기고 list이동한다.
			formObj.append(pageNumTag);
			formObj.append(amountTag);
			formObj.append(keywordTag);
			formObj.append(typeTag); 
			
			
		}else if(operation === 'modify'){
			console.log("전송버튼 클릭");
			
			var str="";
			
			$(".uploadResult ul li").each(function(i, obj){
				
				var jobj =$(obj);
				console.dir(jobj);
				
				
				str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].uploadPath value='"+jobj.data("path")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].fileType value='"+jobj.data("type")+"'>";
			});// $(".uploadResult ul li").each() 끝
			
			formObj.append(str).submit(); //내용 추가한 다음에 추가하겠다.
			
			
		} //else-if문 끝
		
		formObj.submit();

	});//$('button').on("click")끝
});// $(document).ready(function(){})끝
</script>

<script>

$(document).ready(function(){
	(function(){
	
		var bno ='<c:out value="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
			console.log(arr);
			
			var str="";
			$(arr).each(function(i, attach){
				
				//이미지 타입 if문
				if(attach.fileType){
					var fileCallPath =encodeURIComponent(attach.uploadPath+ // 웹브라우저에서 URL로 인식
							"s_"+attach.uuid+"_"+attach.fileName);
					
					str+="<li date-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' ";
					str+="data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
					str+="<span>"+attach.fileName+</span>";
					str+="<button type='button' data-file=\'"+fileCallPath+"\' data-type='image'";
					str+="<class= 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str+="<img src='/display?fileName="fileCallPath+"'></div></li>";
					
				}else{
					
					str+="<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' ";
					str+="data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
					str+="<span>"+attach.fileName+"</span><br/>";
					str+="<button type='button' data-file=\'" +fileCallPath+"\' data-type='file'";
					str+="class='btn btn-warning' btn-circle'><i class='fa fa-times'></i></button><br>";
					str+="<img src='/resources/img/attach.png'></a></div></li>";
				
				} //if-else 끝
			
			});//$(arr).each(function(){}) 끝
			$(".uploadResult ul").html(str);
		});//$.getJSON() 끝
	
	})();//(function(){}) 즉시실행함수 끝
	
	$(".uploadResult").on("click", "button",function(e){
		
		console.log("첨부파일 삭제")ㅣ
		
		if(confirm("해당 파일을 삭제하시겠습니까?")){
			
			var targetLi =$(this).closest("li"); //this(button)와 가장 가까운  li를 말한다.
			targetLi.remove();
		}
		
	}); //$(.uploadResult).on() 함수끝
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$);
	var maxSize =5242880;
	
	function checkExtension(fileName, fileSize){
		
		if(fileSize >= maxSize){alert("파일사이즈 초과"); return false;}
		if(regex.text(fileName)){alert("해당종류파일은 업로드불가"); return false;}
		return true;
	}
	
	
	//게시물수정화면에서 첨부파일 추가.삭제시 csrf토큰처리를 위한 변수생성
	
	var csrfHeaderName ="${_csrf.headerName}"
	var csrfTokenValue ="${_csrf.token}"
	
	
	$("input[type='file']").change(function(e){
		
		var formData= new FormData();
		var inputFile =$("input[name='uploadFile']");
		var files =inputFile[0].files;
		
		for(var i=0; i<files.length; i++){
			
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url:'/uploadAjaxAction',
			processData:false,
			contentType:false,
			data:formData,
			type:'POST',
			
			//$.ajax에서 csrf 토큰처리를 위한 코드 추가
			beforeSend:function(xhr){		
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			
			dataType:'JSON',
			success: function(result){
				console.log(result);
				showUploadResult(result); //업로드처리결과함수
			}
			
		}); //$.ajax({}) 끝
		
	}); //$("input[type='file']")끝
	
	
	function showUploadResult(uploadResultArr){
		
		if(!uploadResultArr || uploadResultArr.length ==0){return;}
		
		var uploadUL =$(".uploadResult ul");
		var str="";
		
		$(uploadResultArr).each(function(i, obj){
			
			if(obj.image){
				
				var fileCallPath =encodeURIComponent(obj.uploadPath+"s_"+
						obj.uuid+"_"+obj.fileName);
				
				str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='" obj.fileName+"' data-type='"+obj.image+"'>";
				str+="<span>" +obj.fileName +"</span>";
				str+="<button type='button' data-file\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'>";
				str+="<i class='fa fa-times'></i></button><br>";
				str+="<img src='/display?fileName="+fileCallPath+"'></li>";
				
			}else{
				
				var fileCallPath =encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				var fileLink =fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str+="<li data-path='"+obj.uploadPath+"' data-uuid='" +obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
				str+="<span>"+obj.fileName+"</span>";
				str+="<button type='button' data-file=\'"+fileCallPath+"\ data-type='file' class='btn btn-warning btn-circle'>";
				str+="<i class='fa fa-times'></i></button><br>";
				str+="<img src='/resources/img/attach.png'></a></li>";
			}//else끝
		}) //$(uploadResultArr).each() 끝
		uploadUL.append(str);
	}//function showUploadResult() 끝
});//$(document).ready() 끝

</script>



<div class="panel-heading">Board Modify Page</div>
<!-- /.panel-heading -->
<div class="panel-body">

	<div class="form-group uploadDiv">
		<input type="file" name="uploadFile" multiple="multiple">
	</div> <!-- form-group uploadDiv 끝 -->

	<div class='uploadResult'>
		<ul>
		
		</ul>
	</div> <!-- uploadResult 끝 -->
</div>	<!--패널바디 끝 -->

<form role="form" action="/board/modify" method="post">

<input type='hidden' name="${_csrf.parameterName}" value="${_csrf.token} ">


<!-- 추가 -->
<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'>
<input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>
<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>


<div class="form-group">
	<label>Bno</label> <input class="form-control" name='bno' 
	value='<c:out value="${board.bno }"/>' readonly="readonly">
</div>

<div class="form-group">
	<label>Title</label> <input class="form-control" name='title'
	value='<c:out value="${board.title }"/>'>
</div>	

<div class="form-group">
	<label>Text area</label>
	<textarea class="form-control" rows="3" name='content'>
	<c:out value="${board.content }"/></textarea>
</div>	

<div class="form-group">
	<label>Writer</label> <input class="form-control" name='writer'
	value='<c:out value="${board.writer }"/>' readonly="readonly">
</div>

<div class="form-group">
	<label>RegDate</label> <input class="form-control" name='regDate'
	value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate}"/>'
	readonly="readonly">
</div>

<div class="form-group">
	<label>Update Date</label> <input class="form-control" name='updateDate'
	value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate }"/>'
	readonly="readonly">
</div>

<!-- 로그인한 사용자만 수정, 삭제버튼 가능 -->
<sec:authentication property="principal" var="pinfo"/>
<sec:authorize access="isAuthenticated()">
<c:if test="${pinfo.username eq board.writer} ">
<button type="submit" data-oper='modify' class="btn btn-default">수정하기</button>
<button type="submit" data-oper='remove' class="btn btn-danger">삭제하기</button>
</c:if>
</sec:authorize>
<button type="submit" data-oper='list' calss="btn btn-info">목록으로</button>
</form>


<div class='bigPictureWrapper'>
	<div class='bigPicture'>
	</div>
</div>


<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				첨부파일
			</div> <!-- 패널헤딩 끝 -->
			
			<div class="panel-body">
				<div class="uploadResult">
					<ul>
					</ul>
				</div>	<!-- uploadResult 끝 -->	
				
			</div><!-- 패널바디 끝 -->
		</div><!-- 패널디폴트 끝 -->
	</div><!-- col 끝 -->
</div>	<!-- row 끝 -->

<%@include file="../includes/footer.jsp" %>
