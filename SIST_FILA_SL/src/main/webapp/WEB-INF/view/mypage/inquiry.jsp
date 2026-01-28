<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>1:1 문의 | FILA</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/normalize.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/opt-default.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sub.css">

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>

    <!-- 🔥 모달 강제 표시용 보정 CSS -->
    <style>
    .tbl-list th { font-size: 14px; color: #666; font-weight: 500; }
    .status-badge { 
        display: inline-block; 
        padding: 4px 8px; 
        background: #00205b; 
        color: #fff; 
        font-size: 12px; 
        border-radius: 2px; 
    }
    .btn-small {
        padding: 5px 10px;
        border: 1px solid #ddd;
        background: #fff;
        cursor: pointer;
        font-size: 12px;
    }
    .btn-small:hover { background: #f4f4f4; }
</style>
</head>

<body>

<jsp:include page="/view/common/header.jsp"/>
<jsp:include page="/view/mypage/mypage.jsp"/>

<%-- 상단 생략 --%>
<section class="my-con">
    <%-- 1. 제목 수정 --%>
    <h2 class="tit__style4">교환 · 취소 · 반품 조회</h2>

    <div class="my-sort-wrap">
        <%-- 2. action 주소를 취소 조회 핸들러 주소로 변경 (예: cancelList.htm) --%>
        <form method="post" action="cancelList.htm" name="serchOrderForm">
            <div class="my-sort-box">
                <p class="total">총 ${totalCount}건</p>
                <div class="period">
                    <%-- 날짜 클릭 시 검색 로직 (기존 유지하되 필요시 .asp -> .htm 변경) --%>
                    <a href="javascript:void(0);" onclick="searchDate('7')" >1주일</a>
                    <a href="javascript:void(0);" onclick="searchDate('30')" class="on">1개월</a>
                    <a href="javascript:void(0);" onclick="searchDate('90')">3개월</a>
                </div>
            </div>
        </form>
    </div>

    <div class="my-odr-wrap">
        <c:choose>
            <c:when test="${not empty orderList}">
                <table class="tbl-list" style="width:100%; border-top:2px solid #000;">
                    <colgroup>
                        <col style="width:180px">
                        <col style="width:auto">
                        <col style="width:150px">
                        <col style="width:120px">
                    </colgroup>
                    <thead>
                        <tr style="height:50px; background:#f9f9f9; border-bottom:1px solid #ddd;">
                            <th>신청일자/주문번호</th>
                            <th>결제금액</th>
                            <th>처리상태</th>
                            <th>상세내역</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="dto" items="${orderList}">
                            <tr style="text-align:center; border-bottom:1px solid #eee;">
                                <td style="padding:15px 0;">
                                    <fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd"/><br>
                                    <span style="font-size: 12px; color: #666;">${dto.orderId}</span>
                                </td>
                                <td>
                                    <strong><fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />원</strong>
                                </td>
                                <td>
                                    <%-- 취소/반품용 붉은색 배지 --%>
                                    <span class="status-badge" style="background:#d9534f;">${dto.orderStatus}</span>
                                </td>
                                <td>
                                    <button type="button" class="btn-small" onclick="toggleUserOrderDetail('${dto.orderId}')">
                                        상세보기
                                    </button>
                                </td>
                            </tr>
                            <tr id="detail_${dto.orderId}" style="display:none; background:#fcfcfc;">
                                <td colspan="4" id="content_${dto.orderId}" style="padding:20px; border:1px solid #ddd;">
                                    <div class="loading">데이터를 불러오는 중...</div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p class="odr-txt_none" style="text-align:center; padding:50px 0;">최근 교환/취소/반품 내역이 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
</section>
<%-- 하단 안내 및 JS는 기존과 동일 --%>

</div>
</div>
<jsp:include page="/view/common/footer.jsp"/>

<!-- ===================== -->
<!-- 🔥 JS : 이것만 있으면 무조건 뜸 -->
<!-- ===================== -->
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

</body>
</html>
