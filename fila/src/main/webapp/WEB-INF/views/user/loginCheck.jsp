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
    사용자 번호 : ${auth.userNumber}<br>
    아이디 : ${auth.id}<br>
    이름 : ${auth.name}<br>
</p>

<hr>

<a href="${pageContext.request.contextPath}/member/logout.do">로그아웃</a>

</body>
</html>
