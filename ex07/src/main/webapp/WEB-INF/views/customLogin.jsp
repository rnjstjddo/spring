<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
	
	
	 <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->


	
</head>
<body>
<h1>Custom Login Page</h1>

<h2>${error }</h2>
<h2>${logout }</h2>

<form role="form" action="/login" method="post">
	<fiedlset>
		<div class="form-group">
			<input class="form-control" placeholder="userid" type="text" name="username" autofocus>
		</div>
		
		<div class="form-group">
			<input class="form-control" placeholder="Password" type="password" name="password" value="">
		</div>
		
		<div class="checkbox">
			<label><input type="checkbox" name="remember-me" >Remember Me</label>
		</div>
		
		<a href="index.html" class="btn btn-lg btn-success btn-block">로그인</a>
		
	</fiedlset>
	
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
</form>

   <!-- jQuery -->
    <script src="/resources/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/resources/dist/js/sb-admin-2.js"></script>


<script>
	$(".btn-success").on("click",function(e){
		e.preventDefault();
		$("form").submit();
	});

</script>

</body>
</html>
