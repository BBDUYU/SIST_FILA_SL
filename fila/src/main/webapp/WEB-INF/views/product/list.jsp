<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

   <!-- start of :: wrap -->
   <div id="wrap" style="padding-top: 120px;">
      <!-- header include -->
      
      
      <section class="goods-list-box _thumb04">
                <h2 class="hidden">상품 리스트</h2>
                
                <div class="head">
                    <div class="tit-box">
					    <p class="tit" style="white-space: nowrap;">
					        <c:if test="${not empty mainTitle}">
					            ${mainTitle} <b>&gt;</b>
					        </c:if>
					        <e>
					            <c:choose>
					                <%-- 현재 카테고리 ID가 부모 ID와 같거나 0이면 '전체' 출력 --%>
					                <c:when test="${currentCateId eq sidebarParentId || currentCateId eq 0}">
					                    전체
					                </c:when>
					                <%-- 그 외의 경우에만 기존 subTitle(NewFeatured 등) 출력 --%>
					                <c:otherwise>
					                    ${subTitle}
					                </c:otherwise>
					            </c:choose>
					        </e>
					    </p>
					</div>
                    <div class="sorting-box">
                   <div>
                       <button type="button" class="filter__btn">필터</button>
                       <button type="button" class="filter-reset__btn" id="resetB" onclick="filterReset();$(this).hide();" style="display:none;">필터 초기화</button>
               
                       <div>
                           <button type="button" class="comparison__btn">비교</button>
                           <div class="lyr-box">
                               <button type="button" class="lyr-comparison__btn">
                                   <%-- 선택된 비교 상품 개수를 동적으로 표시 (기본값 0) --%>
                                   <span id="compareCnt">0</span>개 비교하기
                               </button>
                               <button type="button" class="comparison-close__btn">close</button>
                           </div>
                       </div>
                   </div>
               
                   <div>
                       <%-- 정렬 기준 유지 로직 추가 --%>
                       <select onchange="changeSort(this.value);">
                           <option value="1" ${param.sort eq '1' ? 'selected' : ''}>신상품순</option>
                           <option value="4" ${param.sort eq '4' ? 'selected' : ''}>판매순</option>
                           <option value="7" ${param.sort eq '7' ? 'selected' : ''}>리뷰순</option>
                           <option value="2" ${param.sort eq '2' ? 'selected' : ''}>낮은가격순</option>
                           <option value="3" ${param.sort eq '3' ? 'selected' : ''}>높은가격순</option>
                       </select>
               
                       <div class="col-box">
                           <%-- 현재 단수(3단/4단)에 따라 active 클래스 추가 --%>
                           <button type="button" class="col3__btn ${cookie.displayCol.value eq '3' ? 'active' : ''}" onclick="changeCol(3)">3단</button>
                           <button type="button" class="col4__btn ${cookie.displayCol.value eq '4' ? 'active' : ''}" onclick="changeCol(4)">4단</button>
                       </div>
                   </div>
               </div>
                </div>

                <div class="con">
                    <div class="filter-box">
                        <div class="category-box">
                            <ul>
                               <li class="${ currentCateId eq 0 || currentCateId eq sidebarParentId ? 'on' : '' }">
                            <a href="${pageContext.request.contextPath}/product/list.htm?category=${sidebarParentId > 0 ? sidebarParentId : currentCateId}"
                               <c:if test="${ currentCateId eq 0 || currentCateId eq sidebarParentId }">
                                   data-num="${totalSidebarCount}"
                               </c:if>>
                                전체
                            </a>
                        </li>
                               
                                <c:forEach items="${sidebarList}" var="side">
                            <li class="${ currentCateId eq side.category_id ? 'on' : '' }">
                                <a href="${pageContext.request.contextPath}/product/list.htm?category=${side.category_id}" 
                                   <c:if test="${ currentCateId eq side.category_id }">
                                       data-num="${side.product_count}"
                                   </c:if>>
                                    ${side.name} 
                                </a>
                            </li>
                        </c:forEach>
                            </ul>
                        </div>
                    </div>

                    <div class="list-box">
                        <ul class="goods__list _type_v2" id="product_list">
                            <c:if test="${empty productList}">
                                <div style="width:100%; padding:50px; text-align:center; font-size:16px;">
                                    등록된 상품이 없습니다.<br>
                                    (DB에 상품은 있지만 이미지가 없어서 그럴 수 있습니다.)
                                </div>
                            </c:if>

                            <c:forEach var="item" items="${productList}">
                                <c:set var="finalPrice" value="${item.price * (100 - item.discount_rate) / 100}" />
                                
                                <li class="goods">
                                    <div class="photo">
                                        <a href="${pageContext.request.contextPath}/product/product_detail.htm?product_id=${item.product_id}">
                                            <img src="${item.image_url}" alt="${item.name}">
                                        </a>
                                        <button type="button"
										        class="wish__btn wish${not empty wishedSet and wishedSet.contains(item.product_id) ? ' on' : ''}"
										        data-wish="${item.product_id}"
										        onclick="return wishToggleFromList(event, this);">
										  wish
										</button>
                                    </div>
                                    <div class="info">
									    <a href="${pageContext.request.contextPath}/product/product_detail.htm?product_id=${item.product_id}">
									        <div class="top">
									            <%-- DEPTH 1 이름 (FEMALE 등) --%>
									            <p class="category">${item.depth1_name}</p>
									        
									            <div class="tag">
									                <c:if test="${not empty item.tag_name}">
									                    <p>${item.tag_name}</p>
									                </c:if>
									            </div>											
									        </div>
									
									        <p class="name">${item.name}</p>
									
									        <div class="price">
									            <c:choose>
									                <c:when test="${item.discount_rate > 0}">
									                    <p class="sale">
									                        <fmt:formatNumber value="${item.price * (1 - item.discount_rate/100.0)}" pattern="#,###" />원
									                    </p>
									                    <p class="normal _sale"><fmt:formatNumber value="${item.price}" pattern="#,###" />원</p>
									                    <p class="percent">${item.discount_rate}%</p>
									                </c:when>
									                <c:otherwise>
									                    <p class="sale"><fmt:formatNumber value="${item.price}" pattern="#,###" />원</p>
									                </c:otherwise>
									            </c:choose>
									        </div>
									
									        <div class="bot" style="display: flex; gap: 10px; margin-top: 10px; font-size: 12px; color: #888;">
									            <div>
									                <%-- 찜 개수 아이콘 추가 --%>
									                <p class="ico-heart" style="display: flex; align-items: center;">
									                    <span style="margin-right:3px;"></span> ${item.like_count}
									                </p>
									            </div>
									            <div>
									                <%-- 리뷰 평점 아이콘 추가 및 포맷팅 --%>
									                <p class="ico-star" style="display: flex; align-items: center;">
									                    <span style="color: #ffc107; margin-right:3px;"></span> 
									                    <fmt:formatNumber value="${item.review_score}" pattern="0.0" /> (${item.review_count})
									                </p>
									            </div>
									        </div>
									    </a>									
									</div>
                                </li>
                            </c:forEach>
                        </ul>
                        
                        <div class="paging-box">
                            <div class="paging-num"><a href="#" class="pg on">1</a></div>
                        </div>
                    </div>
                </div>
            </section>
      
         
         <!-- 추천 상품 -->
         <section class="goods-scroll-box _type_v2 _gs01">
                <div class="hd"><h2>고객님을 위한 추천 상품</h2></div>
                <div class="slider-box">
                    <div class="goods__slider swiper">
                        <div class="swiper-wrapper">
                            <c:forEach var="item" items="${productList}">
                                <div class="goods swiper-slide">
                                    <div class="photo">
                                        <div class="before">
                                            <a href="${pageContext.request.contextPath}/product/product_detail.htm?product_id=${item.product_id}">
                                                <img src="${item.image_url}" alt="${item.name}">
                                            </a>
                                        </div>
                                        <%-- 추천상품에도 찜 버튼 + on 표시 --%>
                                        <button type="button"
							                      class="wish__btn wish${wishedSet.contains(item.product_id) ? ' on' : ''}"
							                      data-wish="${item.product_id}"
							                      onclick="return wishToggleFromList(event, this);">
							                wish
							              </button>
                                    </div>
                                    <div class="info">
                                        <a href="${pageContext.request.contextPath}/product/product_detail.htm?product_id=${item.product_id}">
                                            <div class="top"><p class="category">추천</p></div>
                                            <p class="name">${item.name}</p>
                                            <div class="price">
                                                <p class="sale"><fmt:formatNumber value="${item.price}" pattern="#,###" />원</p>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="goods-slider-scrollbar swiper-scrollbar-horizontal"></div>
                    </div>
                </div>              
            </section>
         <!-- //추천 상품 -->

      </div>
      <!-- // end of :: contents -->



      <!-- 하단 고정 버튼 (top, sns) -->
<div class="bot-fix-box"> 
    <div class="inner">
        <button type="button" class="today-goods__btn" onclick="alert('준비중입니다')">
            <svg id="btn_time" xmlns="http://www.w3.org/2000/svg" width="29" height="29" viewBox="0 0 29 29">
              <g id="icon" transform="translate(-0.025 -0.025)">
                <path id="패스_706" data-name="패스 706" d="M17.05,24.66A14,14,0,1,0,19.5,9.572l.253-3.648" transform="translate(-15.29 -4.475)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1"></path>
                <path id="패스_707" data-name="패스 707" d="M6.537,83.1a14.542,14.542,0,0,0-.3,12.37" transform="translate(-4.475 -75.062)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1" stroke-dasharray="40 40"></path>
                <path id="패스_708" data-name="패스 708" d="M114.512,80.167v6.806l-3.662,3.662" transform="translate(-99.914 -72.362)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"></path>
                <line id="선_542" data-name="선 542" x1="3.654" transform="translate(4.307 5.263)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1"></line>
              </g>
            </svg>
        </button>
        <button type="button" class="top__btn" onclick="window.scrollTo({top:0, behavior:'smooth'})">top</button>        
    </div>
</div>