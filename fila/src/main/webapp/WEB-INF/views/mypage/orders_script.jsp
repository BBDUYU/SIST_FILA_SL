<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
function toggleUserOrderDetail(orderId) {
    const detailRow = $('#detail_' + orderId);
    const contentBox = $('#content_' + orderId);

    if (detailRow.is(':visible')) {
        detailRow.hide();
    } else {
        $.ajax({
            // 🚩 경로를 /mypage/orderDetail.htm 으로 변경!
            url: "${pageContext.request.contextPath}/mypage/orderDetail.htm",
            data: { orderId: orderId },
            type: "GET",
            // 🚩 dataType: "json" 은 삭제 (HTML 문자열을 받을 것이므로)
            success: function(res) {
                contentBox.html(res); // 서버에서 보낸 <table> 태그를 그대로 삽입
                detailRow.show();
            },
            error: function(xhr) {
                alert("상세 내역을 불러오지 못했습니다. (에러코드: " + xhr.status + ")");
            }
        });
    }
}

function processOrderCancel(orderId, targetStatus) {
    let confirmMsg = "";
    if (targetStatus === '취소완료') confirmMsg = "즉시 취소가 가능합니다. 정말 취소하시겠습니까?";
    else if (targetStatus === '취소요청') confirmMsg = "취소 요청을 하시겠습니까? 관리자 확인 후 처리됩니다.";
    else if (targetStatus === '반품요청') confirmMsg = "반품 요청을 하시겠습니까?";

    if (confirm(confirmMsg)) {
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/orderUpdate.htm",
            type: "POST",
            data: { 
                orderId: orderId, 
                status: targetStatus 
            },
            // 🚩 dataType: "json" 은 절대 쓰지 않습니다.
            success: function(res) {
                // 서버에서 리턴한 "SUCCESS_OK" 텍스트와 비교
                if (res.trim() === "SUCCESS_OK") {
                    alert("[" + targetStatus + "] 처리가 완료되었습니다.");
                    location.reload(); // 세션이 갱신되었으므로 새로고침 시 상단 숫자도 변경됨
                } else {
                    alert("처리 중 오류가 발생했습니다.");
                }
            },
            error: function(xhr) {
                alert("서버 통신 에러 (상태코드: " + xhr.status + ")");
            }
        });
    }
}
</script>