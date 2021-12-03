<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    
    
<%@include file="../includes/header.jsp" %>


<div class="row">
	<div class="col-lg-12">
			<h1 class="page-header">Board Register</h1>
	</div>
	
	<!-- /.col-lg-12 -->	
</div>

<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Register</div>
			
			<!-- /.panel-heading -->
			<div class="panel-body">
	
				<form role="form" action="/board/register" method="post">
				
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }"/>
				
					<div class="form-group">
						<label>Title</label> <input class="form-control" name='title'>
					</div>
					
					<div class="form-group">
						<label>Text area</label>
						<textarea class="form-control" row="3" name='content'></textarea>	
					</div>
					
					<div class="form-group">
						<label>Writer</label> <input class="form-control" name='writer'
						value='<sec:authentication property="principal.username"/>' readonly="readonly">
					</div>
					
					<button type="submit" class="btn btn-default">Submit Button</button>
					<button type="reset" class="btn btn-default">Reset Button</button>
				</form>
			</div>			
	
		<!--end penel-body  -->
		</div>
	<!-- end penel-body -->
	</div>
	<!-- end panel  -->
</div>
<!-- row -->
	
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			
			<div class="panel-heading">첨부파일</div>
			
				<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type="file" name="uploadFile" multiple>
					</div>
					
					<div class="uploadResult">
						<ul>
						</ul>
					</div>
				</div> <!-- 패널바디끝 -->
			<div>	<!-- 패널헤딩끝 -->
		</div><!-- 	패널디폴트끝 -->
	</div> <!-- col끝 -->
</div>	<!-- row끝 -->

<!-- 등록을 위한 화면처리 -->
	
<!-- <div class="row">	
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				파일첨부
			</div>
			
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFfile" multiple>
				</div>
			
				<div class="uploadResult">
					<ul>
					</ul>			
				</div>
				
			</div> 패널바디 끝	
		</div>패널디폴트 끝
	</div>col끝
</div> row 끝		 -->


<script>
$(document).ready(function(e){
	
	var formObj =$("form[role='form']");
	
	$("button[type='submit']").on("click", function(e){
		alert("확인");
		e.preventDefault();
		console.log("게시글 등록버튼 클릭");
		
		var str="";
		$(".uploadResult ul li").each(function(i ,obj){
			
			var jobj =$(obj);
			
			console.dir(jobj);
			str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";			
			str+="<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
			//BoardVO 에 자동대입 private BoardAttach
		}); //$(".uploadResult ul li").each 끝
		
		
		
		formObj.append(str).submit();
		console.log(str);
	});//$("button[type='submit']").on() 끝



	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; //5메가바이트
	
	function checkExtension(fileName, fileSize){
		
		if(fileSize >= maxSize){
			alert("파일사이즈 초과");
			return false;
		}
		if(regex.test(fileName)){
			alert("해당종류파일 업로드불가");
			return false;
		}
		return true;
		
	}//checkExtension()함수 끝
	
	
	//스프링 시큐리티 적용후 게시물이 파일첨부가 등록이 안될수있다. 토큰 추가.
	var csrfHeaderName ="${_csrf.headerName}"
	var csrfTokenValue ="${_csrf.token}"
	
	$("input[type='file']").change(function(e){
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files =inputFile[0].files;
		
		console.log(files); //서버전송전
		console.log("서버전송전 파일");
		
		for(var i=0; i<files.length; i++){
			
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		
		
		$.ajax({
			url:'/uploadAjaxAction',
			processData: false,
			contentType:false,
			//토큰설정 ajax 추가
			beforeSend :function(xhr){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			
			data:formData,
			type:'POST',
			dataType:'json',
			success:function(result){
				console.log(result); //서버전송후
				showUploadResult(result);//업로드결과처리함수
				
			} 
		}); //$.Ajax 끝
		
	});//$("input[type='file']").change 끝



	function showUploadResult(uploadResultArr){
		//Ajax 호출후에 업로드된 결과를 처리하는 함수.
		if(!uploadResultArr || uploadResultArr.length ==0){
			return;
		}
		var uploadUL =$(".uploadResult ul");
		var str="";
		
		$(uploadResultArr).each(function(i, obj){
			//List 에서 객체꺼낸다. i는 0부터시작해서 번호를 붙인다.
			if(obj.image){
				var fileCallPath =encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				
				//str+="<li><div>";
				str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
				str+="	<span>"+obj.fileName+"</span>";
				str+="	<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'>";
				str+="	<i class='fa fa-times'></i></button><br>";
				str+="	<img src='/display?fileName="+fileCallPath+"'>";
				//display 요청한 이유는 파일이름 알려줄테니 썸네일 보여달라
				str+="</li>";
				
			}else{
				var fileCallPath =encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				//str+="<li><div>"
				str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
				str+="	<span>"+obj.fileName+"</span>";
				str+="	<button type='button' data-file=\'"+fileCallPath+"\ data-type='file' class='btn btn-warning btn-circle'>";
				str+="	<i class='fa fa-times'></i></button><br>";
				str+="	<img src='/resources/img/attach.png'></a>";
				str+="</li>";
		
				}//else문 끝
		});//$(uploadResultArr).each() 끝
					
		uploadUL.append(str);
	}//function showUploadResult() 끝
	
		
	$(".uploadResult").on("click", "button", function(e){
		
		console.log("파일삭제");
		
	
		var targetFile =$(this).data("file"); //button -> this
		var type=$(this).data("type");
		var targetLi =$(this).closest("li"); //현재 나와가까운 li 의미한다. <li data-path> 데이터정보들이 들어가있다.
		
		$.ajax({
			url:'/deleteFile',
			data:{fileName:targetFile, type:type},
			
			
			//토큰처리
			beforeSend:function(xhr){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},	
			
			dataType:'text',
			type:'post',
			success:function(result){
				
				alert(result);
				targetLi.remove(); //해당 li정보를 삭제하겠다.
			}
		});//$.ajax끝
	}); //$(".uploadResult").on() 끝
	
});//$(document).ready()끝
	
</script>

<%@include file="../includes/footer.jsp" %>
