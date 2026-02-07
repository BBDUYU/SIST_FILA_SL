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
            // 🚩 아까 MyOrderListController에 만든 그 상세 주소
            url: "${pageContext.request.contextPath}/mypage/orderDetail.htm", 
            data: { orderId: orderId },
            type: "GET",
            // 🚩 dataType: "json" 삭제! (이게 406 에러의 주범입니다)
            success: function(res) {
                // 서버가 보내준 <table> 조각을 그대로 삽입
                contentBox.html(res); 
                detailRow.show();
            },
            error: function(xhr) {
                alert("정보를 불러오지 못했습니다. (코드: " + xhr.status + ")");
            }
        });
    }
}

function processOrderCancel(orderId, targetStatus) {
    let confirmMsg = "";
    if (targetStatus === '취소완료') confirmMsg = "즉시 취소가 가능합니다. 정말 취소하시겠습니까?";
    else if (targetStatus === '취소요청') confirmMsg = "취소 요청을 하시겠습니까?";
    else if (targetStatus === '반품요청') confirmMsg = "반품 요청을 하시겠습니까?";

    if (confirm(confirmMsg)) {
        $.ajax({
            // 🚩 관리자든 사용자든 공용으로 쓰는 업데이트 주소 확인
            url: "${pageContext.request.contextPath}/admin/orderUpdate.htm",
            type: "POST",
            data: { orderId: orderId, status: targetStatus },
            // 🚩 성공 시 "SUCCESS_OK" 같은 텍스트를 받으므로 dataType 제거
            success: function(res) {
                if (res.trim() === "SUCCESS_OK") {
                    alert(targetStatus + " 처리가 완료되었습니다.");
                    location.reload();
                } else {
                    alert("처리 중 오류가 발생했습니다.");
                }
            }
        });
    }
}
</script>