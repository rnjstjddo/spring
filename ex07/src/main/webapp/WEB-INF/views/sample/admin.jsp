<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>/sample/admin page</h1>

<p>principal :<sec:authentication property="principal"/></p> <!-- principal은 CustomUser 의미한다. -->
<p>MemberVO : <sec:authentication property="principal.member"/></p> <!-- principal.member는 CustomUser 객체의 getMember() 호출한다. -->
<p>사용자이름 :<sec:authentication property="principal.member.userName"/></p>
<p>사용자아이디 :<sec:authentication property="principal.username"/></p>
<p>사용자 권한리스트:<sec:authentication property="principal.member.authList"/></p>






<a href="/customLogout">Logout</a>
</body>
</html>
