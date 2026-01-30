<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>

<html class="no-js" lang="ko-KR"> <!--<![endif]-->
<head>
	<meta charset="UTF-8">
	<meta name="format-detection" content="telephone=no">

<title>장바구니 | FILA</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.1, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.1, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">

</head>

<body class="view__style1" style="overflow-x: hidden;">

<!-- start of :: header -->
<jsp:include page="../common/header.jsp" />
<!-- // end of :: header -->	

cartList size = ${fn:length(cartList)}

<form name="form6" id="form6"  target="dataFrame">
	<input type="hidden" name="checkwish"><input type="hidden" name="ProductQuantity"></form>
<iframe name="dataFrame" id="dataFrame" style="display:none;"></iframe>


		<!-- start of :: contents -->
		<div id="contents" class="odr__contents">
           	<h2 class="tit__style1">장바구니</h2>

			<!-- 2023-09-07 상단 띠 배너 추가 (로그인 / 비로그인 상태에 따로 별도 설정) -->
			<div class="cart-top-ban">
				<div class="swiper-wrapper">

					<div class="swiper-slide"><p class="txt"><a href="/event/review.asp" target="_self">리뷰 작성 시 최대 3만 포인트 지급</a></p></div>


					<div class="swiper-slide"><p class="txt"><a href="/specialoffer/view.asp?seq=373" target="_self">오늘 도착 5,000원 혜택</a></p></div>


					<div class="swiper-slide"><p class="txt"><a href="/specialoffer/view.asp?seq=377" target="_self">신규 가입 시 1만원 할인</a></p></div>


				</div>
			</div>
			<!-- //2023-09-07 상단 띠 배너 추가 (로그인 / 비로그인 상태에 따로 별도 설정) -->
	
			<!-- cart tab -->
			<ul class="odr-tab">
				<li><a href="${pageContext.request.contextPath}/view/pay/cart.jsp" id="normalli" >일반배송 <sup>0</sup></a></li> <!-- 활성화 class "on" -->
				<input type="checkbox" id="todayDeliView" onclick="todayDeliViewAll();void(0);" style="display:none"/>
				<li><a href="${pageContext.request.contextPath}/view/pay/cart2.jsp" id="todayli" class="on"><label for="" >오늘도착 <sup id="todayCnt">0</sup></label></a></li>
			</ul>

			<!-- //cart tab -->
			<!-- // 일반배송일 경우 display: none처리 / 오늘도착 일 경우 block 처리 -->
			<div class="order-info-box todayinfo" style="">
				<div class="hd">
					<p class="tit">오늘도착 가능</p>
				</div>

				<div class="cn">
					<div class="txt-box">
						<p>멤버쉽 전용 서비스입니다.</p>
						<p>오늘도착 서비스는 [오늘도착]상품끼리만 주문가능합니다.</p>
						<p>오늘도착 주문은 평일 오전 11시 50분까지 “결제완료”된 주문건에 한해 배송됩니다.</p>
						<p>배송가능 지역은 서울 전지역만 가능하며, 주문서 작성 페이지에서 확인 가능합니다.</p>
						<p>주문하시는 상품의 크기 및 수량에 따라 박스당 5,000원의 배송비가 발생됩니다.</p>
					</div>
				</div>
			</div>
			
			
			<c:choose>
			<%-- 장바구니에 상품이 없을 경우 --%>
			<c:when test="${empty cartList}">
			  <div class="cart__empty">
			    <p class="txt">장바구니에 담긴 상품이 없습니다.</p>
			    <a class="btn_sld__bk" href="<c:url value='/'/>">쇼핑 계속하기</a> <%-- 메인 완성되면 메인 링크 추가 필요함 --%>
			  </div>
			</c:when>
			
			<%-- 장바구니에 상품이 있을 경우 --%>
			<%-- 
			  <c:if test="${not empty cartList}">
				  <c:forEach var="item" items="${cartList}">
				    <div class="cart-item">
				      <img src="${item.mainImageUrl}">
				      <div class="name">${item.productName}</div>
				      <div class="price">${item.saleUnitPrice}</div>
				      <div class="qty">${item.quantity}</div>
				    </div>
				  </c:forEach>
				</c:if>
			 --%>
				
			
			  <c:otherwise>

			    <section class="odr-wrap">
			      <div class="odr-box">
			
			        <div class="odr-hd">
			          <div>
			            <input type="checkbox" id="checkAll" checked="checked">
			            <label for="checkAll">전체선택 <span>(${fn:length(cartList)})</span></label>
			          </div>
			          <div class="txt-btn">
			            <a href="javascript:void(0);">품절삭제</a>
			            <a href="javascript:void(0);">선택삭제</a>
			          </div>
			        </div>
			
			        <ul class="odr__list">
			
			          <c:set var="sumOrigin" value="0"/>
			          <c:set var="sumSale"   value="0"/>
			          <c:set var="sumLine"   value="0"/>
			
			          <c:forEach var="item" items="${cartList}" varStatus="st">
			            <c:set var="sumOrigin" value="${sumOrigin + (item.originUnitPrice * item.quantity)}"/>
			            <c:set var="sumSale"   value="${sumSale + (item.saleUnitPrice * item.quantity)}"/>
			            <c:set var="sumLine"   value="${sumLine + item.lineAmount}"/>
			
			            <li>
			              <div class="goods_sel">
			                <input type="checkbox" id="checkProduct${st.index}" checked="checked">
			                <label for="checkProduct${st.index}">선택</label>
			              </div>
			
			              <div class="goods-thumb">
			                <a href="<c:url value='/product/view.do?productId=${item.productId}'/>">
			                  <c:choose>
			                    <c:when test="${not empty item.mainImageUrl}">
			                      <img src="${item.mainImageUrl}" alt="${item.productName}">
			                    </c:when>
			                    <c:otherwise>
			                      <img src="<c:url value='/images/noimage.png'/>" alt="no image">
			                    </c:otherwise>
			                  </c:choose>
			                </a>
			              </div>
			
			              <div class="goods-info">
			                <p class="sex">FILA</p>
			                <p class="tit">${item.productName}</p>
			
			                <div class="info">
			                  <div><p>수량 : ${item.quantity}개</p></div>
			                </div>
			
			                <div class="pp-box">
			                  <div class="price">
			                    <p class="sale">
			                      <fmt:formatNumber value="${item.saleUnitPrice}" pattern="#,###"/>원
			                    </p>
			                  </div>
			                </div>
			
			                <p class="today_tag">오늘도착 가능</p>
			              </div>
			
			              <div class="goods-etc">
			                <p class="ico">
			                  <button type="button" class="wish">위시</button>
			                  <button type="button" class="del">삭제</button>
			                </p>
			                <p class="btn-box">
			                  <button type="button" class="btn_sld__gr">옵션 변경</button>
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
			              <dd><span id="ctPice"><fmt:formatNumber value="${sumOrigin}" pattern="#,###"/></span>원</dd>
			            </dl>
			            <dl>
			              <dt>상품 할인금액</dt>
			              <dd class="_type_red">-<span id="miPrice"><fmt:formatNumber value="${sumOrigin - sumSale}" pattern="#,###"/></span>원</dd>
			            </dl>
			            <dl>
			              <dt>배송비</dt>
			              <dd><span id="dvPrice">0</span>원</dd>
			            </dl>
			            <dl class="total-pirce">
			              <dt>총 결제 예상 금액</dt>
			              <dd><span id="pPrice"><fmt:formatNumber value="${sumLine}" pattern="#,###"/></span>원</dd>
			            </dl>
			
			            <div class="btn-box">
			              <a href="javascript:void(0);" class="btn_bg__bk">구매하기</a>
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
	</div>

		<!-- // end of :: contents -->

<!-- 2023-04-03 #HJ GA4 S -->

<!-- 2023-04-03 #HJ GA4 E -->
	
		<!-- 하단 고정 버튼 (top, sns) -->
<div class="bot-fix-box">
	<div class="inner">

		<!-- 2023-12-13 오늘 본 상품 있는 경우 (상품 썸네일 변경) -->
		<button type="button" class="today-goods__thumb today-goods__btn">
			<img src="//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS254DJ01F001_234.jpg" alt="">
		</button>
		<!-- // 2023-12-13 오늘 본 상품 있는 경우 (상품 썸네일 변경) -->


		<button type="button" class="kakaotalk__btn" onclick="doBizmsg();void(0);">
			<svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 50 50">
				<g id="btn_kakao" transform="translate(-330)">
					<circle id="타원_73" data-name="타원 73" cx="25" cy="25" r="25" transform="translate(330)" fill="#fedc00"/>
					<g id="그룹_18" data-name="그룹 18" transform="translate(345 15)">
						<path id="패스_8" data-name="패스 8" d="M192.79,193.223c-5.868,0-10.625,3.782-10.625,8.447a8.127,8.127,0,0,0,4.614,6.966l-.768,4.118a.236.236,0,0,0,.362.241l4.564-3.006s1.221.128,1.853.128c5.868,0,10.625-3.782,10.625-8.447s-4.757-8.447-10.625-8.447" transform="translate(-182.165 -193.223)" fill="#3c1e1e"/>
					</g>
				</g>
			</svg>
		</button>


		<script src="https://bizmessage.kakao.com/chat/includeScript"></script>
<script type="text/javascript">
function doBizmsg() {
var kakaoPop = window.open("about:blank","kakaoPop","width=350,height=550")
var frm = document.formbiz;
frm.submit();
//document.getElementById("form-biz").submit();

}
</script>
<form id="form-biz" name="formbiz" action="https://bizmessage.kakao.com/chat/open" method="post" target="kakaoPop">
<!--
<input type="hidden" name="uuid" value="@FILA" />
<input type="hidden" name="extra" value="FILA_M"/>
-->

<input type="hidden" name="uuid" value="@fila" />
<input type="hidden" name="extra" value="TCK_M"/>

<input type="hidden" name="bot" value="true" />
<input type="hidden" name="event" value="시작" />
</form>



		<button type="button" class="top__btn">top</button>		
	</div>
</div>
<!-- //하단 고정 버튼 (top, sns) -->


<!-- start of :: footer -->
<jsp:include page="../common/footer.jsp" />
<!-- // end of :: footer -->
 
<script>
        $(document).ready(function(){
            if(typeof Swiper !== 'undefined') {
                new Swiper('.goods__slider', {
                    slidesPerView: 4,
                    spaceBetween: 10,
                    freeMode: true,
                    scrollbar: {
                        el: '.goods-slider-scrollbar',
                        draggable: true,
                    },
                });
            }
        });
</script>   
    

    
    
</body>
</html>