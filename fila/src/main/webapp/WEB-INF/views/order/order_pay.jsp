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
<!DOCTYPE html>

<html class="no-js" lang="ko-KR"> <!--<![endif]-->
<head>
	<meta charset="UTF-8">
	<meta name="format-detection" content="telephone=no">

<title>주문/결제 | FILA</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.1, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.1, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
<!-- ✅ jQuery는 무조건 가장 먼저 -->
<script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>

<!-- 그 다음 플러그인/라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/TweenMax.js"></script>
<script src="${pageContext.request.contextPath}/js/mighty.base.1.5.7.js"></script>
<script src="${pageContext.request.contextPath}/js/matiz.js"></script>
<script src="${pageContext.request.contextPath}/js/order.js"></script>
<script src="${pageContext.request.contextPath}/js/searchZip.js"></script>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


</head>
<style>
/* 1. 흰색 모달 박스 설정 */
/* 1. 모달 전체 박스 크기 조절 */
#AddaddModalContent {
    width: 480px !important;       /* 가로 폭을 적절하게 줄임 */
    height: 600px !important;      /* 세로 높이를 적당하게 고정 */
    background: #fff;
    position: relative;
    border-radius: 12px;           /* 모서리를 조금 더 부드럽게 */
    overflow: hidden;
    display: flex !important;
    flex-direction: column !important;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2); /* 그림자로 입체감 부여 */
}

/* 2. FILA 기본 레이어의 위치 및 변형 초기화 (잘림 방지 핵심) */
#AddaddModalContent .common__layer {
    position: relative !important;
    top: 0 !important;
    left: 0 !important;
    transform: none !important;    /* 위로 50% 올라가는 속성 제거 */
    width: 100% !important;
    height: 100% !important;
    margin: 0 !important;
    padding: 0 !important;
    display: flex !important;
    flex-direction: column !important;
}

/* 3. 내부 inner 영역 최적화 */
#AddaddModalContent .inner {
    height: 100% !important;
    max-width: none !important;
    display: flex !important;
    flex-direction: column !important;
}

/* 4. 헤더/푸터는 고정, 주소 목록만 스크롤 */
#AddaddModalContent .head { 
    flex: 0 0 auto !important; 
    padding: 20px !important;
    border-bottom: 1px solid #f4f4f4;
}

#AddaddModalContent .foot { 
    flex: 0 0 auto !important; 
}

#AddaddModalContent .con {
    flex: 1 1 auto !important;     /* 남는 중간 공간을 모두 차지 */
    overflow-y: auto !important;   /* 주소가 많아지면 여기서만 스크롤 */
    padding: 15px 20px !important;
}

/* 5. 중복 배경 가림막 제거 */
#AddaddModalContent .layer-bg__wrap {
    display: none !important;
}
.addr__list li:has(input[name="addr_select"]:checked) {
    background-color: #f8f9fa !important;
    border: 1px solid #000 !important;
}

/* 마우스 올리면 손가락 모양으로 변경 */
.addr__list li {
    cursor: pointer;
}
</style>
</head>

<body class>

<!-- start of :: header -->
<jsp:include page="../common/header.jsp" />		
<!-- // end of :: header -->

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
                    
                    <input type="hidden" name="address_id" id="address_id" value="${defaultAddr.addressId}" />
                </c:when>
                <c:otherwise>
                    <div class="txt-box">
                        <p class="addr">등록된 배송지가 없습니다. 배송지를 등록해 주세요.</p>
                        <input type="hidden" name="address_id" id="address_id" value="0" />
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

					
					<input type="hidden" placeholder ="이름" maxlength="10" name="OrderDName" id="orderName" value="지영주">
					<input type="hidden" placeholder ="휴대폰 번호를 '-' 제외하고 숫자만 입력해주세요" name="OrderDTel21" maxlength="11" value="01012345678">
					<input type="hidden" class="" readonly name="OrderDZip" value="06193">
					<input type="hidden" class="" readonly maxlength="100" name="OrderDAddress1" value="서울 강남구 대치동 890-60">
					<input type="hidden" class="" readonly maxlength="100" name="OrderDRoadAddress" value="서울 강남구 테헤란로70길 12 (대치동)">
					<input type="hidden" class="" maxlength="100" tabindex="24" name="OrderDAddress2" value="9층, 쌍용교육센터" autocomplete="off">

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
							<input type="hidden" name="address_id" value="1" /> 
							
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
		<!-- // end of :: contents -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function pay_checkout() {
    // 배송지 체크
    const addrId = $("#address_id").val();
    if (addrId == "0" || addrId == "") {
        alert("배송지 정보를 등록하거나 선택해 주세요.");
        return;
    }

    const paymentMethod = $("input[name='gopaymethod']:checked").val();
    if (!paymentMethod) {
        alert("결제 수단을 선택해 주세요.");
        return;
    }

    if (!confirm("정말로 결제하시겠습니까?")) return;

    const formData = $("form[name='user']").serialize();

    $.ajax({
        url: "${pageContext.request.contextPath}/order/processOrder.htm",
        type: "POST",
        data: formData,
        dataType: "json",
        success: function(res) {
            if (res.status === "success") {
                alert("주문이 완료되었습니다!");
                location.href = res.redirect;
            } else {
                alert("오류 발생: " + res.message);
            }
        },
        error: function() {
            alert("결제 처리 중 통신 오류가 발생했습니다.");
        }
    });
}

var contextPath = '${pageContext.request.contextPath}';

//1. 배송지 목록 모달 열기
function openAddressPopup() {
    $("#AddaddModalContent").load(contextPath + "/order/address_list.htm", function(response, status, xhr) {
        if (status == "error") {
            alert("배송지 목록을 불러오는데 실패했습니다: " + xhr.status);
        } else {
            $("#AddaddressModalOverlay").css('display', 'flex').show();
        }
    });
}

// 2. 신규 배송지 추가 모달 열기 (기존 코드 수정)
$(document).on('click', '.addr-add__btn', function() {
    console.log("신규 추가 버튼 클릭됨"); // 작동 여부 확인용
    var targetUrl = contextPath + "/view/mypage/add_address.jsp"; 
    
    $("#AddaddModalContent").load(targetUrl, function(response, status, xhr) {
        if (status == "error") {
            console.log("에러 발생: " + xhr.status + " " + xhr.statusText);
            alert("신규 배송지 페이지를 불러올 수 없습니다.");
        }
    });
});

//3. 모달 닫기 공통
$(document).on('click', '.close__btn, .cbt', function() {
 $("#AddaddressModalOverlay").hide();
 $("#AddaddModalContent").empty();
});
$(document).on('click', '.addr__list li', function() {
    $(this).find('input[name="addr_select"]').prop('checked', true);
});
//4. 배송지 선택하기 (목록에서 라디오 버튼 등으로 선택했을 때)
function addr_choice() {
 var $selected = $("input[name='addr_select']:checked");
 if($selected.length == 0) {
     alert("배송지를 선택해주세요.");
     return;
 }
 
 // 데이터 추출
 var id = $selected.val();
 var name = $selected.data('name');
 var tel = $selected.data('tel');
 var zip = $selected.data('zip');
 var addr1 = $selected.data('addr1');
 var addr2 = $selected.data('addr2');

 // 부모창(order_pay.jsp) 화면 업데이트
 $("#address_id").val(id);
 $("#dName").text(name);
 $("#dTel").text(tel);
 $("#dAddr").text("(" + zip + ") " + addr1 + " " + addr2);

 $("#AddaddressModalOverlay").hide();
}
</script>
<script>
//order_pay.jsp 하단 스크립트에 추가
$(document).on('click', '.coupon__btn', function() {
    // 1. 쿠폰 모달 레이아웃 로드
    $("#AddaddModalContent").load(contextPath + "/view/order/order_coupon.jsp", function() {
        
        // 2. 모달이 로드된 후 유저의 쿠폰 목록 AJAX 호출
        $.ajax({
            url: contextPath + "/api/mypage/mycoupon_ajax.htm", // 유저 쿠폰 목록을 JSON으로 주는 URL
            type: "GET",
            dataType: "json",
            success: function(data) {
                let html = "";
                if (data && data.length > 0) {
                    data.forEach(function(cpn) {
                        // 미사용(isused='0')인 쿠폰만 표시
                        if (cpn.isused === '0') {
                            // 금액 포맷팅 (JS 방식)
                            let priceText = (cpn.discount_type === 'PERCENT') 
                                            ? cpn.price + '%' 
                                            : cpn.price.toLocaleString() + '원';

                            html += '<li>';
                            html += '    <input type="radio" id="cpRd_' + cpn.usercouponid + '" name="popupCoupon3" ';
                            html += '           class="rd__style1" value="' + cpn.usercouponid + '" ';
                            html += '           data-name="' + cpn.coupon_name + '" ';
                            html += '           data-type="' + cpn.discount_type + '" ';
                            html += '           data-val="' + cpn.price + '">';
                            html += '    <label for="cpRd_' + cpn.usercouponid + '"></label>';
                            html += '    <div style="margin-left:40px;">';
                            html += '        <p class="txt1" style="font-weight:bold; color:#333;">' + cpn.coupon_name + '</p>';
                            html += '        <p class="txt2" style="color:#ff0000; font-size:13px;">' + priceText + ' 할인 쿠폰</p>';
                            html += '    </div>';
                            html += '</li>';
                        }
                    });
                }
                
                // 만약 사용 가능한 쿠폰이 하나도 없다면 기본 메시지 유지
                if(html !== "") {
                    $(".coupon-select-box .cn ul").html(html);
                }
            },
            error: function() {
                console.log("쿠폰 목록을 불러오는 중 오류가 발생했습니다.");
            }
        });
        
        $("#AddaddressModalOverlay").css('display', 'flex').show();
    });
});
//order_pay.jsp 하단 스크립트에 추가
function useCouponLayer() {
    const $selected = $("input[name='popupCoupon3']:checked");
    if ($selected.length === 0 || $selected.val() === "") {
        alert("적용할 쿠폰을 선택해주세요.");
        return;
    }

    const cpnName = $selected.data('name');
    const cpnType = $selected.data('type'); 
    const cpnVal = parseInt($selected.data('val'));
    const goodsPrice = parseInt("${totalSalePrice}"); 

    let discountPrice = 0;
    if (cpnType === 'PERCENT') {
        discountPrice = Math.floor(goodsPrice * (cpnVal / 100));
    } else if (cpnType === 'AMOUNT') {
        discountPrice = cpnVal;
    }

    // 1. 화면 업데이트
    $("#sale_total2").text(discountPrice.toLocaleString());
    $("#cpnName").text("[" + cpnName + "] 적용됨").show();
    
    // 🚩 2. 데이터 전송용 hidden 필드 처리 (수정됨)
    // input의 name을 OrderHandler가 받는 "userCouponId"와 완벽히 일치시킵니다.
    if ($("#userCouponId").length === 0) {
        // name="userCouponId"가 OrderHandler에서 받는 파라미터명입니다.
        $("form[name='user']").append('<input type="hidden" name="userCouponId" id="userCouponId" value="' + $selected.val() + '">');
    } else {
        $("#userCouponId").val($selected.val());
    }

    // 데이터가 잘 들어갔는지 콘솔에서 확인용
    console.log("선택된 쿠폰 ID:", $("#userCouponId").val());

    pay_change0();
    $("#AddaddressModalOverlay").hide();
}

// 쿠폰 등록 버튼 클릭 이벤트 (이벤트 위임 방식)
$(document).on('click', '#offlineBtn', function(e) {
    e.preventDefault();
    
    // 변경된 ID인 #coupon_serial_input으로 값을 가져옵니다.
    const serial = $("#coupon_serial_input").val();
    
    if(!serial || serial.trim() === "") { 
        alert("쿠폰 번호를 입력하세요."); 
        $("#coupon_serial_input").focus();
        return; 
    }

    $.ajax({
        url: contextPath + "/mypage/coupon_process.htm",
        type: "POST",
        data: { "randomNo": serial.trim() },
        dataType: "json",
        success: function(res) {
        	alert(res.message);
        	if (res.status === "success") {
                $(".coupon__btn").trigger('click'); 
            }
        },
        error: function() { 
            alert("유효하지 않은 쿠폰 번호입니다."); 
        }
    });
});
// 1. 초기 설정 변수 (서버 데이터 매핑)
const GOODS_TOTAL_PRICE = parseInt("${totalSalePrice}") || 0; // 할인 적용된 상품 총합
const MY_MAX_POINT = parseInt("${user.balance}") || 0;
// 2. 포인트 모두사용 버튼
function is_check0_ALL() {
    const $input = $("input[name='usemile']");
    const $btn = $(".point__btn");
    
    if ($btn.text() === "모두사용") {
        $input.val(MY_MAX_POINT);
        $btn.text("사용 취소");
    } else {
        $input.val(0);
        $btn.text("모두사용");
    }
    pay_change0(); // 금액 재계산
}

// 3. 포인트 입력 시 실시간 검증
function pointNumberVal(obj) {
    let inputVal = parseInt(obj.value.replace(/[^0-9]/g, '')) || 0;
    
    if (inputVal > MY_MAX_POINT) {
        alert("보유하신 포인트(" + MY_MAX_POINT.toLocaleString() + "P)까지만 사용 가능합니다.");
        obj.value = 0;
    } else if (inputVal > GOODS_TOTAL_PRICE) {
        alert("결제 금액을 초과하여 포인트를 사용할 수 없습니다.");
        obj.value = 0;
    }
    pay_change0();
}

// 4. 핵심: 결제 금액 및 배송비 재계산
// order_pay.jsp의 기존 pay_change0 함수들을 모두 지우고 이 하나로 통합하세요.
function pay_change0() {
    // 1. 상품 총액 (서버에서 가져온 값)
    let goodsPrice = parseInt("${totalSalePrice}") || 0;
    
    // 2. 포인트 사용액 (입력창 값)
    let usePoint = parseInt($("input[name='usemile']").val()) || 0;
    
    // 3. 쿠폰 할인액 (화면에 찍힌 텍스트에서 숫자만 추출)
    // replace(/[^0-9]/g, "")는 숫자 이외의 모든 문자(콤마 등)를 제거합니다.
    let couponDiscount = parseInt($("#sale_total2").text().replace(/[^0-9]/g, "")) || 0;
    
    // 4. 배송비 계산 (3만원 기준)
    let deliveryFee = (goodsPrice > 0 && goodsPrice < 30000) ? 3000 : 0;
    $("#transprice2").text(deliveryFee.toLocaleString());

    // 5. 최종 결제 금액 계산
    let finalPayPrice = goodsPrice - couponDiscount - usePoint + deliveryFee;
    
    // 마이너스 금액 방지
    if(finalPayPrice < 0) finalPayPrice = 0;

    // 6. 화면 업데이트
    $("#display_total_price").text(finalPayPrice.toLocaleString());
    
    // 7. 폼 전송용 히든 필드 업데이트
    $("#OrderTotalPrice").val(finalPayPrice); 
    
    // 디버깅용 로그 (개발자 도구 F12에서 확인 가능)
    console.log("계산로그 -> 상품가:", goodsPrice, "쿠폰:", couponDiscount, "포인트:", usePoint, "배송비:", deliveryFee, "최종:", finalPayPrice);
}
// 기존에 섞여있던 todayDeliveryCheck 함수가 배송비를 0으로 만들지 않게 주의해야 합니다.
function todayDeliveryCheck() {
    // 배송 방법 라디오 버튼 클릭 시에도 금액 재계산 호출
    pay_change0();
}

// 페이지 로드 시 초기 계산 실행
$(document).ready(function() {
    pay_change0();
    $("#usePoint").text(MY_MAX_POINT.toLocaleString()); // 보유 포인트 표시 업데이트
});
</script>
<!-- start of :: footer -->
<jsp:include page="../common/footer.jsp" />
  

</body>
</html>