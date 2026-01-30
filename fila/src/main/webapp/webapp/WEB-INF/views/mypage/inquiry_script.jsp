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
            url: "${pageContext.request.contextPath}/admin/orderDetail.htm", // 기존 핸들러 재사용
            data: { orderId: orderId },
            dataType: "json",
            success: function(items) {
                if(items.length === 0) {
                    contentBox.html('<p style="padding:10px;">상세 내역이 없습니다.</p>');
                } else {
                    let html = '<div style="margin-bottom:10px; font-weight:bold; color:#00205b;">[주문 상품 상세 정보]</div>';
                    html += '<table style="width:100%; border-collapse:collapse; background:#fff; border:1px solid #eee;">';
                    html += '<tr style="background:#f4f4f4;"><th style="padding:8px;">상품명</th><th>옵션</th><th>수량</th><th>단가</th></tr>';
                    
                    items.forEach(item => {
                        const price = item.price || item.Price || 0;
                        html += `<tr style="border-bottom:1px solid #eee; text-align:center;">
                            <td style="padding:10px; text-align:left;">\${item.productName}</td>
                            <td>\${item.size}</td>
                            <td>\${item.quantity}</td>
                            <td style="font-weight:bold;">\${Number(price).toLocaleString()}원</td>
                        </tr>`;
                    });
                    html += '</table>';
                    contentBox.html(html);
                }
                detailRow.show();
            },
            error: function() {
                alert("주문 정보를 불러오지 못했습니다.");
            }
        });
    }
}

function processOrderCancel(orderId, targetStatus) {
    let confirmMsg = "";
    
    if (targetStatus === '취소완료') {
        confirmMsg = "즉시 취소가 가능합니다. 정말 취소하시겠습니까?";
    } else if (targetStatus === '취소요청') {
        confirmMsg = "취소 요청을 하시겠습니까? 관리자 확인 후 처리됩니다.";
    } else if (targetStatus === '반품요청') {
        confirmMsg = "반품 요청을 하시겠습니까? 고객센터에서 절차를 안내해 드릴 예정입니다.";
    }

    if (confirm(confirmMsg)) {
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/updateOrder.htm",
            type: "POST",
            data: { orderId: orderId, status: targetStatus },
            dataType: "json",
            success: function(res) {
                if (res.status === "success") {
                    alert(targetStatus + " 처리가 정상적으로 완료되었습니다.");
                    location.reload();
                } else {
                    alert("처리 실패: " + res.message);
                }
            }
        });
    }
}
</script>