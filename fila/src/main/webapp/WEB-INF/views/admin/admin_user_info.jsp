<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
							<td>${user.userNumber}</td>
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
        <tr style="${c.isUsed eq '1' or c.status eq 'N' ? 'background-color: #f9f9f9; color: #bbb;' : ''}">
            <td>${c.userCouponId}</td>
            <td style="text-align: left; font-weight: bold;">${c.couponName}</td>
            <td>
                <c:choose>
                    <c:when test="${c.discountType eq 'AMOUNT'}">
                        <fmt:formatNumber value="${c.price}" pattern="#,###"/>원 할인
                    </c:when>
                    <c:when test="${c.discountType eq 'PERCENT'}">
                        ${c.price}% 할인
                    </c:when>
                    <c:otherwise>무료배송</c:otherwise>
                </c:choose>
            </td>
            <td><fmt:formatDate value="${c.expiredDate}" pattern="yyyy-MM-dd" /> 까지</td>
            
            <%-- 상태 표시 로직 수정 --%>
            <td>
                <c:choose>
                    <c:when test="${c.isUsed eq '1'}">
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
                    <c:when test="${not empty c.usedAt}">
                        <fmt:formatDate value="${c.usedAt}" pattern="yyyy-MM-dd HH:mm" />
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
											<td style="text-align: center;">${child.childName}</td>
											<td style="text-align: center;">${child.childGender eq 'M' ? '남아' : '여아'}</td>
											<td style="text-align: center;"><fmt:formatDate
													value="${child.childBirth}" pattern="yyyy년 MM월 dd일" /></td>
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
	