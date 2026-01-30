<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>FILA 상품상세</title>
<script src="${pageContext.request.contextPath}/js/TweenMax.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>
<script src="${pageContext.request.contextPath}/js/mighty.base.1.5.7.js"></script>
<script src="${pageContext.request.contextPath}/js/matiz.js"></script>
<script src="${pageContext.request.contextPath}/js/swiper-bundle.js"></script>
<script
	src="${pageContext.request.contextPath}/js/default.js?v=202504161631"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/list.js"></script>
<link href="${pageContext.request.contextPath}/css/SpoqaHanSansNeo.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/normalize.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/opt-default.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/swiper-bundle.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/product.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sub.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
<style>
/* 모달 전체 배경 */
.style-modal-overlay {
    display: none; 
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.8);
    z-index: 10000;
    justify-content: center;
    align-items: center;
}

/* 모달 흰색 박스 */
.style-modal-wrapper {
    position: relative;
    background: #fff;
    width: 1100px;
    
   
    overflow: hidden;
    z-index: 10001;
}

/* 휠라 내부 클래스 강제 보정 (가장 중요) */
.style-modal-wrapper .common__layer {
    display: flex !important;
    position: relative !important;
    left: 0 !important; top: 0 !important;
    visibility: visible !important;
}


.style-modal-wrapper .photo { !important;  }
.style-modal-wrapper .con { !important;   }
</style>
</head>
<body class>
		<jsp:include page="../common/header.jsp" />
	<div id="wrap">
		<div id="contents" class="goods__contents">
			<section class="goods-list-box _thumb03 _type_style">
				<h2 class="hidden">상품 리스트</h2>

				<div class="head">
					<div class="tit-box">
						<p class="tit">
							스타일<span>${fn:length(styleList)}</span>
						</p>
					</div>

					<div class="sorting-box">
						<div></div>

						<div>
							<!--select>
								<option value="">등록순</option>
								<option value="">정렬 01</option>
								<option value="">정렬 02</option>
							</select-->

							<div class="col-box">
								<button type="button" class="col3__btn">3단</button>
								<button type="button" class="col4__btn">4단</button>
							</div>
						</div>
					</div>
				</div>

				<div class="con">
					<!-- filter -->
					<div class="filter-box"></div>
					<!-- //filter -->

					<!-- 상품 리스트 -->
					<div class="list-box">
						<ul class="goods__list">
							<c:forEach var="style" items="${styleList}" varStatus="status">
								<li class="style-goods _sg">
									<div class="photo" onclick="codiCart('${style.style_id}')">
										<div class="before">
											<a href="javascript:;"> <img src="${pageContext.request.contextPath}/displayImage.do?path=${style.main_image_url}" alt="${style.style_name}">
											</a>
										</div>

										<div class="after">
											<!-- slider -->
											<div
												class="hover__slider swiper">
												<div class="swiper-wrapper"
													id="swiper-wrapper-632841ba10db29418" aria-live="polite"
													style="transform: translate3d(-351px, 0px, 0px); transition-duration: 0ms;">
													<c:forEach var="img" items="${style.images}" varStatus="imgStatus">
												        <div class="swiper-slide" 
												             data-swiper-slide-index="${imgStatus.index}" 
												             role="group" 
												             aria-label="${imgStatus.count} / ${fn:length(style.images)}">
												            
												            <a href="javascript:;">
												                <img src="${pageContext.request.contextPath}/displayImage.do?path=${img.image_url}" 
                 alt="${not empty img.alt_text ? img.alt_text : '스타일 이미지'}">
												            </a>
												        </div>
												    </c:forEach>
													
												</div>
												<span class="swiper-notification" aria-live="assertive"
													aria-atomic="true"></span>
											</div>
											<!-- //slider -->

										</div>
										
										<div class="bot__layer _show">

										<!-- slider button -->
										<div class="slider-btn-box">
											<button type="button" class="prev__btn" tabindex="0"
												aria-label="Previous slide"
												aria-controls="swiper-wrapper-632841ba10db29418">
												<svg xmlns="http://www.w3.org/2000/svg" width="7.071"
													height="11.314" viewBox="0 0 7.071 11.314">
												<g id="_" data-name="&lt;"
														transform="translate(1120.057 1377.444) rotate(-135)">
													<rect id="사각형_18" data-name="사각형 18" width="8" height="2"
														rx="1" transform="translate(1754 178)" fill="#fff"></rect>
													<rect id="사각형_19" data-name="사각형 19" width="8" height="2"
														rx="1" transform="translate(1762 178) rotate(90)"
														fill="#fff"></rect>
												</g>
											</svg>
											</button>

											<div
												class="sg-swiper-pagination swiper-pagination-clickable swiper-pagination-bullets swiper-pagination-horizontal">
												<span
													class="swiper-pagination-bullet swiper-pagination-bullet-active"
													tabindex="0" role="button" aria-label="Go to slide 1"
													aria-current="true"></span><span
													class="swiper-pagination-bullet" tabindex="0" role="button"
													aria-label="Go to slide 2"></span><span
													class="swiper-pagination-bullet" tabindex="0" role="button"
													aria-label="Go to slide 3"></span><span
													class="swiper-pagination-bullet" tabindex="0" role="button"
													aria-label="Go to slide 4"></span><span
													class="swiper-pagination-bullet" tabindex="0" role="button"
													aria-label="Go to slide 5"></span>
											</div>

											<button type="button" class="next__btn" tabindex="0"
												aria-label="Next slide"
												aria-controls="swiper-wrapper-632841ba10db29418">
												<svg xmlns="http://www.w3.org/2000/svg" width="7.071"
													height="11.314" viewBox="0 0 7.071 11.314">
												<g id="_" data-name="&gt;"
														transform="translate(-1112.986 -1366.13) rotate(45)">
													<rect id="사각형_18" data-name="사각형 18" width="8" height="2"
														rx="1" transform="translate(1754 178)" fill="#fff"></rect>
													<rect id="사각형_19" data-name="사각형 19" width="8" height="2"
														rx="1" transform="translate(1762 178) rotate(90)"
														fill="#fff"></rect>
												</g>
											</svg>
											</button>
										</div>
										<!-- //slider button -->
									</div>
									</div>

									
								</li>
							</c:forEach>



						</ul>

					</div>
					<!-- //상품 리스트 -->
				</div>
			</section>
		</div>
		
	</div>
	<div id="styleModalOverlay" class="style-modal-overlay" onclick="if(event.target == this) closeModal();" style="display:none;">
    <div id="styleModalContent" class="style-modal-wrapper">
        </div>
</div>

<script>
    $(document).ready(function() {
        // [추가] URL에서 id 파라미터가 있는지 확인
        const urlParams = new URLSearchParams(window.location.search);
        const styleId = urlParams.get('id');

        // [추가] id가 있다면 즉시 codiCart 함수를 실행하여 모달을 띄움
        if (styleId) {
            console.log("URL에서 Style ID 확인됨: " + styleId);
            codiCart(styleId);
        }
    });

    // 기존 codiCart 함수 (그대로 유지하되 ajax 파라미터만 살짝 보강)
    function codiCart(styleId) {
        $.ajax({
            url : "${pageContext.request.contextPath}/style/detail.htm",
            type : "GET",
            data : { 
                "id" : styleId,
                "isAjax" : "true" // 핸들러가 확실히 Ajax임을 인지하게 함
            },
            dataType : "html",
            // 요청 헤더에 XMLHttpRequest를 명시적으로 추가 (isAjax 판단용)
            beforeSend: function(xhr) {
                xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
            },
            success : function(res) {
                $("#styleModalContent").html(res);
                $("#styleModalOverlay").css("display", "flex").show();
                $("body").css("overflow", "hidden");

                if (typeof Swiper !== 'undefined') {
                    // 모달 내 슬라이더 클래스명이 mc__slider인지 photo__slider인지 확인 후 적용
                    new Swiper(".mc__slider, .photo__slider", { 
                        observer: true,
                        observeParents: true,
                        pagination: { el: ".mc-swiper-pagination", clickable: true }
                    });
                }
            },
            error : function() { alert("정보를 불러오지 못했습니다."); }
        });
    }

    function closeModal() {
        $("#styleModalOverlay").hide();
        $("body").css("overflow", "auto");
        // [선택 사항] 모달 닫을 때 URL에서 id 파라미터 제거 (새로고침 시 모달 안뜨게)
        history.replaceState({}, null, location.pathname);
    }
    
    $(document).on("click", ".close__btn", function() {
        closeModal();
    });
</script>
</body>
<%-- 3. 푸터 포함 (여기에 </body>, </html> 닫는 태그가 포함됨) --%>
<jsp:include page="../common/footer.jsp" />