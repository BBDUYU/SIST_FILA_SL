<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>FILA ADMIN - 회원 상세 정보</title>
<style>
:root {
	--fila-navy: #001E62;
	--fila-red: #E2001A;
	--fila-gray: #F4F4F4;
}

body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: var(--fila-gray);
	margin: 0;
	display: flex;
}

/* 사이드바 */
.sidebar {
	width: 240px;
	height: 100vh;
	background: var(--fila-navy);
	color: white;
	position: fixed;
}

.sidebar .logo {
	padding: 30px;
	text-align: center;
	border-bottom: 1px solid #1a3578;
	font-weight: bold;
	font-size: 24px;
	letter-spacing: 2px;
}

.nav-item {
	padding: 15px 25px;
	cursor: pointer;
	border-bottom: 1px solid #1a3578;
	transition: 0.3s;
}

.nav-item:hover, .nav-item.active {
	background: var(--fila-red);
}

/* 컨텐츠 영역 */
.main-content {
	margin-left: 240px;
	padding: 40px;
	width: calc(100% - 240px);
}

.card {
	background: white;
	border: 1px solid #ddd;
	padding: 25px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

/* 상세 페이지 전용 스타일 */
.section-title {
	font-size: 18px;
	font-weight: bold;
	color: var(--fila-navy);
	margin: 30px 0 15px 0;
	display: flex;
	align-items: center;
}

.section-title::before {
	content: '';
	display: inline-block;
	width: 4px;
	height: 18px;
	background-color: var(--fila-red);
	margin-right: 10px;
}

.info-table {
	width: 100%;
	border-top: 2px solid var(--fila-navy);
	border-collapse: collapse;
	margin-bottom: 20px;
}

.info-table th {
	background-color: #f9f9f9;
	border: 1px solid #eee;
	padding: 12px 15px;
	text-align: left;
	width: 20%;
	font-size: 14px;
	color: #333;
}

.info-table td {
	border: 1px solid #eee;
	padding: 12px 15px;
	font-size: 14px;
	color: #666;
}

.status-badge {
	padding: 3px 10px;
	font-size: 12px;
	font-weight: bold;
	color: white;
	background-color: #28a745;
}

.status-badge.blocked {
	background-color: var(--fila-red);
}

/* 버튼 스타일 */
.btn-area {
	text-align: center;
	margin-top: 40px;
	border-top: 1px solid #eee;
	padding-top: 25px;
}

.btn-fila {
	background: var(--fila-navy);
	color: white;
	border: none;
	padding: 10px 25px;
	cursor: pointer;
}

.btn-fila-red {
	background: var(--fila-red);
	color: white;
	border: none;
	padding: 10px 25px;
	cursor: pointer;
}

/* 탭 메뉴 스타일 */
.nav-tabs {
	display: flex;
	list-style: none;
	padding: 0;
	margin: 0;
	border-bottom: 2px solid var(--fila-navy);
}

.nav-item-tab {
	padding: 10px 25px;
	cursor: pointer;
	border: 1px solid #eee;
	border-bottom: none;
	margin-right: 5px;
	background: white;
	color: #666;
	transition: 0.2s;
}

.nav-item-tab.active {
	background: var(--fila-navy) !important;
	color: white !important;
	border-color: var(--fila-navy) !important;
}
</style>
</head>
<body>
		<jsp:include page="../common/sidebar.jsp">
        <jsp:param name="currentPage" value="user" />
    </jsp:include>

	<div class="main-content">
		<div class="card">
			<h2
				style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">회원
				상세 정보</h2>
			<hr>

			<ul class="nav nav-tabs">
				<li class="nav-item-tab active" onclick="showTab('basic', this)">기본정보</li>
				<li class="nav-item-tab" onclick="showTab('point', this)">포인트/쿠폰</li>
				<li class="nav-item-tab" onclick="showTab('order', this)">주문내역</li>
				<li class="nav-item-tab" onclick="showTab('child', this)">자녀정보</li>
			</ul>

			<div class="info-body">

				<div id="section-basic" class="tab-content">
					<div class="section-title">계정 정보</div>
					<table class="info-table">
						<tr>
							<th>회원 번호</th>
							<td>${user.usernumber}</td>
							<th>회원 ID</th>
							<td style="font-weight: bold; color: var(--fila-navy);">${user.id}</td>
						</tr>
						<tr>
							<th>회원 성함</th>
							<td>${user.name}</td>
							<th>회원 등급</th>
							<td><span
								style="border: 1px solid #ccc; padding: 2px 6px; font-size: 12px;">${user.grade}</span></td>
						</tr>
						<tr>
							<th>계정 상태</th>
							<td colspan="3"><c:choose>
									<c:when test="${user.status eq 'ACTIVE'}">
										<span class="status-badge">정상 이용 중</span>
									</c:when>
									<c:otherwise>
										<span class="status-badge blocked">차단/휴면</span>
									</c:otherwise>
								</c:choose></td>
						</tr>
					</table>

					<div class="section-title">연락처 및 개인정보</div>
					<table class="info-table">
						<tr>
							<th>이메일 주소</th>
							<td>${user.email}</td>
							<th>휴대폰 번호</th>
							<td>${user.phone}</td>
						</tr>
						<tr>
							<th>성별</th>
							<td>${user.gender eq 'M' ? '남성' : '여성'}</td>
							<th>생년월일</th>
							<td><fmt:formatDate value="${user.birthday}"
									pattern="yyyy-MM-dd" /></td>
						</tr>
						<tr>
							<th>가입일</th>
							<td><fmt:formatDate value="${user.createAt}"
									pattern="yyyy-MM-dd HH:mm" /></td>
							<th>최종 수정일</th>
							<td><fmt:formatDate value="${user.updatedAt}"
									pattern="yyyy-MM-dd HH:mm" /></td>
						</tr>
					</table>
				</div>

				<div id="section-point" class="tab-content" style="display: none;">
					<div class="section-title">포인트 이용 내역</div>
					<table class="info-table" style="text-align: center;">
						<thead>
							<tr style="background: #f4f4f4;">
								<th style="text-align: center;">일자</th>
								<th style="text-align: center;">구분</th>
								<th style="text-align: center;">금액</th>
								<th style="text-align: center;">잔액</th>
								<th style="text-align: center;">내역</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="p" items="${user.pointList}">
							    <tr>
							        <td><fmt:formatDate value="${p.createAt}" pattern="yyyy-MM-dd HH:mm" /></td>
							        <td>
							            <c:choose>
							                <c:when test="${p.type eq 'EARN'}">
							                    <span style="color: #28a745; font-weight: bold;">+ 적립</span>
							                </c:when>
							                <c:when test="${p.type eq 'USED'}">
							                    <span style="color: var(--fila-red); font-weight: bold;">- 사용</span>
							                </c:when>
							                <c:otherwise>
							                    <span style="color: #666;">${p.type}</span>
							                </c:otherwise>
							            </c:choose>
							        </td>
							        <td style="font-weight: bold;">
							            <%-- DAO에서 .amout으로 담았으므로 그대로 사용 --%>
							            <fmt:formatNumber value="${p.amout}" pattern="#,###" /> P
							        </td>
							        <%-- 🚩 잔액(Balance) 칸이 빠져있어서 추가했습니다. --%>
							        <td>
							            <fmt:formatNumber value="${p.balance}" pattern="#,###" /> P
							        </td>
							        <td style="text-align: left;">${p.description}</td>
							    </tr>
							</c:forEach>
							<c:if test="${empty user.pointList}">
								<tr>
									<td colspan="5" style="padding: 50px; color: #999;">포인트
										내역이 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				<div class="section-title" style="margin-top: 50px;">쿠폰 보유 내역</div>
<table class="info-table" style="text-align: center;">
    <thead>
        <tr style="background: #f4f4f4;">
            <th style="text-align: center;">발급번호</th>
            <th style="text-align: center;">쿠폰명</th>
            <th style="text-align: center;">할인혜택</th>
            <th style="text-align: center;">유효기간</th>
            <th style="text-align: center;">상태</th>
            <th style="text-align: center;">사용일시</th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="c" items="${user.couponList}">
        <%-- 행 스타일: 사용 완료했거나, 관리자가 중지(N)시킨 쿠폰은 흐리게 처리 --%>
        <tr style="${c.isused eq '1' or c.status eq 'N' ? 'background-color: #f9f9f9; color: #bbb;' : ''}">
            <td>${c.usercouponid}</td>
            <td style="text-align: left; font-weight: bold;">${c.coupon_name}</td>
            <td>
                <c:choose>
                    <c:when test="${c.discount_type eq 'AMOUNT'}">
                        <fmt:formatNumber value="${c.price}" pattern="#,###"/>원 할인
                    </c:when>
                    <c:when test="${c.discount_type eq 'PERCENT'}">
                        ${c.price}% 할인
                    </c:when>
                    <c:otherwise>무료배송</c:otherwise>
                </c:choose>
            </td>
            <td><fmt:formatDate value="${c.expireddate}" pattern="yyyy-MM-dd" /> 까지</td>
            
            <%-- 상태 표시 로직 수정 --%>
            <td>
                <c:choose>
                    <c:when test="${c.isused eq '1'}">
                        <span style="color: #999;">사용완료</span>
                    </c:when>
                    <c:when test="${c.status eq 'N'}">
                        <span style="color: var(--fila-red); font-weight: bold;">사용불가</span>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #28a745; font-weight: bold;">사용가능</span>
                    </c:otherwise>
                </c:choose>
            </td>
            
            <td>
                <c:choose>
                    <c:when test="${not empty c.usedat}">
                        <fmt:formatDate value="${c.usedat}" pattern="yyyy-MM-dd HH:mm" />
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty user.couponList}">
        <tr><td colspan="6" style="padding: 50px; color: #999;">보유 중인 쿠폰이 없습니다.</td></tr>
    </c:if>
</tbody>
</table>
				</div>

				<div id="section-order" class="tab-content" style="display: none;">
    <div class="section-title">주문 내역</div>
    <table class="info-table" style="text-align: center;">
        <thead>
            <tr style="background: #f4f4f4;">
                <th style="text-align: center; width: 15%;">주문번호</th>
                <th style="text-align: center; width: 15%;">주문일자</th>
                <th style="text-align: center; width: 25%;">결제금액</th>
                <th style="text-align: center; width: 13%;">결제수단</th>
                <th style="text-align: center; width: 15%;">상태</th>
                <th style="text-align: center; width: 30%;">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="o" items="${user.orderList}">
                <tr>
                    <td onclick="toggleOrderDetail('${o.orderId}')" style="cursor:pointer;" style="font-weight: bold; color: var(--fila-navy);">${o.orderId}</td>
                    <td><fmt:formatDate value="${o.createdAt}" pattern="yyyy-MM-dd" /></td>
                    <td style="text-align: right; padding-right: 20px;">
                        <fmt:formatNumber value="${o.totalAmount}" pattern="#,###" />원
                    </td>
                    <td>
					    <div style="line-height: 1.4;">
					        <span style="font-size: 13px; color: #333; font-weight: bold;">
					            <c:choose>
					                <c:when test="${o.paymentMethod eq 'card'}">신용카드</c:when>
					                <c:when test="${o.paymentMethod eq 'kakao'}">카카오페이</c:when>
					                <c:otherwise>${o.paymentMethod}</c:otherwise>
					            </c:choose>
					        </span>
					        <br>
					        <span style="font-size: 11px; font-weight: bold; 
							      color: ${o.deliveryMethod eq '오늘도착' ? 'white' : 'var(--fila-red)'}; 
							      background-color: ${o.deliveryMethod eq '오늘도착' ? 'var(--fila-red)' : 'transparent'};">
							    ${o.deliveryMethod}
							</span>
					    </div>
					</td>
                    <td>
                        <c:choose>
					        <c:when test="${o.orderStatus eq '결제완료'}"><span class="status-badge" style="background:#007bff;">결제완료</span></c:when>
					        <c:when test="${o.orderStatus eq '배송중'}"><span class="status-badge" style="background:#ffc107;">배송중</span></c:when>
					        <c:when test="${o.orderStatus eq '배송완료'}"><span class="status-badge" style="background:#28a745;">배송완료</span></c:when>
					        
					        <%-- 강조할 상태들 --%>
					        <c:when test="${o.orderStatus eq '취소접수'}"><span class="status-badge" style="background:var(--fila-red);">취소접수</span></c:when>
					        <c:when test="${o.orderStatus eq '주문취소'}"><span class="status-badge" style="background:#6c757d;">취소완료</span></c:when>
					        
					        <c:otherwise><span class="status-badge" style="background:#6c757d;">${o.orderStatus}</span></c:otherwise>
					    </c:choose>
                    </td>
                    <td>
					    <div style="display: flex; gap: 5px; justify-content: center;">
					        <select id="status_${o.orderId}" style="padding: 5px; border: 1px solid #ddd;">
							    <option value="결제완료" ${o.orderStatus eq '결제완료' ? 'selected' : ''}>결제완료</option>
							    <option value="상품준비중" ${o.orderStatus eq '상품준비중' ? 'selected' : ''}>상품준비중</option>
							    <option value="배송중" ${o.orderStatus eq '배송중' ? 'selected' : ''}>배송중</option>
							    <option value="배송완료" ${o.orderStatus eq '배송완료' ? 'selected' : ''}>배송완료</option>
							    
							    <option value="취소요청" ${o.orderStatus eq '취소요청' ? 'selected' : ''}>취소요청</option>
							    <option value="반품요청" ${o.orderStatus eq '반품요청' ? 'selected' : ''}>반품요청</option>
							    
							    <option value="취소완료" ${o.orderStatus eq '취소완료' ? 'selected' : ''}>취소완료(재고복구)</option>
							    <option value="반품완료" ${o.orderStatus eq '반품완료' ? 'selected' : ''}>반품완료(재고복구)</option>
							</select>
					        <button type="button" class="btn-fila" style="padding: 5px 10px; font-size: 12px;" 
					                onclick="changeOrderStatus('${o.orderId}')">변경</button>
					    </div>
					</td>
                </tr>
                <tr id="detail_${o.orderId}" style="display:none; background-color:#fafafa;">
			        <td colspan="6" id="content_${o.orderId}" style="padding: 15px; border: 2px solid var(--fila-navy);">
			            데이터 로딩 중...
			        </td>
			    </tr>
            </c:forEach>
            <c:if test="${empty user.orderList}">
                <tr>
                    <td colspan="5" style="padding: 50px; color: #999;">주문 내역이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

				<div id="section-child" class="tab-content" style="display: none;">
					<div class="section-title">자녀 정보 (${user.childList.size()}명)</div>
					<table class="info-table">
						<thead>
							<tr style="background: #f4f4f4;">
								<th style="text-align: center; width: 33%;">자녀 이름</th>
								<th style="text-align: center; width: 33%;">자녀 성별</th>
								<th style="text-align: center; width: 34%;">자녀 생년월일</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty user.childList}">
									<c:forEach var="child" items="${user.childList}">
										<tr>
											<td style="text-align: center;">${child.childname}</td>
											<td style="text-align: center;">${child.childgender eq 'M' ? '남아' : '여아'}</td>
											<td style="text-align: center;"><fmt:formatDate
													value="${child.childbirth}" pattern="yyyy년 MM월 dd일" /></td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="3"
											style="text-align: center; color: #999; padding: 40px;">등록된
											자녀 정보가 없습니다.</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>

				<div class="btn-area">
					<button type="button" class="btn-fila"
						onclick="location.href='${pageContext.request.contextPath}/admin/userList.htm'">목록으로</button>
					<button type="button" class="btn-fila-red"
						onclick="alert('정보 수정 페이지 준비 중')" style="margin-left: 10px;">정보
						수정</button>
				</div>

			</div>
		</div>
	</div>
	<script>
	function toggleOrderDetail(orderId) {
	    const detailRow = $('#detail_' + orderId);
	    const contentBox = $('#content_' + orderId);

	    if (detailRow.is(':visible')) {
	        detailRow.hide();
	    } else {
	        $.ajax({
	            url: "${pageContext.request.contextPath}/admin/orderDetail.htm",
	            data: { orderId: orderId },
	            dataType: "json",
	            success: function(items) {
	                let html = '<div style="font-weight:bold; margin-bottom:10px;">[주문 상세 상품 리스트]</div>';
	                html += '<table style="width:100%; border-collapse:collapse; background:white;">';
	                html += '<tr style="background:#f8f9fa; border-bottom:2px solid #eee;">' +
                    '<th style="padding:10px;">상품명</th>' +
                    '<th>옵션(사이즈)</th>' +
                    '<th>수량</th>' +
                    '<th>단가</th></tr>';
	                
	                items.forEach(item => {
	                	html += `<tr style="border-bottom:1px solid #ddd; text-align:center;">
	                        <td style="padding:10px; text-align:left;">\${item.productName}</td>
	                        <td>\${item.size}</td>
	                        <td>\${item.quantity}개</td>
	                        <td style="font-weight:bold; color:var(--fila-navy);">
	                            \${Number(item.price).toLocaleString()}원
	                        </td>
	                    </tr>`;
	                });
	                html += '</table>';
	                
	                contentBox.html(html);
	                detailRow.show();
	            }
	        });
	    }
	}
    function showTab(tabName, element) {
        // 모든 컨텐츠 숨기기
        const contents = document.getElementsByClassName('tab-content');
        for (let i = 0; i < contents.length; i++) {
            contents[i].style.display = 'none';
        }

        // 선택한 섹션 보이기
        document.getElementById('section-' + tabName).style.display = 'block';

        // 모든 탭 버튼에서 active 클래스 제거
        const tabs = document.getElementsByClassName('nav-item-tab');
        for (let i = 0; i < tabs.length; i++) {
            tabs[i].classList.remove('active');
        }

        // 현재 클릭한 버튼에 active 추가
        element.classList.add('active');
    }
    function changeOrderStatus(orderId) {
        const newStatus = document.getElementById('status_' + orderId).value;
        
        if(!confirm('주문 상태를 [' + newStatus + '](으)로 변경하시겠습니까?')) return;

        // jQuery가 이미 포함되어 있다고 가정합니다.
        $.ajax({
            url: "${pageContext.request.contextPath}/admin/updateOrder.htm",
            type: "POST",
            data: {
                orderId: orderId,
                status: newStatus
            },
            dataType: "json",
            success: function(res) {
                if(res.status === "success") {
                    alert("성공적으로 변경되었습니다.");
                    location.href = location.pathname + location.search + "#order";
                    location.reload(); // 상태 반영을 위해 새로고침
                } else {
                    alert("실패: " + res.message);
                }
            },
            error: function() {
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    }
    $(document).ready(function() {
        // 1. URL에 #tabName이 있는지 확인 (예: #order, #point)
        const hash = window.location.hash;
        
        if (hash) {
            // #을 제거한 이름 (order, point 등)
            const tabName = hash.replace('#', '');
            
            // 해당 탭 버튼을 찾아서 클릭 이벤트 발생시킴
            // .nav-item-tab 중에서 onclick 속성에 해당 tabName이 포함된 것을 찾음
            const targetTab = $(".nav-item-tab[onclick*='" + tabName + "']");
            
            if (targetTab.length > 0) {
                targetTab.click();
            }
        }
    });
    </script>
</body>
</html>