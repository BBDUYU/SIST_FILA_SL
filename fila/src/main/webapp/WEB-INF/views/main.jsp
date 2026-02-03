<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div id="wrap">


		<div id="contents" class="main__contents">


			<!-- 상단 슬라이드 -->
			<section class="main-slider-box _main_slider">
				<h2 class="hidden">상단 슬라이드</h2>

				<div
					class="main__slider swiper swiper-initialized swiper-horizontal swiper-pointer-events">

					<%-- 바깥쪽 div 하나만 남기고 합칩니다. id나 style은 Swiper가 실행되면서 자동으로 붙여주니 클래스명만 잘 적으시면 됩니다. --%>
					<div class="swiper-wrapper">
						<c:forEach var="dto" items="${bannerList}" varStatus="status"
							end="7">
							<c:set var="isVideo" value="${fn:endsWith(dto.imageUrl, '.mp4')}" />

							<div class="swiper-slide ${isVideo ? '_type_vdo' : ''}">
								<a
									href="#"
									target="_self">
									<div class="vdo-box">
										<c:choose>
											<c:when test="${isVideo}">
												<video autoplay muted loop playsinline>
													<source
														src="${pageContext.request.contextPath}${dto.imageUrl}"
														type="video/mp4">
												</video>
											</c:when>
											<c:otherwise>
												<img src="${pageContext.request.contextPath}${dto.imageUrl}"
													alt="${dto.bannerName}">
											</c:otherwise>
										</c:choose>
									</div>

									<div class="txt-box _type_wt">
										<p class="tit">${dto.bannerName}</p>
										<p class="more">자세히 보기</p>
									</div>
								</a>
							</div>

						</c:forEach>
					</div>
					<span class="swiper-notification" aria-live="assertive"
						aria-atomic="true"></span>
				</div>

				<div class="scroll-bar-box _type_arrows">
					<!--<div class="main-slider-scrollbar"></div>-->
					<div
						class="main-slider-pagination swiper-pagination-clickable swiper-pagination-bullets swiper-pagination-horizontal"
						data-total-num="0" data-curr-num="1">
						<span
							class="swiper-pagination-bullet swiper-pagination-bullet-active"
							tabindex="0" role="button" aria-label="Go to slide 1"
							aria-current="true"></span><span class="swiper-pagination-bullet"
							tabindex="0" role="button" aria-label="Go to slide 2"></span><span
							class="swiper-pagination-bullet" tabindex="0" role="button"
							aria-label="Go to slide 3"></span><span
							class="swiper-pagination-bullet" tabindex="0" role="button"
							aria-label="Go to slide 4"></span><span
							class="swiper-pagination-bullet" tabindex="0" role="button"
							aria-label="Go to slide 5"></span><span
							class="swiper-pagination-bullet" tabindex="0" role="button"
							aria-label="Go to slide 6"></span><span
							class="swiper-pagination-bullet" tabindex="0" role="button"
							aria-label="Go to slide 7"></span><span
							class="swiper-pagination-bullet" tabindex="0" role="button"
							aria-label="Go to slide 8"></span>
					</div>
					<div class="pagination-curr-bar">
						<div style="width: 12.5%; left: 0%;"></div>
					</div>

					<div class="arrow-box">
						<button type="button" class="prev__btn" tabindex="0"
							aria-label="Previous slide"
							aria-controls="swiper-wrapper-2b66d35d4a56af48">prev</button>
						<button type="button" class="next__btn" tabindex="0"
							aria-label="Next slide"
							aria-controls="swiper-wrapper-2b66d35d4a56af48">next</button>
					</div>
				</div>
			</section>
			<!-- //상단 슬라이드 -->
			
			<script>
			  // 서버에서 내려준 wishedSet(Set<String>)을 JS 배열로 변환, wishlist 하트버튼
			  const WISHED = new Set([
			    <c:forEach var="pid" items="${wishedSet}" varStatus="st">
			      "${pid}"<c:if test="${!st.last}">,</c:if>
			    </c:forEach>
			  ]);
			</script>
			
			<script>
				function mainGroup(num) {
					var formStr = "";
					randNo = Math.floor((Math.random() * (999999 - 1 + 1)) + 1);
					jQuery
							.ajax({
								type : "POST",
								data : "num=" + num + "&random=" + randNo,
								url : "/pc/main/main_group.asp",
								dataType : "HTML",
								success : function(data) {
									formStr = data;
									jQuery(".groupBtn").removeClass("on");
									jQuery(".q" + num + "p").addClass("on");
									jQuery("#groupList").hide().empty()
											.fadeIn().append(data);

									setTimeout(
											function() {
												try {
													var mySwiper = document
															.querySelector('.goods__slider').swiper;
													mySwiper.slideTo(0, 0,
															false);
												} catch (e) {
												}
											}, 100);
								},
								error : function(e) {
									//alert("e");
								}
							});
				}
			</script>

			<!-- 상품 리스트 스크롤 -->
			<section class="goods-scroll-box _gs01">
			    <h2>지금 많이 찾는 상품</h2>
			
			    <div class="category-btn-box">
			        <%-- 활성화된 태그 목록을 순회하며 버튼 생성 --%>
			        <c:forEach var="tag" items="${activeTags}" varStatus="status">
			            <button type="button" 
			                    class="groupBtn q${tag.categoryId}p ${status.first ? 'on' : ''}"
			                    onclick="mainGroup(${tag.categoryId}, this);">
			                # ${tag.name}
			            </button>
			        </c:forEach>
			    </div>
			
			    <script>
			        <%-- 페이지 로드 시 첫 번째 태그의 상품을 자동으로 불러옴 --%>
			        <c:if test="${not empty activeTags}">
			            window.onload = function() {
			                mainGroup(${activeTags[0].categoryId}, document.querySelector('.groupBtn.on'));
			            };
			        </c:if>
			    </script>
			
			    <div class="slider-box">
			        <div class="goods__slider swiper">
			            <%-- AJAX 데이터가 들어갈 공간 --%>
			            <div class="swiper-wrapper" id="groupList">
			                <%-- 여기에 자바스크립트로 생성한 HTML이 삽입됩니다 --%>
			            </div>
			        </div>
			    </div>
			</section>
<script>
function mainGroup(tagId, element) {
    console.log("mainGroup 실행 - tagId:", tagId);
    const contextPath = '${pageContext.request.contextPath}';
    if (element) {
        var buttons = document.querySelectorAll('.groupBtn');
        for (var i = 0; i < buttons.length; i++) buttons[i].classList.remove('on');
        element.classList.add('on');
    }

    var url = contextPath + "/mainGroupAjax.htm?tagId=" + tagId;

    fetch(url)
        .then(function(res) { return res.json(); })
        .then(function(data) {
            var listWrapper = document.getElementById('groupList');
            var swiperContainer = document.querySelector('.goods__slider');
            
            // 슬라이더 초기화
            if (swiperContainer && swiperContainer.swiper) {
                swiperContainer.swiper.destroy(true, true);
            }
            listWrapper.innerHTML = ""; 

            if (!data || data.length === 0) {
                listWrapper.innerHTML = '<div style="width:100%; text-align:center; padding:50px;">상품이 없습니다.</div>';
                return;
            }

            var html = "";
            for (var i = 0; i < data.length; i++) {
                var prod = data[i];
                var id = prod.product_id;
                var onClass = (typeof WISHED !== 'undefined' && WISHED.has(id)) ? " on" : "";
                var name = prod.name;
                var price = (prod.price || 0).toLocaleString() + "원";
                var category = prod.category_name || "공용";

                // --- [이미지 주소 처리 핵심] ---
                var imgPath = prod.image_url || "";
                // 1. 이미 서블릿 주소가 붙어있다면 진짜 경로만 추출
                if (imgPath.includes("path=")) imgPath = imgPath.split("path=").pop();
                // 2. 톰캣 차단 방지를 위해 C: 제거
                imgPath = imgPath.replace("C:", "");
                // 3. 최종 서블릿 호출 주소
                var finalUrl = contextPath + "/displayImage.do?path=" + imgPath;

                // --- [필라 오리지널 레이아웃 구조] ---
                html += '<div class="goods swiper-slide">'
                    + '  <div class="photo">'
                    + '    <div class="before">'
                    + '      <a href="' + contextPath + '/product/product_detail.htm?productId=' + id + '">'
                    + '        <img src="' + finalUrl + '" alt="' + name + '">'
                    + '      </a>'
                    + '    </div>'
                    + '  </div>'
                    + '  <div class="info">'
                    + '    <a href="' + contextPath + '/product/product_detail.htm?productId=' + id + '">'
                    + '      <div class="top">'
                    + '        <p class="category">' + category + '</p>'
                    + '        <div class="tag">'
                    + '          <p>라이프스타일</p>'
                    + '          <p>SEMI-OVER핏</p>'
                    + '        </div>'
                    + '      </div>'
                    + '      <p class="name">' + name + '</p>'
                    + '      <div class="price">'
                    + '        <p class="sale">' + price + '</p>'
                    + '      </div>'
                    + '    </a>'
                    + '    <button type="button" class="wish__btn wish' + onClass + '" data-wish="' + id + '">wish</button>'
                    + '  </div>'
                    + '</div>';
            }

            listWrapper.innerHTML = html;

            // Swiper 재시작
            setTimeout(function() {
                goodsSlider = new Swiper('.goods__slider', {
                    slidesPerView: 'auto',
                    freeMode: true,
                    spaceBetween: 10,
                    observer: true,
                    observeParents: true
                });
            }, 50);
        })
        .catch(function(err) { console.error("에러:", err); });
}
$(document).ready(function() {
    const firstBtn = document.querySelector('.groupBtn');
    if (firstBtn) {
        firstBtn.click();
    }
});
</script>	
			<!-- //상품 리스트 스크롤 -->

			<!-- banner -->
			<section class="main-banner-box _v2">
				<!--2023-09-05 _v2(기획전 타이틀 추가)-->
				<div class="hd">
					<h2 class="">기획전</h2>
				</div>

				<div
					class="banner__slider swiper swiper-initialized swiper-horizontal swiper-pointer-events swiper-free-mode swiper-backface-hidden">
					<ul class="swiper-wrapper" id="swiper-wrapper-954e101059cac3699"
						aria-live="polite" style="transform: translate3d(0px, 0px, 0px);">

						<li class="swiper-slide swiper-slide-active" role="group"
							aria-label="1 / 5" style="margin-right: 40px;">
							<div class="photo">
								<a href="http://www.fila.co.kr/event/view.asp?seq=1289 "
									target="_self"> <img
									src="//filacdn.styleship.com/filacontent2/data/banner/main_middle_Wfitness_251023_28.jpg"
									alt="">
								</a>
							</div>

							<div class="info">
								<p class="tit">Her Winter Ritual</p>
								<p class="txt">그녀의 루틴에서 시작되는 겨울 피트니스 무드</p>


								<div class="btn-box">
									<a href="http://www.fila.co.kr/event/view.asp?seq=1289 "
										target="_self">자세히 보기</a>

								</div>

							</div>
						</li>

						<li class="swiper-slide swiper-slide-next" role="group"
							aria-label="2 / 5" style="margin-right: 40px;">
							<div class="photo">
								<a href="https://www.fila.co.kr/event/view.asp?seq=1290"
									target="_self"> <img
									src="//filacdn.styleship.com/filacontent2/data/banner/img_middle_puffer_d_251024_96.jpg"
									alt="">
								</a>
							</div>

							<div class="info">
								<p class="tit">The Puffer Bag Sundae</p>
								<p class="txt">나만의 취향으로 선택하는 푸퍼백 컬렉션</p>


								<div class="btn-box">
									<a href="https://www.fila.co.kr/event/view.asp?seq=1290"
										target="_self"> 자세히 보기</a>

								</div>

							</div>
						</li>

						<li class="swiper-slide" role="group" aria-label="3 / 5"
							style="margin-right: 40px;">
							<div class="photo">
								<a href="http://www.fila.co.kr/event/view.asp?seq=1280"
									target="_self"> <img
									src="//filacdn.styleship.com/filacontent2/data/banner/main_800x800_M_83.jpg"
									alt="">
								</a>
							</div>

							<div class="info">
								<p class="tit">Get Ready with Fila</p>
								<p class="txt">일상의 모든 순간을 함께할 에센셜 아이템을 소개합니다.</p>


								<div class="btn-box">
									<a href="http://www.fila.co.kr/event/view.asp?seq=1280"
										target="_self">자세히 보기</a>

								</div>

							</div>
						</li>

						<li class="swiper-slide" role="group" aria-label="4 / 5"
							style="margin-right: 40px;">
							<div class="photo">
								<a href="https://www.fila.co.kr/event/view.asp?seq=1264"
									target="_self"> <img
									src="//filacdn.styleship.com/filacontent2/data/banner/main_800x800_M_25_2.jpg"
									alt="">
								</a>
							</div>

							<div class="info">
								<p class="tit">2025 FILA MATCH</p>
								<p class="txt">AI로 복원한 그들의 리즈 시절의 대결</p>


								<div class="btn-box">
									<a href="https://www.fila.co.kr/event/view.asp?seq=1264"
										target="_self"> 자세히 보기</a>

								</div>

							</div>
						</li>

						<li class="swiper-slide" role="group" aria-label="5 / 5"
							style="margin-right: 40px;">
							<div class="photo">
								<a href="https://www.fila.co.kr/event/view.asp?seq=1236"
									target="_self"> <img
									src="//filacdn.styleship.com/filacontent2/data/banner/main_800x800_M_40.jpg"
									alt="">
								</a>
							</div>

							<div class="info">
								<p class="tit">AXILUS 3 T9</p>
								<p class="txt">최강의 안정감, 최고의 퍼포먼스</p>


								<div class="btn-box">
									<a href="https://www.fila.co.kr/event/view.asp?seq=1236"
										target="_self"> 자세히 보기</a>

								</div>

							</div>
						</li>

					</ul>
					<span class="swiper-notification" aria-live="assertive"
						aria-atomic="true"></span>
				</div>
			</section>
			<!-- //banner -->

			<!-- 추천 스타일 -->


			<section class="goods-scroll-box _v2 _gs02">
    <div class="hd">
        <h2>추천 스타일</h2>
        <a href="${pageContext.request.contextPath}/style/detail.htm" class="more-btn">더보기</a>
    </div>

    <div class="slider-box">
        <div class="goods__slider swiper swiper-initialized swiper-horizontal">
            <div class="swiper-wrapper" id="swiper-wrapper-style" aria-live="polite">
                
                <c:forEach var="s" items="${activeStyles}" varStatus="status">
                    <div class="goods swiper-slide ${status.first ? 'swiper-slide-active' : (status.index == 1 ? 'swiper-slide-next' : '')}" 
                         role="group" aria-label="${status.count} / ${activeStyles.size()}">
                        <div class="photo">
                            <div class="before">
                                <%-- 클릭 시 스타일 상세페이지로 이동 --%>
                                <a href="${pageContext.request.contextPath}/style/detail.htm?id=${s.styleId}"> 
                                    <c:choose>
                                        <c:when test="${not empty s.mainImageUrl}">
                                            <img src="${pageContext.request.contextPath}/displayImage.do?path=${s.mainImageUrl}" alt="${s.styleName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/images/no_image.jpg" alt="No Image">
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

            </div>
            <span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span>
        </div>
    </div>
</section>

			<!-- //추천 스타일 -->

			


			
			<!-- //instagram -->
		</div>
	</div>
	