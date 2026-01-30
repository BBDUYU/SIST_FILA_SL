<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<section class="my-con">
           			<h2 class="tit__style4">쿠폰</h2>
					<div class="coupon-box">
						<p class="txt">공통으로 사용가능한 쿠폰은 사용처별로 각각 노출됩니다.</p>

						<div class="coupon-inp-box">
							<input type="text" placeholder="쿠폰 시리얼 번호 입력" id="offline" maxlength="17" onkeydown="if (event.keyCode==13) $('#offlineBtn').click();void(0);">
							<div>
								<button type="button" id="offlineBtn">확인</button>
							</div>
						</div>

                        <ul class="coupon__list" style="padding: 0; margin: 0; list-style: none;">
    <c:choose>
        <c:when test="${not empty couponList}">
            <c:forEach var="coupon" items="${couponList}">
                <li style="border-bottom: 1px solid #eee; padding: 30px 0; display:flex; justify-content: space-between; align-items: center; min-height: 100px;">
                    
                    <div class="coupon-info" style="flex: 1; display: flex; flex-direction: column; justify-content: center;">
                        <strong style="font-size:18px; display:block; margin-bottom:8px; color:#333; line-height: 1.2;">
                            ${coupon.coupon_name}
                        </strong>
                        <p style="color:#666; font-size:14px; margin:0; line-height: 1;">
                            <span style="color:#ff0000; font-weight:bold;">
                                <c:choose>
                                    <c:when test="${coupon.discount_type eq 'PERCENT'}">${coupon.price}% 할인</c:when>
                                    <c:when test="${coupon.discount_type eq 'AMOUNT'}"><fmt:formatNumber value="${coupon.price}" pattern="#,###"/>원 할인</c:when>
                                    <c:when test="${coupon.discount_type eq 'DELIVERY'}">무료배송</c:when>
                                    <c:otherwise>기타 할인</c:otherwise>
                                </c:choose>
                            </span>
                            <span style="margin-left:10px; color:#999;">
                                | 유효기간: <fmt:formatDate value="${coupon.expireddate}" pattern="yyyy-MM-dd"/> 까지
                            </span>
                        </p>
                    </div>

                    <div class="coupon-status" style="width: 120px; display: flex; justify-content: flex-end; align-items: center;">
                        <c:choose>
                            <c:when test="${coupon.isused eq '1'}">
                                <span class="status-badge" style="display:inline-block; width:80px; height:32px; line-height:32px; text-align:center; background:#888; color:#fff; border-radius:2px; font-size:12px; font-weight:bold;">사용완료</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge" style="display:inline-block; width:80px; height:32px; line-height:32px; text-align:center; background:#00205b; color:#fff; border-radius:2px; font-size:12px; font-weight:bold;">사용가능</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </li>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <li style="width:100%; text-align:center; padding:50px 0;">
                <p class="odr-txt_none" style="color:#999;">보유하신 쿠폰 내역이 없습니다.</p>
            </li>
        </c:otherwise>
    </c:choose>
</ul>

					</div>
				</section>

</div>
</div>
