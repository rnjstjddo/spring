<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
.uploadResult{width:100%; background-color:gray;}
.uploadResult ul{display:flex; flex-flow:row; justify-content:center; align-items:center;} 
.uploadResult ul li {list-style:none; padding:10px;}
.uploadResult ul li img{width:100px;}

.uploadResult ul li span{color:white;}
.bigPictureWrapper{
position:absolute; display:none; justify-content:center; align-items:center; top:0%;
width:100%; heigth:100%; background-color:gray; z-index:100; background:rgba(255,255,255,0.5);
}
.bigPicture{
position:relative; display:flex; justify-content:center; align-items:center;
}
.bigPicture img{width:600px;}

</style>


</head>
<body>

<h2>파일업로드 with Ajax<h2>
<div class="uploadDiv">
	<input type="file" name="uploadFile" multiple>
</div>

<div class="uploadResult">
	<ul>
	</ul>
</div>	


<div class='bigPictureWrapper'>
	<div class='bigPicture'></div>
</div>


<button id="uploadBtn">업로드</button>


<script
  src="https://code.jquery.com/jquery-3.6.0.js"
  integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
  crossorigin="anonymous">
</script>

<script>

function showImage(fileCallPath){
	//alert(fileCallPath);
	
	$(".bigPictureWrapper").css("display","flex").show();
	
	$(".bigPicture")
	.html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>")
	.animate({width:'100%',height:'100%'},1000);
}
$(".bigPictureWrapper").on("click",function(e){
	$(".bigPicture").animate({width:'0%',height:'0%'},1000);
	setTimeout(function(){
		$('.bigPictureWrapper').hide();
	},1000);
});

$(document).ready(function(){
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|zlx)$"); //$끝나는 확장자를 말한다.
	var maxSize =5242880; //50MB
	
	function checkExtension(fileName, fileSize){
		
		if(fileSize >= maxSize){
			alert("파일사이즈초과");
			return false;
		}
		
		if(regex.test(fileName)){
			alert("해당종류파일 업로드 불가");
			return false;
		}
		return true;
	}
	
	var cloneObj=$(".uploadDiv").clone();
	//복사해서 객체를 cloneObj 담는다.
	
	$("#uploadBtn").on("click",function(e){
		var formData=new FormData();
		var inputFile=$("input[name='uploadFile']");
		var files=inputFile[0].files;
		
		console.log(files);
		
		for(var i=0;i<files.length;i++){
			
			if(!checkExtension(files[i].name,files[i].size)){
				return false;
			}
			formData.append("uploadFile",files[i]); 
		}// 키와 값형태. form 태그 name 값아야한다.
		
		$.ajax({
			url:'/uploadAjaxAction',
			processData:false,
			contentType:false,
			data:formData,
			type:'POST',
			dataType:"json", //추가된 부분. 브라우저로 결과데이터 전송시.
			success:function(result){ //success 값이 넘어오지 않는다. 응답response 해당하기에. jsp파일 안만듬.
				//alert("업로드 성공");
				console.log(result);
				
				showUploadedFile(result);
				
				$(".uploadDiv").html(cloneObj.html());
			}
		});//ajax끝
	});//uploadBtn 끝
	
	
	
	
	var uploadResult=$(".uploadResult ul");
	
	function showUploadedFile(uploadResultArr){
		var str="";
		
		$(uploadResultArr).each(function(i,obj){
			
			if(!obj.image){
				var fileCallPath=encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				str+="<li><div><a href='/download?fileName="+fileCallPath+"'>"+
						"<img src='resources/img/attach.png'>"+obj.fileName+"</a>"
						"<span data-file=\'"+fileCallPath+"\' data-type='file'>x</span>"+
						"</div></li>";
			}else{			
				var fileCallPath=encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				
				var originPath=obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName;
				
				originPath=originPath.replace(new RegExp(/\\/g),"/");
				
				str+="<li><a href=\"javascript:showImage(\'"+
						originPath+"\')\"><img src='/display?fileName="+
						fileCallPath+"'></a>"+
						"<span data-file=\'"+fileCallPath+"\' data-type='image'>x</sapn>"+"</li>";
			}
		});
		
		uploadResult.append(str);
	}
	
	$(".uploadResult").on("click","span",function(e){
		
		var targetFile =$(this).data("file");
		var type=$(this).data("type");
		console.log(targetFile);
		
		$.ajax({
			url:'/deleteFile',
			data: {fileName:targetFile, type:type},
			dataType:'text',
			type:'POST',
			succcess:function(result){
				alert(result);
			}
		}); // $.ajax 끝
	}); //.uploadResult 자바스크립트
});

	
</script>

</body>
</html>





