<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function deleteNotice() {
    if(confirm("이 공지사항을 정말로 삭제하시겠습니까?")) {
        // 경로에 공지사항 ID(id)가 포함되어야 핸들러가 인식합니다.
        location.href = "${pageContext.request.contextPath}/admin/noticeDelete.htm?id=${dto.notice_id}";
    }
}
</script>