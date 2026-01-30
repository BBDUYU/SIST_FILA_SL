<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 확인</title>
</head>
<body>

<h2>✅ 로그인 상태 확인</h2>

<p>
    사용자 번호 : ${loginUser.userNumber}<br>
    아이디 : ${loginUser.id}<br>
    이름 : ${loginUser.name}<br>
</p>

<hr>

<a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>

</body>
</html>
