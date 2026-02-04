<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div id="contents" class="odr__contents">
	<h2 class="tit__style1">장바구니</h2>

	<div class="cart-top-ban">
		<div class="swiper-wrapper">
			<div class="swiper-slide">
				<p class="txt">
					<a href="#">신규 가입 시 1만원 할인</a>
				</p>
			</div>
		</div>
	</div>

	<ul class="odr-tab">
		<li><a href="javascript:void(0);" id="normalli" class="on">일반배송
				<sup>${fn:length(cartList)}</sup>
		</a></li>
		<li><a href="javascript:void(0);" id="todayli">오늘도착 <sup id="todayCnt">0</sup></a></li>
	</ul>

	<div class="order-info-box todayinfo" style="display: none;">
		<div class="hd">
			<p class="tit">오늘도착 가능</p>
		</div>
		<div class="cn">
			<div class="txt-box">
				<p>배송가능 지역은 서울 전지역만 가능하며, 오전 11시 50분 결제건까지 당일 배송됩니다.</p>
			</div>
		</div>
	</div>

	<c:choose>
		<c:when test="${empty cartList}">
			<div class="cart__empty">
				<p class="txt">장바구니에 담긴 상품이 없습니다.</p>
				<a href="${pageContext.request.contextPath}/" class="btn_sld__bk">쇼핑 계속하기</a>
			</div>
		</c:when>

		<c:otherwise>
			<section class="odr-wrap">
				<div class="odr-box">
					<div class="odr-hd">
						<div>
							<input type="checkbox" id="checkAll" class="cb__style3"
								onclick="CheckedAll2(form1);void(0);" checked=""> <label
								for="checkAll">전체선택<span id="cartlistCnt"></span></label>
						</div>
						<div class="txt-btn">
						  <form id="clearCartForm"
						        action="${pageContext.request.contextPath}/pay/cart/clear.htm"
						        method="post"
						        style="display:inline;">
						    <button type="submit"
						            style="background:none;border:0 ;padding:0;cursor:pointer;">
						      전체삭제
						    </button>
						  </form>
						</div>
						
						<script>
						  document.getElementById("clearCartForm").addEventListener("submit", function(e){
						    if (!confirm("장바구니 상품을 전체 삭제하시겠습니까?")) {
						      e.preventDefault();
						    }
						  });
						</script>
						</div>
					</div>

					<div id="optionModal" class="modal"
						style="display: none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5);">
						<div class="modal-content"
							style="background: #fff; width: 400px; margin: 15% auto; padding: 20px; border-radius: 5px;">
							<h3>옵션/수량 변경</h3>
							<hr>
							<input type="hidden" id="modalCartItemId">
							<div style="margin: 20px 0;">
								<p>수량</p>
								<input type="number" id="modalQty" min="1"
									style="width: 100%; padding: 10px; border: 1px solid #ddd;">
							</div>
							<div
								style="display: flex; justify-content: space-between; margin-top: 20px;">
								<button type="button" onclick="closeModal()"
									style="padding: 10px 30px; background: #eee; border: none; cursor: pointer;">취소</button>
								<button type="button" onclick="submitOption()"
									style="padding: 10px 30px; background: #000; color: #fff; border: none; cursor: pointer;">변경적용</button>
							</div>
						</div>
					</div>

					<ul class="odr__list">
						<c:forEach var="item" items="${cartList}" varStatus="st">

							<c:set var="rawImg" value="${item.mainImageUrl}" />
							<c:set var="finalImg"
								value="${fn:replace(rawImg, 'file:///C:/fila_upload', '/upload')}" />

							<li>
								<!-- 선택 -->
								<div class="goods_sel">
									<input type="checkbox" id="checkProduct${st.index}"
										class="cb__style3 todaydelichk item-chk" checked="checked"
										data-price="${item.saleUnitPrice * item.quantity}"
										data-priceori="${item.originUnitPrice}"
										data-pricesale="${item.saleUnitPrice}"
										data-pq="${item.quantity}"> <label
										for="checkProduct${st.index}">선택</label>
								</div> <!-- 상품 이미지 -->
								<div class="goods-thumb">
									<a
										href="${pageContext.request.contextPath}/product/product_detail.htm?productId=${item.productId}">
										<img
										src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${item.productId}/${item.productId}_main_1.jpg"
										alt="${item.productName}"
										onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
									</a>
								</div> <!-- 상품 정보 -->
								<div class="goods-info">
									<p class="sex">FILA</p>
									<p class="tit">${item.productName}</p>

									<div class="info">
										 
										<div>
											 
											<p>
												사이즈&nbsp;:&nbsp;
												<c:choose>
													<c:when test="${not empty item.size}">
                                                  ${item.size}
                                              </c:when>
													<c:otherwise>
														<span style="color: red;">사이즈 정보 없음</span>
													</c:otherwise>
												</c:choose>
											</p>
											 
										</div>
										<div>
											<p>수량&nbsp;:&nbsp;${item.quantity}개</p>
										</div>
									</div>

									<div class="pp-box">
										<div class="price">
											<p class="sale">
												<fmt:formatNumber
													value="${item.saleUnitPrice * item.quantity}"
													pattern="#,###" />
												원
											</p>

											<c:if test="${item.originUnitPrice > item.saleUnitPrice}">
												<p class="normal _sale">
													<fmt:formatNumber
														value="${item.originUnitPrice * item.quantity}"
														pattern="#,###" />
													원
												</p>
												<p class="percent">
													<fmt:formatNumber
														value="${100 - (item.saleUnitPrice * 100 / item.originUnitPrice)}"
														maxFractionDigits="0" />
													%
												</p>
											</c:if>
										</div>
									</div>

									<!-- 오늘도착 -->
									<p class="today_tag">오늘도착 가능</p>
								</div> <!-- 기타 버튼 -->
								<div class="goods-etc">
									<p class="ico">
										<button type="button" class="del"
											onclick="deleteItem(${item.cartItemId})">삭제</button>
									</p>
									<p class="btn-box">
										<button type="button" class="btn_sld__gr"
										  onclick="document.getElementById('optionModal').style.display='block';
										           document.getElementById('modalCartItemId').value='${item.cartItemId}';
										           document.getElementById('modalQty').value='${item.quantity}';">
										  옵션 변경
										</button>
									</p>
								</div>
							</li>

						</c:forEach>
					</ul>

				</div>

				<div class="total-box">
					<div class="price-box">
						<div class="price-inner">
							<dl>
								<dt>총 상품금액</dt>
								<dd>
									<span id="ctPice">0</span>원
								</dd>
							</dl>
							<dl>
								<dt>상품 할인금액</dt>
								<dd class="_type_red">
									- <span id="miPrice">0</span>원
								</dd>
							</dl>
							<dl>
								<dt>배송비</dt>
								<dd>
									<span id="dvPrice">0</span>원
								</dd>
							</dl>
							<dl class="total-pirce">
								<dt>총 결제 예상 금액</dt>
								<dd>
									<span id="pPrice">0</span>원
								</dd>
							</dl>

							<div class="btn-box">
								<!--a href="javascript:CheckedAllBuy(form1);" class="btn_bg__bk">구매하기</a-->
								<a href="javascript:CheckedBuy();" class="btn_bg__bk">구매하기</a>
							</div>
						</div>

						<div class="cart-notice-box">
							<p>장바구니는 멤버십 회원 로그인 시 15일간 보관됩니다.</p>
							<p>더 오래 보관 하고 싶은 상품은 위시리스트에 담아주세요.</p>
							<p>장바구니 보관 중 상품가격이나 혜택이 변동될 수 있습니다.</p>
						</div>
					</div>


				</div>
			</section>
		</c:otherwise>
	</c:choose>
	<div id="cartModalOverlay" style="display: none;">
		<div id="cartModalContent"></div>
	</div>
</div>