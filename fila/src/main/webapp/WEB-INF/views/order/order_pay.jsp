<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.Calendar" %>
<%
    Calendar cal = Calendar.getInstance();
    int hour = cal.get(Calendar.HOUR_OF_DAY); // 24시간 형식
    request.setAttribute("currentHour", hour);
%>
<form name="form6" id="form6"  target="dataFrame">

	<input type="hidden" name="checkwish"><input type="hidden" name="ProductQuantity"></form>
	<iframe name="dataFrame" id="dataFrame" style="display:none;"></iframe>

		<!-- start of :: contents -->
		<div id="contents" class="odr__contents">
           	<h2 class="tit__style1">주문 및 결제</h2>
		<form name="user" method="post" > 
		
		<c:if test="${not empty cartItemIds}">
	        <input type="hidden" name="cartItemIds" value="${cartItemIds}" />
	    </c:if>
	
	    <c:if test="${isDirect}">
	        <input type="hidden" name="productId" value="${orderItems[0].productId}" />
	        <input type="hidden" name="quantity" value="${orderItems[0].quantity}" />
	        <input type="hidden" name="combinationId" value="${orderItems[0].combinationId}" />
	    </c:if>
    
			<section class="odr-wrap">
				<!-- order -->
				<div class="odr-box">
					<!-- 배송지 정보 -->
					<div class="odr-toggle-box _type_addr open">
    <div class="hd">
        <h3>배송지 정보</h3>
        <div>
            <button type="button" class="delivery-change__btn addrBtn" onclick="openAddressPopup();">변경</button>
        </div>
    </div>

    <div class="cn">
        <div class="addr-info-box">
            <c:choose>
                <c:when test="${not empty defaultAddr}">
                    <div class="txt-box">
                        <p class="name delivery-change__btn" id="dName">${defaultAddr.recipientName}</p>
                        <p class="tel delivery-change__btn" id="dTel">${defaultAddr.recipientPhone}</p>
                    </div>

                    <div class="txt-box">
                        <p class="addr delivery-change__btn" id="dAddr">
                            (${defaultAddr.zipcode})&nbsp;${defaultAddr.mainAddr}&nbsp;${defaultAddr.detailAddr}
                        </p>
                    </div>
                    
                    <input type="hidden" name="addressId" id="address_id" value="${defaultAddr.addressId}" />
                </c:when>
                <c:otherwise>
                    <div class="txt-box">
                        <p class="addr">등록된 배송지가 없습니다. 배송지를 등록해 주세요.</p>
                        <input type="hidden" name="addressId" id="address_id" value="0" />
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="msg-box">
                <select onchange="$('#orderMemo').val(this.value);">
                    <option value="">배송요청사항 선택</option>
                    <option value="부재시 문앞에 부탁드려요.">부재시 문앞에 부탁드려요.</option>
                    <option value="경비실에 맡겨주세요.">경비실에 맡겨주세요.</option>
                    <option value="">직접 입력</option>
                </select>
                <input type="text" placeholder="내용을 입력해주세요." name="OrderContents" id="orderMemo">
            </div>
        </div>						
    </div>
</div>
					<!-- //배송지 정보 -->

					
					<input type="hidden" name="OrderDName" id="orderName" value="${defaultAddr.recipientName}">
					<input type="hidden" name="OrderDTel21" value="${defaultAddr.recipientPhone}">
					<input type="hidden" name="OrderDZip" value="${defaultAddr.zipcode}">
					<input type="hidden" name="OrderDAddress1" value="${defaultAddr.mainAddr}">
					<input type="hidden" name="OrderDAddress2" value="${defaultAddr.detailAddr}">

					<!-- 배송 방법 -->
					<div class="odr-toggle-box open deliveryTypeBox">
						<div class="hd">
							<h3>배송방법</h3>
						</div>

						<div class="cn" id="todayDelivery">
							<div class="delivery-type-box">
								<!-- 배송방법 버튼 -->
								<input type="radio" name="deliveryOption" id="delivery_method1" value="0" onclick="todayDeliveryCheck();" data-gtm-form-interact-field-id="0" class="_val">
								<label for="delivery_method1">일반배송</label>

								<input type="radio" name="deliveryOption" id="delivery_method2" value="1" 
								       onclick="todayDeliveryCheck();" 
								       ${currentHour >= 11 ? 'disabled' : ''}>  
								<label for="delivery_method2">
								    오늘도착${currentHour >= 11 ? '(불가)' : ''}
								</label>

											<!--<a href="javascript:popAddDelivery()" class="btn_style6 addDeli"><span class="gr">+</span> 같이 배송</a>-->

								<!-- //배송방법 버튼 -->
								
								<!-- 설명 -->
								<div class="delivery-info-box">
									<div class="basic-box" style="display: block;">
										<p class="txt">3만원 이상 무료 배송 / 익일 출고</p>
									</div>

									<div class="today-box" style="display: none;">
										<p class="txt">
											* 멤버쉽회원만 이용가능합니다.<br>
											<b>* 오전 <strong class="red">11시50분 이후 주문시엔 익일 배송</strong>되며,<br>
											주말, 공휴일 주문시 이후 평일(영업일)에 출고됩니다.<br></b>
											* 배송 지역 : 서울 전체<br><br>
											
											<span>
												<!--* 오늘도착 불가능 상품 포함되었습니다.<br />
												* 오늘도착 가능한 재고가 없습니다.<br />
												* 배송지를 입력해주세요.-->

												<span class="red">5,000원</span> / <b style="color:blue;">12/30(화)</b> <ee style="color:black;">23시전 도착예정</ee><br>
	
											</span></p><p id="useCpn">
												
											</p>
											
											
										<p></p>
									</div>
								</div>
								<!-- //설명 -->
							</div>



<script>
	$("#delivery_method1").click();
	todayDeliveryCheck();

</script>
</div>

					</div>
					<!-- //배송 방법 -->


					<!-- 주문상품 -->
					<div class="odr-toggle-box open" id="cartList" >


						<div class="hd">
							<h3>주문 상품</h3> <!-- 2024-11-07 상품 수량/가격 위치 변경-->
							<p class="notice" style="display:none;">* 매장 발송 상품은  물류센터에서 발송되는 상품과 개별 배송되오니 참고 부탁드립니다.</p>
							<p class="txt _v2">1건&nbsp;/&nbsp;<ee id="TotalPrice_Cart">0</ee>원</p>

							<div>
								<button type="button" class="toggle__btn">button</button>
							</div>
						</div>
						
						<div class="cn">
							<ul class="odr__list __pay">
    <c:forEach var="item" items="${orderItems}">
        <li>
            <div class="goods-thumb">
			    <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${item.productId}/${item.productId}_main_1.jpg" 
			         alt="${item.productName}" 
			         onerror="this.src='${pageContext.request.contextPath}/resources/images/no_image.jpg';">
			</div>
            <div class="goods-info">
                <p class="sex">FILA</p>
                <p class="tit">${item.productName}</p>

                <div class="info">
                    <div><p>상품코드&nbsp;:&nbsp;${item.productId}</p></div>
                    <div><p>옵션(ID)&nbsp;:&nbsp;${item.combinationId}</p></div>
                    <div><p>수량&nbsp;:&nbsp;${item.quantity}</p></div>
                </div>

                <div class="pp-box">
                    <div class="price">
                        <p class="sale"><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</p>
                    </div>
                </div>
                <p class="today_tag">배송준비중</p>
            </div>
        </li>
    </c:forEach>
</ul>
						</div>



<script>
	$("#TotalPrice_Cart").html("259,000");
	
</script>
					</div>
					<!-- // 주문상품 -->
						
					<!-- 2023-02-01 사은품 증정 추가 -->

				<!-- 2020-10-19 gift_area S -->

			<div class="odr-toggle-box open odr-gift-wrap gift-present">
						<div class="hd">
							<h3>사은품 증정</h3>
						</div>
						<div class="cn">
							<ul class="thumb3_list">

<!--div>25 실버문 신꾸 패키지 종료 되었습니다.</div-->

							</ul>

						</div>	
					</div>
				<!-- 2020-10-19 gift_area E -->

<script>
	jQuery(".gift-present").hide();
</script>







					<!-- 결제방법 -->
					<div class="odr-toggle-box open">
						<div class="hd">
							<h3>결제방법을 선택해 주세요.</h3>

							<div>
								<p class="txt" id="paymethod"></p>
								<button type="button" class="toggle__btn">button</button>
							</div>
						</div>

						<div class="cn">
							<div class="pay-method-box">
								<ul>
									<li>
										<input type="radio" name="gopaymethod" id="payWay1" value="card" data-method="신용카드" >
										<label for="payWay1">신용카드</label>
										<!--span class="tag">혜택</span-->
									</li>  
									<li>
										<input type="radio" name="gopaymethod" id="payWay9" value="iniciskakao" data-method="카카오페이" >
										<label for="payWay9">
											<img src="//filacdn.styleship.com/filacontent2//mo/resource/images/sub/pay_kakao.png" alt="" style="width: 60px;" />
										</label>
									</li>
								</ul>

								<div class="chk-pay">
									<input type="checkbox" id="payChk" name="paymethodSave" value="1" class="cb__style1" checked>
									<label for="payChk">선택한 결제수단을 다음에도 사용</label>
								</div>
							</div>
						</div>
					</div>
					<!-- //결제방법 -->


					
				</div>	
				<!-- // order -->
					<c:set var="totalGoodsPrice" value="0" />
				<c:forEach var="item" items="${orderItems}">
				    <c:set var="totalGoodsPrice" value="${totalGoodsPrice + (item.price * item.quantity)}" />
				</c:forEach>
				<!-- total price -->
				<div class="total-box">
					

					<div class="price-box">
						<div class="price-inner">

							<dl>
							    <dt>총 상품금액</dt>
							    <dd><fmt:formatNumber value="${totalOriginalPrice}" pattern="#,###"/>원</dd>
							</dl>
							<dl>
							    <dt>상품 할인금액</dt>
							    <dd class="_type_red">-
							        <em id="sale_total3">
							            <fmt:formatNumber value="${totalOriginalPrice - totalSalePrice}" pattern="#,###"/>
							        </em>원
							    </dd>
							</dl>

							

							<dl>
								<dt>
									쿠폰 할인
									
									<button type="button" class="coupon__btn">선택</button>									
								</dt>
								<dd class="_type_red">-<em id="sale_total2">0</em>원</dd>

								<!-- 쿠폰 선택시 노출 -->
								<dd class="selected-coupon" id="cpnName" ></dd>
								<!-- //쿠폰 선택시 노출 -->
							</dl>
							

							<dl id="pointArea">
							    <dt>
							        포인트 사용
							        <button type="button" class="point__btn" onclick="is_check0_ALL();">모두사용</button>
							    </dt>
							    <dd class="_type_red">
							        -<input type="text" name="usemile" value="0" 
							                onkeyup="pointNumberVal(this);" 
							                onblur="pay_change0();"
							                style="ime-mode:disabled;" maxlength="7">P
							    </dd> <dd class="my-point">보유 포인트 : 
							        <ee id="usePoint"><fmt:formatNumber value="${user.balance}" pattern="#,###" /></ee>P
							    </dd>
							</dl>
							<dl>
							    <dt>배송비</dt>
							    <dd>
							        <em id="transprice2">0</em>원 <em class="pcolor1" id="islandPay2"></em>
							        <em class="pcolor1" id="dangilPay2"></em>
							    </dd>
							</dl>
							
							<dl class="total-pirce">
							    <dt>최종 결제금액</dt>
							    <dd><span id="display_total_price"><fmt:formatNumber value="${totalSalePrice}" pattern="#,###"/></span>원</dd>
							</dl>
							<input type="hidden" name="OrderTotalPrice" id="OrderTotalPrice" value="${totalGoodsPrice}" />
							<input type="hidden" name="address_id" id="final_address_id" value="${defaultAddr.addressId}" /> 
							
							<dl class="_type_agree">
								<dt>주문 내용을 확인했으며, 약관에 동의합니다.</dt>
								<dd><a href="javascript:;" class="btn_agree_view">약관보기</a></dd>
							</dl>
							<input type="hidden" name="use_rnd1" value="ok">
							

							<div class="btn-box" id="checkoutbtn">
								<a href="javascript:pay_checkout();void(0);" class="btn_bg__bk on">결제하기</a> <!-- 구매하기 버튼 활성화시 off 제거-->
							</div>

						</div>
						
					</div>

				</div>
				<!-- //total price -->

				
			</section>
			</form>
			
		</div>
<div id="AddaddressModalOverlay" class="style-modal-overlay" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
    <div id="AddaddModalContent" style="width: 100%; max-width: 500px; background: #fff; min-height: 300px; position: relative; z-index: 10000;">
        </div>
</div>
