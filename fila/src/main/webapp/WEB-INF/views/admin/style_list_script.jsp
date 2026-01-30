<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function toggleStatus(id, currentStatus) {
    const nextStatus = (currentStatus === 1) ? 0 : 1;
    const msg = nextStatus === 1 ? "해당 스타일을 활성화하시겠습니까?" : "해당 스타일을 비활성화하시겠습니까?";

    if (confirm(msg)) {
        $.ajax({
            // 매핑한 .htm 주소와 일치해야 합니다.
            url: "${pageContext.request.contextPath}/admin/toggleStyle.htm",
            type: "GET",
            data: { 
                id: id, 
                status: nextStatus 
            },
            success: function(res) {
                if (res.trim() === "success") {
                    location.reload(); // 상태 반영을 위해 페이지 새로고침
                } else {
                    alert("상태 변경 처리에 실패했습니다.");
                }
            },
            error: function() {
                alert("서버 통신 오류가 발생했습니다.");
            }
        });
    }
}
</script>