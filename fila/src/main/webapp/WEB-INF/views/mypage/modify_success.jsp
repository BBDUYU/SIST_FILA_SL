<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
    alert("정상적으로 수정되었습니다.");
    // 다시 수정 페이지(.htm)로 이동시켜서 최신 데이터를 보여줍니다.
    location.href = "${pageContext.request.contextPath}/mypage/modifyInfo.htm";
</script>