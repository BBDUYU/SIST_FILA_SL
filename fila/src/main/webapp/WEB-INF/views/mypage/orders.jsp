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

<section class="my-con" style="user-select: auto !important;">
           			<h2 class="tit__style4" style="user-select: auto !important;">주문 · 배송 조회</h2>
					<!--p class="" style="color: rgb(204, 0, 0); font-size: 16px; font-weight: 400; line-height: 26px;">
						※ 당사 물류 사정에 의해 12/23(토) 이후 반품 신청건에 대해서는 1/2(화)부터 순차 처리될 예정이오니 교환/반품 시 참고 부탁드립니다.
					</p--><!--2023-12-22 문구 추가-->
					<div class="my-sort-wrap" style="user-select: auto !important;">
					<form method="post" action="myOrder.asp" name="serchOrderForm" style="user-select: auto !important;">
					<input type="hidden" name="Smode" value="ok" style="user-select: auto !important;">
						<div class="my-sort-box" style="user-select: auto !important;">
							<p class="total" style="user-select: auto !important;">총 ${totalCount}건</p>
							<div class="period" style="user-select: auto !important;">
								<!--a href="javascript:searchDate('2026-01-07', '0');serchOrderForm.submit();"  >오늘</a-->
								<a href="javascript:searchDate('2025-12-31', '7');serchOrderForm.submit();" style="user-select: auto !important;">1주일</a>
								<a href="javascript:searchDate('2025-12-08', '30');serchOrderForm.submit();" class="on" style="user-select: auto !important;">1개월</a>
								<a href="javascript:searchDate('2025-10-09', '90');serchOrderForm.submit();" style="user-select: auto !important;">3개월</a>
								<a href="javascript:searchDate('2025-07-11', '180');serchOrderForm.submit();" style="user-select: auto !important;">6개월</a>
								<a href="javascript:searchDate('2025-01-07', '365');serchOrderForm.submit();" style="user-select: auto !important;">1년</a>
								<!--a href="" class="self-write">직접입력</a-->
								<input type="hidden" id="dateFrom" name="dateFrom" class="input" value="2025-12-08" readonly="" style="user-select: auto !important;">
								<input type="hidden" id="dateTo" name="dateTo" class="input" value="2026-01-07" readonly="" style="user-select: auto !important;"> 
								<input type="hidden" name="nowDate" id="nowDate" value="2026-01-07" style="user-select: auto !important;">
								<input type="hidden" name="oStatus" id="oStatus" value="" style="user-select: auto !important;">
							</div>
						</div>
						<!-- 직접입력 선택 시 오픈 -->
						<div class="date-write-box" style="user-select: auto !important;">
							<input type="text" name="keyword" placeholder="날짜 입력 후 조회 혹은 주문번호 입력 후 조회" style="user-select: auto !important;">
							<input type="hidden" name="category" value="4" style="user-select: auto !important;">
							<button type="submit" style="user-select: auto !important;">조회</button>
						</div>
						<!-- //직접입력 선택 시 오픈 -->
					</form>
					</div>

					<%-- (상단 헤더 및 CSS 생략) --%>

<div class="my-odr-wrap">
    <c:choose>
        <c:when test="${not empty orderList}">
            <table class="tbl-list" style="width:100%; border-top:2px solid #000;">
                <colgroup>
                    <col style="width:180px">
                    <col style="width:auto">
                    <col style="width:120px">
                    <col style="width:150px"> <%-- 비고란 폭을 조금 넓힘 --%>
                </colgroup>
                <thead>
                    <tr style="height:50px; background:#f9f9f9; border-bottom:1px solid #ddd;">
                        <th>주문일자/번호</th>
                        <th>결제금액</th>
                        <th>주문상태</th>
                        <th>비고</th>
                    </tr>
                </thead>
                <tbody>
    <c:forEach var="dto" items="${orderList}">
        <%-- 💡 DAO에서 이미 걸러왔으므로 여기서 <c:if>로 또 거를 필요가 없습니다. --%>
        <tr style="text-align:center; border-bottom:1px solid #eee;">
            <td style="padding:15px 0;">
                <fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd"/><br>
                <a href="javascript:void(0);" onclick="toggleUserOrderDetail('${dto.orderId}')" 
                   style="font-weight:bold; color:#00205b; text-decoration:underline;">
                    ${dto.orderId}
                </a>
            </td>
            <td>
                <strong style="color:#000;">
                    <fmt:formatNumber value="${dto.totalAmount}" pattern="#,###" />원
                </strong>
            </td>
            <td>
                <span class="status-badge">${dto.orderStatus}</span>
            </td>
            <td>
                <c:choose>
                    <%-- 1. 결제완료: 즉시 취소 가능 --%>
                    <c:when test="${dto.orderStatus eq '결제완료'}">
                        <button type="button" class="btn-small" onclick="processOrderCancel('${dto.orderId}', '취소완료')">주문취소</button>
                    </c:when>
                    
                    <%-- 2. 준비 중: 취소 요청 (관리자 승인 필요) --%>
                    <c:when test="${dto.orderStatus eq '상품준비중' or dto.orderStatus eq '배송준비중'}">
                        <button type="button" class="btn-small btn-grey" onclick="processOrderCancel('${dto.orderId}', '취소요청')">취소요청</button>
                    </c:when>
                    
                    <%-- 3. 배송중/배송완료 --%>
                    <c:otherwise>
                        <span style="font-size: 11px; color:#00205b; font-weight:bold;">배송진행중</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        
        <%-- 상세 내역 (이 부분은 유지) --%>
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
            <p class="odr-txt_none" style="text-align:center; padding:50px 0;">최근 주문 내역이 없습니다.</p>
        </c:otherwise>
    </c:choose>
</div>

<%-- (하단 스크립트 생략) --%>
					
					<!-- 교환 취소 반품 안내 -->
					<div class="myorder-return-box" style="user-select: auto !important;">
						<h3 class="tit__style2" style="user-select: auto !important;">교환 · 취소 · 반품 안내</h3>
						<div style="user-select: auto !important;">
							<p class="tit" style="user-select: auto !important;">취소접수</p>
							<p class="txt" style="user-select: auto !important;">
								<span style="user-select: auto !important;">결제완료 중 단계에 있는 경우</span>
								해당 상품의 [주문취소] 버튼을 누르시면 바로 취소하실 수 있습니다.
								<br style="user-select: auto !important;"><br style="user-select: auto !important;">
								<span style="user-select: auto !important;">상품준비중, 배송 준비 중 단계에 있는 경우</span>
								[주문취소 접수]버튼을 누르시면, 주문취소접수가 되며, 고객센터에서 확인 후 주문취소 됩니다. <br style="user-select: auto !important;">
								(24시간 내에 처리, 공휴일제외)
								<br style="user-select: auto !important;"><br style="user-select: auto !important;">
								<span style="user-select: auto !important;">배송 중 단계에 있는 경우</span>
								주문취소가 되지 않으며, 배송이 완료 된 시점에서 7일 이내에 주문취소를 하셔야 됩니다.
							</p>
						</div>
						<div style="user-select: auto !important;">
							<p class="tit" style="user-select: auto !important;">반품처리</p>
							<ul class="txt" style="user-select: auto !important;">
								<li style="user-select: auto !important;">반품 접수 후 상품을 보내주셔야 합니다.</li>
								<li style="user-select: auto !important;">단순변심으로 인한 반품 택배비는 고객님께서 부담하셔야 합니다.</li>
								<li style="user-select: auto !important;">상품의 하자 및 오배송인 경우 택배비는 휠라코리아에서 부담하며, 고객센터로 접수 후 절차 안내를 받으시면 됩니다.</li>
								<li style="user-select: auto !important;">반품주소지 : 경기도 부천시 송내대로 30번길 13 CJ 대한통운 부천지점</li>
							</ul>
						</div>
						<div style="user-select: auto !important;">
							<p class="tit" style="user-select: auto !important;">취소완료</p>
							<ul class="txt" style="user-select: auto !important;">
								<li style="user-select: auto !important;">반품 완료가 되면 결제하셨던 수단에 따라 각기 다른 방식으로 처리됩니다.</li>
								<li style="user-select: auto !important;">카드결제는 승인취소가 되며, 일반적으로 카드사에서는 승인취소일로부터 4~5일(영업일 기준) 이후에 취소 확인이 가능합니다.</li>
								<li style="user-select: auto !important;">현금(무통장/실시간 계좌이체(에스크로 포함) 등) 결제건은 반품이 완료되면, 반품완료일로부터 영업일 기준 3일 내에 결제금액을 환불해 드립니다.</li>
							</ul>
						</div>
					</div>
				</section>

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
                    	const productName = item.productName || "상품명 없음";
                        const size = (item.size && item.size !== "") ? item.size : "기본"; // 빈 문자열 처리
                        const quantity = item.quantity || 0;
                        const price = item.price || 0; // 현재 0으로 들어옴
                        html += `<tr style="border-bottom:1px solid #eee; text-align:center;">
                            <td style="padding:10px; text-align:left;">\${productName}</td>
                            <td>\${size}</td>
                            <td>\${quantity}</td>
                            <td style="font-weight:bold;">
                                \${price > 0 ? Number(price).toLocaleString() + '원' : '가격 정보 없음'}
                            </td>
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
