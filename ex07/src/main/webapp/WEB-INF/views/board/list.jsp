<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    
    
<%@include file="../includes/header.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	//제이쿼리 ->$ 알려주고 있다. 문법
	var result ='<c:out value="${result}"/>';
	//Controller 에서 값을 들고오는 $. addFlashAttribute 1번만 값을 전송하라. 
	checkModal(result);
	
	history.replaceState({},null,null);
	
	function checkModal(result){
		if(result===''|| history.state) return;
		
		if(parseInt(result) >0 ){
			$(".modal-body").html("게시글"+parseInt(result)+"번이 등록되었습니다.");
		}		
			$("#myModal").modal("show");
	}
	$("#regBtn").on("click", function(){
		self.location="/board/register";
	});
	
	var actionForm =$("#actionForm");
	$(".paginate_button a").on("click",function(e){
		e.preventDefault(); //보호해제
		console.log('click');//개발자도구에서 보이는  console 자바스크립트 블록안이라서
		actionForm.find("input[name='pageNum']")
		.val($(this).attr("href"));
	//val=value , a가 this 객체가 된다.
	});
	
	$(".paginate_button a").on("click",function(e){
		e.preventDefault();
		console.log('click');
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});//이 처리를 해줘야 페이지가 이동된다.
	
	$(".move").on("click", function(e){
		e.preventDefault();
		actionForm.append("<input type='hidden' name='bno' value='"+ $(this).attr("href")+"'>");
		//제목의 하이퍼링크 속성 클릭=this
		actionForm.attr("action","/board/get");
		actionForm.submit();
	});
	
});
</script>


		<div class="row">
           <div class="col-lg-12">
               <h1 class="page-header">Tables</h1>
           </div>
           <!-- /.col-lg-12 -->
		</div>

<!-- /.row -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                Board List Page
            <button id='regBtn' type="button" class="btn btn-xs pull-right">Register New Board</button>    
            </div>
            
            <!-- /.panel-heading -->
           <div class="panel-body">
               <table class="table table-striped table-bordered table-hover">
                   <thead>
                       <tr>
                           <th>#번호</th>
                           <th>제목</th>
                           <th>작성자</th>
                           <th>작성일</th>
                           <th>수정일</th>
                       </tr>
                   </thead>
                   
                   <tbody>
                   <c:forEach items="${list}" var="board">
                   <tr>
                   	   <%-- <td>${board.bno }</td>
	                   <td>${board.title }</td>
	                   <td>${board.writer }</td>
	                   <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate }"/></td>
	                   <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate }"/></td> --%>
                               
	                   	<td><c:out value="${board.bno}"/></td>
	                   	<%-- <td><a href='/board/get?bno=<c:out value="${board.bno}"/>'>
	                   	<c:out value="${board.title}"/></a></td> --%>

						<td><a class='move' href='<c:out value="${board.bno }"/>'>
						<c:out value="${board.title }   "/><b>[ <c:out value="${board.replyCnt}"/>]</b></a></td>
	                   	<td><c:out value="${board.writer}"/></td>
	                   	<td><fmt:formatDate pattern="yyyy-MM-dd"
	                   	value="${board.regdate}"/></td>
	                   	<td><fmt:formatDate pattern="yyyy-MM-dd"
	                   	value="${board.updateDate}"/></td>
                   	</tr>
                   	</c:forEach>
                   </tbody>   
               </table>
<!-- table태그 끝 -->     


<div class='row'>
	<div class="col-lg-12">
	
		<form id='searchForm' action="/board/list" method='get'>
			<select name='type'>
				<option value="">--</option>
					<option value="T">제목</option>
					<option value="C">내용</option>
					<option value="W">작성자</option>
					<option value="TC">제목 or 내용 </option>
					<option value="TW">제목 or 작성자 </option>
					<option value="TWC">제목 or 내용 or 작성자</option>
			</select>
			<input type='text' name='keyword'/>
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			<input type='hidden' name='amount' value='${pageMaker.cri.amount }'>
			<button class='btn btn-default'>Search</button>
		</form>
	</div>
</div>

<!-- 페이지처리 table 처리끝나는 직후에 코드작성-->
<div class='pull-right'>
	<ul class="pagination">
		<c:if test="${pageMaker.prev}">
			<li class="paginate_button previous"><a href="${pageMaker.startPage-1} ">Previous</a></li>
		</c:if>
		
		<c:forEach var="num" begin="${pageMaker.startPage}"
		end="${pageMaker.endPage}">
			<li class="paginate_button ${pageMaker.cri.pageNum==num ? "active": ""} "><a href="${num}"> ${num} </a></li>
			
			<!--  -->
			<!-- active 현재페이지를 알려주기 위해 파란색 표시 -->
		</c:forEach>
		
		<c:if test="${pageMaker.next }">
			<li class="paginate_button next"><a href="${pageMaker.endPage+1}" >Next</a></li>
		</c:if>
	</ul>
</div>

<!-- Pagination 끝 -->
</div>			
	
<form id='actionForm' action="/board/list" method='get'>	
	<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum} '>	
    <input type='hidden' name='amount' value='${pageMaker.cri.amount }'>
    <input type='hidden' name='type' value='<c:out value="${pageMaker.cri.type} "/>'>
    <input type='hidden' name='keyword' value='<c:out value="${pageMaker.cri.keyword }"/>'>
</form>      
               
<!-- Modal 추가 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
				aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Modal title</h4>
			</div>
			<div class="modal-body">처리가 완료되었습니다.</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary">Save changes</button>
			</div>			
		</div>
	<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal --> 

              
           </div>
           <!-- /.panel-body -->
       </div>
       <!-- /.panel -->
   </div>
   <!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<%@include file="../includes/footer.jsp" %>

