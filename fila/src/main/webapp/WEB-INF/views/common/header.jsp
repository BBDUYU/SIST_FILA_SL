<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<link rel="icon" type="image/x-icon" href="//filacdn.styleship.com/filacontent2/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/SpoqaHanSansNeo.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/normalize.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/opt-default.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/swiper-bundle.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/product.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sub.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />

<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/TweenMax.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>
<script src="${pageContext.request.contextPath}/js/mighty.base.1.5.7.js"></script>
<script src="${pageContext.request.contextPath}/js/matiz.js"></script>
<script src="${pageContext.request.contextPath}/js/swiper-bundle.js"></script>
<script src="${pageContext.request.contextPath}/js/default.js?v=202504161631"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
	jQuery(window.document).ready(function(){
		jQuery(window.document).on("contextmenu", function(event){return false;});
	});  
	</script>
<script>
    $(document).ready(function() {
        // GNB 메뉴 호버 효과
        $('#header nav').on('mouseover', 'li', function() { $('body').addClass('_bg_on'); });
        $('#header nav').on('mouseout', 'li', function() { $('body').removeClass('_bg_on'); });

        // 검색 레이어 열기 및 내부 스위퍼 초기화
        $(document).on('click', '.search-open__btn', function () {
            $('body').addClass('search--open');
            setTimeout(function () {
                new Swiper('.goods__slider', {
                    slidesPerView: 'auto',
                    freeMode: true,
                    scrollbar: { el: '.goods-slider-scrollbar', draggable: true }
                });
            }, 300);
        });

        // 검색 레이어 닫기
        $(document).on('click', '.cancel__btn, .search-input-box .close__btn, .search-bg__wrap', function () {
            $('body').removeClass('search--open');
        });
    });

 // 쿠키 저장 함수 추가
    function setRecentSearchCookie(keyword) {
        let name = "recentSearch";
        let expires = "";
        let date = new Date();
        date.setTime(date.getTime() + (24 * 60 * 60 * 1000 * 7)); // 7일 유지
        expires = "; expires=" + date.toUTCString();

        // 기존 쿠키 가져오기
        let cookieValue = "";
        let decodedCookie = decodeURIComponent(document.cookie);
        let ca = decodedCookie.split(';');
        for(let i = 0; i < ca.length; i++) {
            let c = ca[i].trim();
            if (c.indexOf(name + "=") == 0) cookieValue = c.substring((name + "=").length, c.length);
        }

        let searchList = cookieValue ? cookieValue.split(',') : [];
        
        // 중복 제거 및 최신 검색어 맨 앞으로
        searchList = searchList.filter(item => item !== keyword);
        searchList.unshift(keyword);
        
        // 최대 5개까지만 유지
        if (searchList.length > 5) searchList.pop();

        // 쿠키 저장 (콤마로 구분)
        document.cookie = name + "=" + encodeURIComponent(searchList.join(',')) + expires + "; path=/";
    }

    function searchRun2() {
        const searchItem = $("#searchItem2").val().trim();
        if (!searchItem) { alert("검색어를 입력해주세요."); return false; }

        // 1. 최근 검색어 쿠키 저장 (추가된 부분)
        setRecentSearchCookie(searchItem);

        // 2. DB 저장 AJAX (기존 로직)
        $.get("${pageContext.request.contextPath}/search/record.htm", { keyword: searchItem });

        // 3. 페이지 이동
        location.href = "${pageContext.request.contextPath}/product/list.htm?searchItem=" + encodeURIComponent(searchItem);
        return false;
    }
    function wordRemoveAll() {
        if(confirm("최근 검색어를 모두 삭제하시겠습니까?")) {
            // 쿠키 만료 날짜를 과거로 설정하여 삭제
            document.cookie = "recentSearch=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            $("#sWordHistory").html('<li class="no_search_list">최근 검색어가 없습니다.</li>');
        }
    }
</script>

<header id="header">
    <h1 class="logo">
        <a href="${pageContext.request.contextPath}/index.htm">FILA</a>
    </h1>

    <nav class="gnb">
        <ul class="gnb">
            <c:forEach items="${list}" var="d1">
                <c:if test="${d1.depth eq 1}">
                    <li>
                        <a href="${pageContext.request.contextPath}/product/list.htm?category=${d1.categoryId}">${d1.name}</a>
                        <div class="depth2-box">
                            <div class="inner">
                                <div class="category-menu-box">
                                    <c:forEach items="${list}" var="d2">
                                        <c:if test="${d2.depth eq 2 && d2.parentId eq d1.categoryId}">
                                            <div class="category-group">
                                                <a href="${pageContext.request.contextPath}/product/list.htm?category=${d2.categoryId}" class="link-tit">${d2.name}</a>
                                                <div>
                                                    <ul>
                                                        <li><a href="${pageContext.request.contextPath}/product/list.htm?category=${d2.categoryId}">전체보기</a></li>
                                                        <c:forEach items="${list}" var="d3">
                                                            <c:if test="${d3.depth eq 3 && d3.parentId eq d2.categoryId}">
                                                                <li><a href="${pageContext.request.contextPath}/product/list.htm?category=${d3.categoryId}">${d3.name}</a></li>
                                                            </c:if>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        <div class="gnb-bg__wrap"></div>
                    </li>
                </c:if>
            </c:forEach>
        </ul>
    </nav>

    <div class="util">
        <div class="util-store">
		    <a href="${pageContext.request.contextPath}/noticeList.htm" class="store__btn">
		        store
		    </a>
		</div>

        <div class="util-search">
            <button type="button" class="search-open__btn">search</button>
            <form action="${pageContext.request.contextPath}/product/list.htm" name="searchForm2" method="get" onsubmit="searchRun2(); return false;">
                <div class="search__layer">
                    <div class="head">
                        <div class="search-category-box">
                            <div>
                                <button type="button" class="on searchCate">전체</button>
                                <button type="button">WOMEN</button>
                                <button type="button">MEN</button>
                                <button type="button">KIDS</button>
                            </div>
                        </div>
                        <div class="search-input-box">
                            <div>
                                <button type="button" class="close__btn"></button>
                                <input type="search" placeholder="검색어 입력" name="searchItem" id="searchItem2">
                                <button type="button" class="search__btn" onclick="searchRun2();">search</button>
                            </div>
                            <button type="button" class="cancel__btn">취소</button>
                        </div>
                    </div>

                    <div class="con">
                        <div class="inner">
                            <div class="keywords-box _recommend">
                                <div>
                                    <p class="tit">최근 검색어</p>
                                    <button type="button" class="all-delete__btn" onclick="wordRemoveAll();">전체 기록 삭제</button>
                                </div>
                                <div>
                                    <%
                                        String recentSearch = "";
                                        javax.servlet.http.Cookie[] cookies = request.getCookies();
                                        if (cookies != null) {
                                            for (javax.servlet.http.Cookie c : cookies) {
                                                if ("recentSearch".equals(c.getName())) {
                                                    recentSearch = java.net.URLDecoder.decode(c.getValue(), "UTF-8");
                                                    break;
                                                }
                                            }
                                        }
                                        request.setAttribute("recentSearch", recentSearch);
                                    %>
                                    <ul class="latest__list" id="sWordHistory">
                                        <c:choose>
                                            <c:when test="${not empty recentSearch}">
                                                <c:forEach var="word" items="${fn:split(recentSearch, ',')}">
                                                    <li data-sword="${word}">
                                                        <a href="${pageContext.request.contextPath}/product/list.htm?searchItem=${fn:escapeXml(word)}">${word}</a>
                                                        <button type="button" class="delete__btn sWordRemove btn_remove">delete</button>
                                                    </li>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise><li class="no_search_list">최근 검색어가 없습니다.</li></c:otherwise>
                                        </c:choose>
                                    </ul>
                                </div>
                            </div>

                            <div class="keywords-box _popular">
                                <div><p class="tit">인기 검색어</p></div>
                                <div>
                                    <ul>
                                        <c:choose>
                                            <c:when test="${not empty popularKeywords}">
                                                <c:forEach var="sDto" items="${popularKeywords}">
                                                    <li><a href="${pageContext.request.contextPath}/product/list.htm?searchItem=${fn:escapeXml(sDto.keyword)}">${sDto.keyword}</a></li>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise><li>검색 기록이 없습니다.</li></c:otherwise>
                                        </c:choose>
                                    </ul>
                                </div>
                            </div>

                            <div class="keywords-box _recommend">
                                <div><p class="tit">추천 검색어</p></div>
                                <div>
                                    <ul>
                                        <c:choose>
                                            <c:when test="${not empty recommendKeywords}">
                                                <c:forEach var="rDto" items="${recommendKeywords}">
                                                    <li>
                                                        <c:choose>
                                                            <c:when test="${not empty rDto.productId}">
                                                                <a href="${pageContext.request.contextPath}/product/product_detail.htm?id=${rDto.productId}">${rDto.name}</a>
                                                            </c:when>
                                                            <c:when test="${not empty rDto.slug}">
                                                                <a href="${pageContext.request.contextPath}/event/event.htm?slug=${rDto.slug}">${rDto.eventName}</a>
                                                            </c:when>
                                                        </c:choose>
                                                    </li>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise><li>추천 검색어가 없습니다.</li></c:otherwise>
                                        </c:choose>
                                    </ul>
                                </div>
                            </div>

                            <div class="keywords-box _recommend_goods">
                                <div><p class="tit">추천상품</p></div>
                                <div>
                                    <div class="goods-scroll-box _type_v2">
                                        <div class="slider-box">
                                            <div class="goods__slider swiper">
                                                <div class="swiper-wrapper" id="headerProduct">
                                                    <c:choose>
                                                        <c:when test="${not empty recommendProducts}">
                                                            <c:forEach var="pDto" items="${recommendProducts}" varStatus="status">
                                                                <div class="goods swiper-slide">
                                                                    <div class="photo">
                                                                        <a href="${pageContext.request.contextPath}/product/product_detail.htm?product_id=${pDto.productId}">
                                                                            <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${pDto.productId}/${pDto.productId}_main_1.jpg" alt="${pDto.name}">
                                                                        </a>
                                                                    </div>
                                                                    <div class="info">
                                                                        <a href="${pageContext.request.contextPath}/product/product_detail.htm?product_id=${pDto.productId}">
                                                                            <p class="category">RECOMMEND</p>
                                                                            <p class="name">${pDto.name}</p>
                                                                            <div class="price">
                                                                                <p class="sale"><fmt:formatNumber value="${pDto.price * (100 - pDto.discountRate) / 100}" type="number" />원</p>
                                                                            </div>
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise><div class="swiper-slide">추천 상품이 없습니다.</div></c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="goods-slider-scrollbar swiper-scrollbar"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div> </div> </div> </form>
            <div class="search-bg__wrap"></div>
        </div>

        <div class="util-account">
            <button type="button" class="account__btn" onclick="location.href='${pageContext.request.contextPath}/mypage/orders.htm'">account</button>
            <div class="account__layer">
                <div class="inner">
                    <c:choose>
                        <%-- 1. 비로그인 상태 --%>
                        <c:when test="${empty auth}">
                            <div class="account-menu-box">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/member/login.htm">로그인</a></li>
                                   <li><a href="${pageContext.request.contextPath}/member/joinMain.htm">회원가입</a></li>



                                    
                                    <%-- <li><a href="${pageContext.request.contextPath}/mypage.htm">마이페이지</a></li>
                                    <li><a href="${pageContext.request.contextPath}/mypageOrder.htm">주문/배송</a></li>
                                    <li><a href="${pageContext.request.contextPath}/inquiry/list.htm">1:1 문의</a></li>
                                    <li><a href="${pageContext.request.contextPath}/mypageWishlist.htm">위시리스트</a></li> --%>

                                                          
                                    <li><a href="<%=request.getContextPath()%>/view/user/SearchIdPw.jsp"> 아이디 / 비밀번호 찾기</a></li>
                                    <li><a href="#">이벤트</a></li>

                                </ul>
                            </div>
                        </c:when>

                        <%-- 2. 로그인 상태 --%>
                        <c:otherwise>
                            <c:choose>
                                <%-- 2-1. 관리자 --%>
                                <c:when test="${fn:contains(auth.id, 'admin')}">
                                    <div class="account-menu-box">
                                        <ul>
                                            <li><a href="${pageContext.request.contextPath}/admin/userList.htm">관리자 페이지</a></li>
                                        </ul>
                                        <button type="button" class="logout__btn" onclick="location.href='${pageContext.request.contextPath}/logout.htm';">로그아웃</button>
                                    </div>
                                </c:when>
                                <%-- 2-2. 일반 회원 --%>
                                <c:otherwise>
                                    <div class="account-info-box">
                                        <div class="user-txt"><p class="name">${auth.name}님</p><p class="level">WHITE</p></div>
                                        <div class="benefit-txt"><p class="percent">2% 적립</p><a href="/customer/membership.asp">자세히 보기</a></div>
                                    </div>
                                    <div class="account-menu-box">
                                        <ul>
                                            <li><a href="${pageContext.request.contextPath}/mypage/orders.htm">마이페이지</a></li>
                                            <li><a href="${pageContext.request.contextPath}/mypage/orders.htm">주문/배송</a></li>
                                            <li><a href="${pageContext.request.contextPath}/review/list.htm">1:1 문의</a></li>
                                            <li><a href="${pageContext.request.contextPath}/mypage/wishlist.htm">위시리스트</a></li>
                                            <li><a href="${pageContext.request.contextPath}/mypage/mycoupon.htm">쿠폰</a></li>
                                            <li><a href="${pageContext.request.contextPath}/mypage/mypoint.htm">포인트</a></li>
                                        </ul>
                                        <button type="button" class="logout__btn" onclick="location.href='${pageContext.request.contextPath}/logout.htm';">로그아웃</button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="util-cart">
            <button type="button" class="cart__btn" id="cart_cnt" onclick="location.href='${pageContext.request.contextPath}/pay/cart.htm';">cart</button>
        </div>
    </div>
</header>