<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<!DOCTYPE html>
<html lang="ko">
<head>
<script src="${pageContext.request.contextPath}/js/list.js"></script>
    <title>FILA 상품상세</title>
</head>
<c:if test="${not empty errorMsg}">
    <script>
        alert("${errorMsg}");
        history.back();
    </script>
</c:if>

<c:if test="${empty errorMsg and not empty product}">

<%-- [cart 관련 추가 1] 로그인 후 돌아올 returnUrl 만들기 (쿼리스트링 포함) --%>
<c:set var="pid" value="${param.product_id}" />
<c:if test="${empty pid}">
  <c:set var="pid" value="${product.product_id}" />
</c:if>

<c:set var="returnUrl" value="/product/product_detail.htm?product_id=${pid}" />

<%-- [cart 관련 추가 2] loginUrl (returnUrl 파라미터 포함, 자동 URL 인코딩) --%>
<c:url var="loginUrl" value="/login.htm">
    <c:param name="returnUrl" value="${returnUrl}" />
</c:url>

<%-- [cart 관련 추가 3] 장바구니 담기 기본 URL (action/add 포함) quantity는 JS에서 현재 수량 읽어서 붙일 거라 여기선 빼둠 --%>
<c:url var="addCartBaseUrl" value="/pay/cart.htm">
    <c:param name="action" value="add" />
    <c:param name="productId" value="${product.product_id}" />
</c:url>

<body class="view__style1" style="overflow-x: hidden;">
        <jsp:include page="../common/header.jsp" />
    <input type="hidden" name="bnftNm" id="bnftNm" value="" />    
    <input type="hidden" name="bnftVal" id="bnftVal" value="" />        
    <input type="hidden" name="bnftDate" id="bnftDate" value="" />    
    <input type="hidden" name="bnftLimit" id="bnftLimit" value="" />    
    
    <div id="wrap">
        
        <div id="contents" class="goods__contents">            
            <section class="goods-view-box">
                <h2 class="hidden">상품 상세</h2>

                <div class="sticky-box">
                    <div class="goods-detail-box">

                  <!-- 상세페이지 메인 이미지 -->
                  <div class="photo-list-box _style1">
                     <ul>
                       <c:forEach var="imgName" items="${mainImages}">
                              <li>
                               <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.product_id}/${imgName}" 
                                    alt="${product.name}" 
                                    onerror="$(this).parent('li').hide();">
                              </li>
                          </c:forEach>
                      </ul>
               
                   <div class="view-slider-box">
                       <div class="inner">
                           <div class="view-photo__slider swiper">
                               <div class="swiper-wrapper">
                                   <c:forEach var="imgName" items="${mainImages}">
                                       <div class="swiper-slide">
                                           <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.product_id}/${imgName}" alt="">
                                       </div>
                                   </c:forEach>
                               </div>
                           </div>
               
                           <div class="slider-btn-box">
                               <button type="button" class="prev__btn"></button>
                               <div class="slider-scrollbar"></div>
                               <button type="button" class="next__btn"></button>
                           </div>
                       </div>
                   </div>
               </div>
               <!-- 상세페이지 메인 이미지  끝 -->
               
                        <div class="detail-box">

                            <div class="product-notice-banner">
                                <img src="//filacdn.styleship.com/filacontent2/data/ContentsFile/PDP_img_d.jpg" alt="">
                            </div>
                            
                            <!-- 모델컷 리스트가 비어있지 않을 때만 전체 영역 출력 -->
                     <c:if test="${not empty modelImages}">
                         <div class="model-cut-box">
                             <div class="hd">
                                 <p class="tit">모델컷</p>
                             </div>
                             
                             <div class="cn">
                                 <div class="mc-slider-box">
                                     <!-- swiper 클래스를 유지해야 슬라이드가 작동합니다 -->
                                     <div class="mc__slider swiper">
                                         <div class="swiper-wrapper">
                                             <c:forEach var="mImg" items="${modelImages}">
                                                 <div class="swiper-slide">
                                                     <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.product_id}/${mImg}" alt="">
                                                 </div>
                                             </c:forEach>
                                         </div>
                                         <!-- 페이지네이션 -->
                                         <div class="mc-swiper-pagination"></div>
                                     </div>
                                 </div>
                             </div>

                                <div class="mc-info-box">
                                    <p>
                                        (여) 165cm / 착용사이즈 : WS/S<br>
                                        모델 착용 이미지보다 제품컷 이미지의 컬러가 정확합니다.
                                    </p>
                                </div>
                                </div>
                            </c:if>
                            <!-- 상세페이지 디테일 이미지 -->
                            <c:forEach var="dImg" items="${detailImages}">
                         <div class="top-img-box">
                             <div class="img">
                                 <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.product_id}/${dImg}" 
                                      alt="" style="width:100%;">
                             </div>
                         </div>
                     </c:forEach>
                            <!-- 상세페이지 디테일 이미지 끝 -->

                            <div class="checkpoint-box">
                                <div class="hd">
                                    <p class="tit">체크 포인트</p>
                                </div>
                                <div class="cn">
                                    <div class="cp-slider-box">
                                        <div class="cp__slider swiper">
                                            <div class="swiper-wrapper">
                                                <div class="swiper-slide">
                                                    <img src="//filacdn.styleship.com/filacontent2/data/filastyle/유러피안_(white2)_(960x640)_89.jpg" alt="">
                                                    <div class="txt-box">
                                                        <p class="tit"></p>
                                                        <p class="txt"></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="cp-swiper-pagination"></div>
                                    </div>
                                </div>
                            </div>
                            <Script>$(".goods-setup-box").hide()</Script>

                        </div>
                        <div class="crema-fit-product-combined-detail" data-product-code="${product.product_id}"></div>

                    </div>
                    <div class="goods-info-box">
                        <div class="info-box">
                            <div class="scroll-box">
                                <div class="tag">
                                   <!-- 성별 -->
                                    <p>
                                <c:choose>
                                    <%-- 여성 카테고리 대역일 때 --%>
                                    <c:when test="${product.category_id >= 1000 && product.category_id < 2000 || product.category_id == 10}">FEMALE</c:when>
                                    <%-- 남성 카테고리 대역일 때 --%>
                                    <c:when test="${product.category_id >= 2000 && product.category_id < 3000 || product.category_id == 20}">MALE</c:when>
                                    <c:when test="${product.category_id >= 3000 && product.category_id < 4000 || product.category_id == 30}">KIDS</c:when>
                                    <c:otherwise>FILA</c:otherwise>
                                </c:choose>
                            </p>
                                    <!-- 라이프스타일 -->
                                    <p>${styleTag}</p>
                                </div>

                                <p class="name">${product.name}</p>

                                <div class="price">
                                    <c:choose>
                                        <c:when test="${product.discount_rate > 0}">
                                            <p class="sale"><fmt:formatNumber value="${finalPrice}" pattern="#,###" />원</p>
                                            <p class="normal _sale"><fmt:formatNumber value="${product.price}" pattern="#,###" />원</p>
                                            <p class="percent">${product.discount_rate}% 할인</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="sale"><fmt:formatNumber value="${product.price}" pattern="#,###" />원</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="goods-desc">
                                    <p>${product.description}</p>
                                </div>
                                <div class="goods-material">
                                    <p>
                                        <b>상품코드</b> <br>${product.product_id}
                                    </p>
                                </div>
                                <div class="info-btn-box">
                                    <button type="button" class="goods-info__btn" data-no="61125">상품 정보 고시</button>
                                </div>
                                
                                <div class="share-box">
                                    <button type="button" class="share__btn" data-path="/product/view.asp?ProductNo=61125">share</button>
                                </div>
                            </div>
                        </div>
                        <div class="option-box">
                            <div class="scroll-box">

                                <div class="option-choice-box">
                                    <c:if test="${not empty sizeOption}">
                                        <div class="_size">
                                  <p class="tit">사이즈</p>
                                  <div class="size__slider swiper size">
                                      <ul class="swiper-wrapper">
                                          <c:forEach var="opt" items="${sizeOptions}" varStatus="st">
                                              <li class="swiper-slide">
                                                  <input type="radio" id="rdSize${st.index}" name="ProductSize" value="${opt.combinationId}" 
                                           class="rd__style ${opt.stock == 0 ? 'sold' : ''}" 
                                           ${opt.stock == 0 ? 'disabled' : ''}>
                                                  <label for="rdSize${st.index}">
                                                      ${opt.optionValue}
                                                  </label>
                                              </li>
                                          </c:forEach>
                                      </ul>
                                  </div>
                              </div>
                                    </c:if>

                                    <div class="_qty" id="vpop">
                                        <div class="qty-box">
                                            <button type="button" name="qtyMinus" id="qtyMinus" class="minus__btn">minus</button>
                                            <input type="number" name="ProductQuantity" id="ProductQuantity" value="1" readonly>
                                            <button type="button" name="qtyPlus" id="qtyPlus" class="plus__btn">plus</button>
                                        </div>
                                    </div>
                                    <div class="total-box">
                                        <dl>
                                            <dt>주문금액</dt>
                                            <dd id="buytotal"><fmt:formatNumber value="${finalPrice}" pattern="#,###" />원</dd>
                                        </dl>
                                    </div>
                                </div>
                                <div class="buy-btn-box">
								    <button type="button" class="buy__btn" onclick="goBuyNow();">바로 구매하기</button>
								
								    <div>
							            <%-- [WISH 추가] 로그인 상태면 add로, 아니면 login으로 --%>
										<%-- ✅ WISH: add/delete 베이스 URL (returnUrl은 JS에서 붙임) --%>
										<c:url var="wishAddUrl" value="/mypage/wish/add.htm">
										  <c:param name="product_id" value="${product.product_id}" />
										</c:url>
										
										<c:url var="wishDeleteUrl" value="/mypage/wish/deleteByProduct.htm">
										  <c:param name="product_id" value="${product.product_id}" />
										</c:url>
										
										<button type="button"
										        class="wish__btn${wished ? ' on' : ''}"
										        id="wishBtn"
										        data-wish="${param.product_id}"
										        onclick="goWishToggle(event);">
										  wish
										</button>
										
								        <button type="button" class="cart__btn" id="cartBtn" onclick="goCartAdd();">카트담기</button>
								    </div>
								</div>
                                <div class="lyr-btn-box">
                                    <a href="#" class="rv-ban-box">
                                        <img src="//filacdn.styleship.com/filacontent2/pc/resource/images/sub/review_event_d_banner_2506.jpg" alt="">
                                    </a>

                                    <div class="lyr__style1">
                                        <div class="toggle-menu-box">
                                            <button type="button" class="more__btn">신규회원 10,000원 할인 쿠폰 발급</button>
                                            <div class="toggle-con-box">
                                                <p>가입 시 즉시발급 / 50,000원 이상 구매 시 사용가능</p>
                                            </div>
                                        </div>
                                        <div>
                                            <button type="button" class="review-more__btn" onclick="openReviewModal()">
                                             상품 리뷰
                                             <span class="crema-product-reviews-count" data-product-code="${product.product_id}">
										        ${fn:length(reviewList)}
										    </span>
                                         	</button>
                                        </div>
                                        
                                        <div>
										    <button type="button" class="qna-more__btn" onclick="openQnaModal()">
										        상품 문의
										        <span class="qna-product-reviews-count" data-product-code="${product.product_id}">
										            ${not empty qnaList ? fn:length(qnaList) : 0}
										        </span>
										    </button>
										</div>
                                    </div>

                                    <div class="lyr__style2">
                                        <div><button type="button" class="delivery-info__btn" data-size="F" data-no="${product.product_id}">배송 정보</button></div>
                                        <div><button type="button" class="return-info__btn" data-size="F" data-no="${product.product_id}">교환 및 반품</button></div>
                                        <div><button type="button" class="clean-info__btn" data-size="F" data-no="${product.product_id}" data-text="101/1">세탁방법</button></div>
                                        <div><button type="button" class="as-info__btn" data-size="F" data-no="${product.product_id}">A/S</button></div>
                                    </div>
                                </div>
                                </div>
                        </div>
                        </div>
                    </div>
                    
                    <div class="goods-scroll-box _gs01">
                   <h2>이 상품을 본 고객이 함께 본 상품</h2>
               
                   <div class="slider-box">
                       <div class="goods__slider swiper">
                           <div class="swiper-wrapper" id="recopickProduct">
                               
                               <c:forEach var="item" items="${relatedList}">
                                   <div class="goods swiper-slide">
                                       <div class="photo">
                                           <div class="before">
                                               <a href="${pageContext.request.contextPath}/product/product_detail.htm?product_id=${item.product_id}">
                                                   <%-- 상품별 폴더 안의 1번 메인 이미지 호출 --%>
                                                   <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${item.product_id}/${item.product_id}_main_1.jpg" 
                                                        alt="${item.name}" 
                                                        onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
                                               </a>
                                           </div>
                                       </div>
               
                                       <div class="info">
                                           <a href="${pageContext.request.contextPath}/product/view.htm?product_id=${item.product_id}">
                                               <div class="top">
                                                   <p class="category">공용</p>
                                                   <div class="tag">
                                                       <%-- 상세페이지에서 가져온 styleTag 재사용 --%>
                                                       <p>${styleTag}</p>
                                                   </div>
                                               </div>
               
                                               <p class="name">${item.name}</p>
               
                                               <div class="price">
                                                   <%-- 할인가 계산 및 콤마 표시 --%>
                                                   <p class="sale">
                                                       <fmt:formatNumber value="${item.price * (100 - item.discount_rate) / 100}" type="number"/>원
                                                   </p>
                                                   <c:if test="${item.discount_rate > 0}">
                                                       <p class="normal _sale"><fmt:formatNumber value="${item.price}" type="number"/>원</p>
                                                       <p class="percent">${item.discount_rate}% 할인</p>
                                                   </c:if>
                                               </div>
                                           </a>
               
                                           <button type="button" class="wish__btn wish" data-wish="${item.product_id}">wish</button>
                                       </div>
                               
                                       <button type="button" class="cart__btn btn_sld__gr" onclick="wish_Cart_action('${item.product_id}');">장바구니 담기</button>
                                   </div>
                               </c:forEach>
               
                           </div>
                       </div>
               
                       <div class="scroll-bar-box">
                           <div class="goods-slider-scrollbar swiper-scrollbar-horizontal"></div>
                       </div>
                   </div>
               </div>
                    
            </section>
            
            <form name="qoptForm" id="qoptForm">
                <input type="hidden" name="answerVal2" id="answerVal2" value="">
                <input type="hidden" name="cateVal2" id="cateVal2" value="">
                <input type="hidden" name="myVal" id="myVal" value="0">
                <input type="hidden" name="pageVal2" id="pageVal2">
                <input type="hidden" name="pageSizeVal2" id="pageSizeVal2">
                <input type="hidden" name="qpno" id="qpno" value="61125">
                <input type="hidden" name="mchk" id="mchk" value="0">
            </form>
        </div>
        <div class="bot-fix-box">
            <div class="inner">
                <button type="button" class="today-goods__thumb today-goods__btn">
                    <img src="//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS254DJ01F001_561.jpg" alt="">
                </button>
                <button type="button" class="top__btn">top</button>        
            </div>
        </div>
        <jsp:include page="../common/footer.jsp" />
        <form name="form6" id="form6"  target="dataFrame"><input type="hidden" name="checkwish"><input type="hidden" name="ProductQuantity"></form>
        <iframe name="dataFrame" id="dataFrame" style="display:none;"></iframe>
    </div>

<script>
$(document).ready(function() {
    // 모델컷 슬라이더 설정
    if ($('.mc__slider').length > 0) {
        new Swiper('.mc__slider', {
            slidesPerView: 1,
            spaceBetween: 0,
            loop: ($('.mc__slider .swiper-slide').length > 1), // 슬라이드가 2장 이상일 때만 루프 실행
            pagination: {
                el: '.mc-swiper-pagination',
                clickable: true,
            },
            autoHeight: true,
            // 슬라이더가 처음엔 안 보였다가 나타날 때 크기를 다시 계산하게 해줌
            observer: true,
            observeParents: true
        });
    }
});
</script>

<script>
    // [리뷰 작성] 버튼 눌렀을 때 호출되는 함수
    function openReviewModal() {
       
        var modal = document.getElementById("reviewModal");
        if(modal) {
            modal.style.display = "block"; // 보이게 설정
            
            // (선택사항) 모달 열릴 때 스크롤 막기
            document.body.style.overflow = "hidden"; 
        } else {
            alert("모달창을 찾을 수 없습니다.");
        }
    }

    // [X] 버튼이나 배경 눌렀을 때 호출되는 함수
    function closeReviewModal() {
        var modal = document.getElementById("reviewModal");
        if(modal) {
            modal.style.display = "none"; // 안 보이게 설정
            
            // 스크롤 다시 풀기
            document.body.style.overflow = "auto";
        }
    }
</script>

<jsp:include page="/view/review/review_modal.jsp" />
<jsp:include page="/view/qna/qna_modal.jsp" />
<script>
    // [cart 관련 추가 4] 카트담기 클릭 처리
    // - 비로그인: 로그인 페이지로 (returnUrl 포함)
    // - 로그인: 장바구니 add로 (현재 수량 포함)
    
   function goCartAdd() {
    // 1. 사이즈 선택 체크
    var sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    if (!sizeChecked) {
        alert("사이즈를 선택해 주세요");
        return;
    }

    // 2. 로그인 체크 (생략 가능하면 유지)
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) {
        location.href = "${pageContext.request.contextPath}/user/login.jsp";
        return;
    }

    // 3. 값 추출
    var qty = document.getElementById("ProductQuantity").value;
    var combiId = sizeChecked.value; // 이제 여기엔 숫자가 들어있음

    // 4. URL 전송
    location.href = "${addCartBaseUrl}"
        + "&quantity=" + encodeURIComponent(qty)
        + "&combinationId=" + encodeURIComponent(combiId); // 파라미터명 변경 추천
}
</script>

<script>
document.addEventListener("DOMContentLoaded", function () {
  var minusBtn = document.getElementById("qtyMinus");
  var plusBtn  = document.getElementById("qtyPlus");
  var qtyInput = document.getElementById("ProductQuantity");
  var totalEl  = document.getElementById("buytotal");

  // 상품 1개 가격(숫자) - JSP에서 값 주입
  var unitPrice = ${finalPrice}; // 할인 적용된 1개 가격

  function renderTotal(qty) {
    if (!totalEl) return;
    var total = unitPrice * qty;
    totalEl.textContent = total.toLocaleString() + "원";
  }

  function getQty() {
    var v = parseInt(qtyInput.value, 10);
    return isNaN(v) || v < 1 ? 1 : v;
  }

  function setQty(v) {
    if (v < 1) v = 1;
    qtyInput.value = v;
    renderTotal(v);
  }

  if (minusBtn) {
    minusBtn.addEventListener("click", function () {
      setQty(getQty() - 1);
    });
  }

  if (plusBtn) {
    plusBtn.addEventListener("click", function () {
      setQty(getQty() + 1);
    });
  }

  // 첫 로드 시 주문금액 한번 맞춰주기
  setQty(getQty());
});
</script>

<script>
	window.addEventListener("pageshow", function(){
	  var btn = document.getElementById("wishBtn");
	  if(!btn) return;
	
	  // ✅ DB 결과(서버에서 내려준 wished)로 강제
	  var serverWished = ${wished ? "true" : "false"};
	  btn.classList.toggle("on", serverWished);
	});
</script>

<script>
function goBuyNow() {
    // 1. 선택된 사이즈(Combination ID) 가져오기
    var sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    if (!sizeChecked) {
        alert("사이즈를 선택해 주세요");
        return;
    }
    var combinationId = sizeChecked.value;

    // 2. 수량 가져오기 (ID 수정: ProductQuantity)
    var qtyInput = document.getElementById("ProductQuantity");
    var quantity = qtyInput ? qtyInput.value : 1;

    // 3. 로그인 체크
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) {
        alert("로그인이 필요한 서비스입니다.");
        // returnUrl을 포함하여 로그인 후 다시 이 페이지로 오게 설정하면 더 좋습니다.
        location.href = "${pageContext.request.contextPath}/login.htm?returnUrl=" + encodeURIComponent(location.href);
        return;
    }

    // 4. 결제 페이지로 이동
    var productId = "${product.product_id}"; 
    location.href = "${pageContext.request.contextPath}/order/orderForm.htm" 
                 + "?productId=" + productId 
                 + "&quantity=" + quantity 
                 + "&combinationId=" + combinationId;
}
</script>

<script>
(function(){
  // 버튼 상태를 BFCache/뒤로에서도 안정적으로 유지하려고 sessionStorage 사용
  var KEY = "wish_state_${product.product_id}"; // 상품별 키

  window.goWishAdd = function(){
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if(!isLogin){
      location.href = "${loginUrl}";
      return;
    }

    var btn = document.getElementById("wishBtn");
    if(!btn) return;

    var isOn = btn.classList.contains("on");
    var returnUrl = encodeURIComponent(location.pathname + location.search);

    if(isOn){
      // ✅ 즉시 UI 반영 (색 빠짐)
      btn.classList.remove("on");
      sessionStorage.setItem(KEY, "0"); // 내가 OFF 눌렀다고 기록
      location.href = "${wishDeleteUrl}" + "&returnUrl=" + returnUrl;
      return;
    }

    // 찜 추가는 사이즈 필요
    var sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    if(!sizeChecked){
      alert("사이즈를 선택해 주세요");
      return;
    }

    var label = document.querySelector('label[for="'+ sizeChecked.id +'"]');
    var sizeText = label ? label.textContent.trim() : "";

    // ✅ 즉시 UI 반영 (색 채움)
    btn.classList.add("on");
    sessionStorage.setItem(KEY, "1"); // 내가 ON 눌렀다고 기록
    location.href = "${wishAddUrl}"
      + "&returnUrl=" + returnUrl
      + "&sizeText=" + encodeURIComponent(sizeText);
  };

  // ✅ 뒤로가기/새로진입 시: 1) 서버가 내려준 wished(진짜 DB상태) 먼저 적용
  //                     2) 방금 내가 눌렀던 값(sessionStorage)이 있으면 그걸로 즉시 덮어씀
  window.addEventListener("pageshow", function(){
    var btn = document.getElementById("wishBtn");
    if(!btn) return;

    // 1) 서버 기준(DB) 상태
    var serverWished = ${wished ? "true" : "false"};
    btn.classList.toggle("on", serverWished);

    // 2) 방금 클릭한 UI 즉시 반영(redirect 전/후 BFCache 대비)
    var local = sessionStorage.getItem(KEY);
    if(local === "1") btn.classList.add("on");
    if(local === "0") btn.classList.remove("on");
  });

})();
</script>

<script>
	function goWishToggle(e) {
	  if (e) {
	    e.preventDefault();
	    e.stopPropagation();
	    // default.js 같은 다른 click 핸들러까지 싹 막기
	    if (e.stopImmediatePropagation) e.stopImmediatePropagation();
	  }
	
	  const btn = document.getElementById("wishBtn");
	  if (!btn) return;
	  
	  const productId = btn.dataset.wish;
	  
	// sizeText 추출
      const sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
      let sizeText = "";
      if (sizeChecked) {
          const label = document.querySelector('label[for="' + sizeChecked.id + '"]');
          sizeText = label ? label.textContent.trim() : "";
      }

      // 추가할 때만 사이즈 강제
      const isOn = btn.classList.contains("on");
      if (!isOn && !sizeChecked) {
          alert("사이즈를 선택해 주세요");
          return;
      }
	
	  const url = "${pageContext.request.contextPath}/wishlist/toggle.htm?product_id=" + encodeURIComponent(productId);
	
	  fetch(url, {
          method: "POST",
          headers: {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"},
          body: "product_id=" + encodeURIComponent(productId)
              + "&sizeText=" + encodeURIComponent(sizeText)
      })
      .then(async (res) => {
          const text = await res.text();
          if (!res.ok) throw new Error("HTTP " + res.status + " / " + text);
          return JSON.parse(text);
      })
      .then((data) => {
          if (data.wished === true) btn.classList.add("on");
          else btn.classList.remove("on");
      })
      .catch((err) => {
          console.error(err);
          alert("위시리스트 추가 실패\n" + err.message);
      });
	}
</script>

</body>
</c:if>
</html>