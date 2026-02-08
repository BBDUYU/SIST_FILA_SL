<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

    <input type="hidden" name="bnftNm" id="bnftNm" value="" />    
    <input type="hidden" name="bnftVal" id="bnftVal" value="" />        
    <input type="hidden" name="bnftDate" id="bnftDate" value="" />    
    <input type="hidden" name="bnftLimit" id="bnftLimit" value="" /> 
    
    <div id="wrap">
        
        <div id="contents" style="padding-top: 0px;" class="goods__contents">            
            <section class="goods-view-box">
                <h2 class="hidden">상품 상세</h2>

                <div class="sticky-box">
                    <div class="goods-detail-box">

                  <!-- 상세페이지 메인 이미지 -->
                  <div class="photo-list-box _style1">
                     <ul>
                       <c:forEach var="imgName" items="${mainImages}">
                              <li>
                               <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.productId}/${imgName}" 
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
                                           <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.productId}/${imgName}" alt="">
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
                                                     <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.productId}/${mImg}" alt="">
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
                                 <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.productId}/${dImg}" 
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
                        <div class="crema-fit-product-combined-detail" data-product-code="${product.productId}"></div>

                    </div>
                    <div class="goods-info-box">
                        <div class="info-box">
                            <div class="scroll-box">
                                <div class="tag">
                                   <!-- 성별 -->
                                    <p>
                                <c:choose>
                                    <%-- 여성 카테고리 대역일 때 --%>
                                    <c:when test="${product.categoryId >= 1000 && product.categoryId < 2000 || product.categoryId == 10}">FEMALE</c:when>
                                    <%-- 남성 카테고리 대역일 때 --%>
                                    <c:when test="${product.categoryId >= 2000 && product.categoryId < 3000 || product.categoryId == 20}">MALE</c:when>
                                     <c:when test="${product.categoryId >= 3000 && product.categoryId < 4000 || product.categoryId == 30}">KIDS</c:when>
                                    <c:otherwise>FILA</c:otherwise>
                                </c:choose>
                            </p>
                                    <!-- 라이프스타일 -->
                                    <p>${styleTag}</p>
                                </div>

                                <p class="name">${product.name}</p>

                                <div class="price">
                                    <c:choose>
                                        <c:when test="${product.discountRate > 0}">
                                             <p class="sale"><fmt:formatNumber value="${finalPrice}" pattern="#,###" />원</p>
                                             <p class="normal _sale"><fmt:formatNumber value="${product.price}" pattern="#,###" />원</p>
                                             <p class="percent">${product.discountRate}% 할인</p>
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
                                        <b>상품코드</b> <br>${product.productId}
                                    </p>
                                </div>
                                <div class="info-btn-box">
                                    <button type="button" class="goods-info__btn" data-no="61125">상품 정보 고시</button>
                                </div>
                                
                                <div class="share-box">
                                    <button type="button" class="share__btn"data-path="/product/detail.htm?productId=${product.productId}">share</button>
                                </div>
                            </div>
                        </div>
                        <div class="option-box">
                            <div class="scroll-box">

                                <div class="option-choice-box">
                                    <c:if test="${not empty sizeOptions}">
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
								    
								    	<c:set var="pid"
										       value="${not empty product.productId
										               ? product.productId
										               : (not empty param.productId ? param.productId : param.product_id)}" />
										
										<c:set var="wished"
										       value="${wishedSet != null && wishedSet.contains(pid)}" />
						
							            <%-- [WISH 추가] 로그인 상태면 add로, 아니면 login으로 --%>
										<%-- ✅ WISH: add/delete 베이스 URL (returnUrl은 JS에서 붙임) --%>
										<c:url var="wishAddUrl" value="/mypage/wish/add.htm">
										  <c:param name="productId" value="${pid}" />
										</c:url>
										
										<c:url var="wishDeleteUrl" value="/mypage/wish/deleteByProduct.htm">
										  <c:param name="productId" value="${pid}" />
										</c:url>
										
										<button type="button"
										        class="wish__btn${wished ? ' on' : ''}"
										        id="wishBtn"
										        data-wish="${pid}"
										        data-wished="${wished}" 
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
    <span id="totalReviewCnt" class="crema-product-reviews-count" data-product-code="${product.productId}">
        ${fn:length(reviewList)}
    </span>
</button>
                                        </div>
                                        
                                        <div>
										    <button type="button" class="qna-more__btn" onclick="openQnaModal()">
										        상품 문의
										        <span class="qna-product-reviews-count" data-product-code="${product.productId}">
                                                    ${not empty qnaList ? fn:length(qnaList) : 0}
                                                </span>
										    </button>
										</div>
                                    </div>

                                    <div class="lyr__style2">
                                        <div><button type="button" class="delivery-info__btn" data-size="F" data-no="${product.productId}">배송 정보</button></div>
                                        <div><button type="button" class="return-info__btn" data-size="F" data-no="${product.productId}">교환 및 반품</button></div>
                                        <div><button type="button" class="clean-info__btn" data-size="F" data-no="${product.productId}" data-text="101/1">세탁방법</button></div>
                                        <div><button type="button" class="as-info__btn" data-size="F" data-no="${product.productId}">A/S</button></div>
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
                                               <a href="${pageContext.request.contextPath}/product/detail.htm?productId=${item.productId}">
                                                   <%-- 상품별 폴더 안의 1번 메인 이미지 호출 --%>
                                                   <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${item.productId}/${item.productId}_main_1.jpg" 
													     alt="${item.name}" 
													     onerror="this.onerror=null; this.style.display='none';">
                                               </a>
                                           </div>
                                       </div>
               
                                       <div class="info">
                                           <a href="${pageContext.request.contextPath}/product/detail.htm?productId=${item.productId}">
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
                                                        <fmt:formatNumber value="${item.price * (100 - item.discountRate) / 100}" type="number"/>원
                                                    </p>
                                                   <c:if test="${item.discountRate > 0}">
                                                       <p class="normal _sale"><fmt:formatNumber value="${item.price}" type="number"/>원</p>
                                                       <p class="percent">${item.discountRate}% 할인</p>
                                                   </c:if>
                                               </div>
                                           </a>
               
                                           <button type="button" class="wish__btn wish" data-wish="${item.productId}">wish</button>
                                       </div>
                               
                                       <button type="button" class="cart__btn btn_sld__gr" onclick="wish_Cart_action('${item.productId}');">장바구니 담기</button>
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
        <form name="form6" id="form6"  target="dataFrame"><input type="hidden" name="checkwish"><input type="hidden" name="ProductQuantity"></form>
        <iframe name="dataFrame" id="dataFrame" style="display:none;"></iframe>
    </div>