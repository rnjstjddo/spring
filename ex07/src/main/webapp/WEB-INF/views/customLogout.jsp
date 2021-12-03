<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>Logout Page</h1>

<div class="col-md-4 col-md-offset-4">
	<div class="login-panel panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">Logout Page</h3>s
		</div>
		<div class="panel-body">

			<form action="/customLogout" method="post">	
				<fieldset>
							<!-- 아래로 변경 <button>로그아웃</button> -->
					<a href="index.html" class="btn btn-lg btn-success btn-block">로그아웃</a>
				</fieldset>
				
			
				<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
				
			</form>
		</div>
	</div>
</div>	
</body>
</html>
<script>
	$(".btn-success").on("click", function(e){
		
		e.preventDefault();
		$("form").submit();
	});//$(".btn-success")끝
</script>

<c:if test="${param.logout !=null} ">
	<script>
		$(document).ready(function(){
			alert("로그아웃");	
		});
	</script>
</c:if>
