<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="${pageContext.request.contextPath}/js/list.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/review/review_style.css">
<script src="${pageContext.request.contextPath}/resources/review/review_script.js"></script>

<%-- [스타일 강제 적용] JSP 안에 넣으면 캐시 문제 없이 바로 보입니다 --%>
<style>
    /* 1. [기본 상태] 연한 회색 */
    #photoFilterBtn {
        font-size: 14px;
        color: #999 !important;      /* 기본 글씨: 연회색 */
        font-weight: 400 !important; /* 얇게 */
        background: none; border: none; cursor: pointer; display: flex; align-items: center; gap: 6px;
        transition: all 0.2s;
    }
    #photoFilterBtn svg {
        stroke: #bbb !important;     /* 기본 아이콘: 연회색 */
        stroke-width: 1.5px;
        fill: none;
        transition: all 0.2s;
    }

    /* 2. [호버 상태] 마우스 올렸을 때 -> 진한 회색(검정) #111 */
    #photoFilterBtn:hover {
        color: #111 !important;      /* 글씨: 진한 회색 */
        font-weight: 700 !important; /* 굵게 */
    }
    #photoFilterBtn:hover svg {
        stroke: #111 !important;     /* 아이콘: 진한 회색 */
        stroke-width: 2px;
    }

    /* 3. [활성화 상태] 클릭됨 (class="active") -> 진한 회색(검정) #111 */
    #photoFilterBtn.active {
        color: #111 !important;      /* 글씨: 진한 회색 (남색 아님!) */
        font-weight: 700 !important;
    }

    /* [핵심] 클릭 시 아이콘 모양 변경 */
    /* 동그라미: 배경을 진한 회색(#111)으로 꽉 채움 */
    #photoFilterBtn.active svg circle {
        fill: #111 !important;       /* 여기가 핵심! 배경 채우기 */
        stroke: none !important;     /* 테두리 선 삭제 */
        transition: all 0.2s;
    }
    /* 체크표시: 선 색깔을 하얀색(#fff)으로 */
    #photoFilterBtn.active svg polyline {
        stroke: #fff !important;     /* 체크는 하얀색 */
        stroke-width: 2.5px;
        transition: all 0.2s;
    }
    
/* [리뷰 더보기/접기 스타일 - 높이 기준] */
.review-text-body {
    font-size: 14px; 
    line-height: 1.6; /* 줄간격 */
    color: #1a1a1a; 
    white-space: pre-wrap;
    
    /* [핵심] 높이 제한 설정 */
    max-height: 110px; /* 대략 5줄 정도 높이 (14px * 1.6 * 5줄 ≈ 112px) */
    overflow: hidden;  /* 넘치는 내용 숨김 */
    
    transition: max-height 0.3s ease; /* 부드럽게 열리기 */
}

/* 펼쳐졌을 때 클래스 */
.review-text-body.full {
    max-height: none !important; /* 높이 제한 해제 */
}

/* 더보기 버튼 (기본적으로 숨겨둠 -> JS가 필요하면 보여줌) */
.more-btn-wrap {
    display: none; /* 일단 숨김 */
    text-align: right; 
    margin-top: 5px;
}

.more-btn {
    display: inline-block;
    font-size: 13px;
    color: #999;
    text-decoration: underline;
    background: none; 
    border: none; 
    cursor: pointer;
    padding: 0;
}
.more-btn:hover {
    color: #000;
}
</style>

<div class="common__layer _review" id="reviewModal" style="display:none;">
    
    <div class="layer-bg__wrap" onclick="closeReviewModal()"></div>

    <div class="inner">
        
        <div id="reviewListView" style="height:100%; display:flex; flex-direction:column;">
            
            <div class="head">
                <div class="goods-info">
                    <div class="photo">
                        <img src="${not empty product.image_url ? product.image_url : '//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS253IP02F003_734.jpg'}" alt="상품이미지">
                    </div>

                    <div class="info">
					    <div>
					        <p class="txt1">${product.name != null ? product.name : '상품명'}</p>
					    </div>
					    
					    <%-- 작성하기 버튼 동작 제어 --%>
					    <button type="button" class="review-write__btn" onclick="checkReviewPermission()">
					        작성하기
					    </button>
					</div>
                </div>
                <button type="button" class="close__btn" onclick="closeReviewModal()">close</button>
            </div>

            <div class="con" style="flex:1; overflow-y:auto;">
                
                <div class="point-guide-banner">
                    <div class="point-txt">
                        <h4>구매확정 후 90일 이내 상품평 작성 시, 최대 2,000 포인트 혜택!</h4>
                        <p>작성하신 상품평에 대한 포인트 지급은 작성 후 15일 이내로 적립됩니다.</p>
                    </div>
                    <div class="point-badges">
                        <span>텍스트 리뷰 500P</span>
                        <span>포토 리뷰 1,000P</span>
                    </div>
                </div>

                <div style="margin-top: 30px; margin-bottom: 20px;">
				    <h3 style="font-weight: 700; font-size: 16px; color:#000; margin-bottom:15px;">REVIEW</h3>
				    <div class="big-rating" style="display: flex; align-items: center; gap: 10px;">
				        <%-- 휠라식 날카로운 큰 별 --%>
				        <span style="display: flex; align-items: center;">
				            <svg viewBox="0 0 24 24" style="width: 32px; height: 32px; fill: #003F96;">
				                <path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.828 1.48 8.279-7.416-3.967-7.417 3.967 1.481-8.279-6.064-5.828 8.332-1.151z"/>
				            </svg>
				        </span> 
				        
				        <%-- [핵심] 실시간 평균 점수 출력 --%>
				        <span style="font-size: 32px; font-weight: 800; color: #000;">
				            <c:choose>
				                <c:when test="${reviewSummary.avg_score > 0}">
				                    <fmt:formatNumber value="${reviewSummary.avg_score}" pattern="0.0" />
				                </c:when>
				                <c:otherwise>0.0</c:otherwise>
				            </c:choose>
				        </span>
				
				        <%-- 구분선과 상세 정보 --%>
				        <div style="width: 1px; height: 30px; background: #eee; margin: 0 15px;"></div>
				        
				        <div style="font-size: 14px; color: #333;">
				            <div>
				                <strong style="color: #003F96;">${reviewSummary.best_rate}%</strong>가 <b>아주 좋아요</b> 라고 평가했습니다.
				            </div>
				            <div style="color: #999; font-size: 13px; margin-top: 3px;">
				                리뷰 ${reviewSummary.total_cnt}개
				            </div>
				        </div>
				    </div>
				</div>

                <div class="filter-toolbar" style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
    
                    <%-- [왼쪽] 정렬 옵션 --%>
                    <div class="sort-opts">
                        <a href="javascript:void(0);" id="sortDateBtn" class="active" onclick="changeSort('date')" style="margin-right:10px; font-weight:bold; color:#000; text-decoration:none;">최신순</a>
                        <a href="javascript:void(0);" id="sortRateBtn" onclick="changeSort('rate')" style="color:#999; text-decoration:none;">별점순</a>
                    </div>
                
                    <%-- [오른쪽] 포토 버튼 + 검색창 --%>
                    <div style="display:flex; align-items:center; gap: 15px;">
                        
                        <%-- 1. 포토/동영상 먼저 보기 버튼 --%>
                        <button type="button" id="photoFilterBtn" onclick="togglePhotoFilter(this)">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="16 9 12 15 8 11"></polyline>
                            </svg>
                            <span style="letter-spacing:-0.5px; margin-top:2px;">포토리뷰 먼저 보기</span>
                        </button>
                
                        <%-- 2. 검색창 --%>
                        <div class="search-box" style="position:relative; width: 200px;">
                            <svg style="position:absolute; left:10px; top:50%; transform:translateY(-50%); width:16px; height:16px; stroke:#999;" 
                                 viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <input type="text" id="searchKeyword" placeholder="리뷰 키워드 검색" onkeyup="handleSearchKey(event)" 
                                   style="width:100%; height:34px; border:1px solid #ddd; border-radius:4px; padding-left:32px; padding-right:10px; box-sizing:border-box; font-size:13px;">
                        </div>
                    </div>
                </div>

                <div class="review-content-area" id="reviewListArea">
				    <jsp:include page="review_list.jsp" />
				</div>
				
            </div>
        </div>


        <div id="reviewWriteView" style="height:100%; display:none; flex-direction:column;">
            
            <div class="head">
                <div class="goods-info">
                    <div class="photo">
                        <img src="${not empty product.image_url ? product.image_url : '//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS253IP02F003_734.jpg'}" alt="상품이미지">
                    </div>
                    <div class="info">
                        <p class="txt1">후기 작성</p>
                    </div>
                </div>
                <button type="button" class="close__btn" onclick="switchToList()">close</button>
            </div>

            <div class="con" style="flex:1; overflow-y:auto; padding: 0 20px;">
		        <form id="reviewForm" action="${pageContext.request.contextPath}/review/insert.htm" method="post" enctype="multipart/form-data">
		            <input type="hidden" name="productNo" value="${product.product_id}">
		            
		            <%-- 별점 선택 영역 --%>
		            <div style="text-align:center; padding: 40px 0; border-bottom:1px solid #eee;">
		                <p style="font-weight:700; font-size: 18px; margin-bottom:20px; color:#000;">상품은 만족하셨나요?</p>
		                <div class="stars-wrap" style="display:flex; justify-content:center; gap:8px; cursor:pointer;" id="starBox">
		                    <input type="hidden" name="reviewScore" id="reviewScore" value="5">
		                    
		                    <%-- 별 5개 생성: 1번부터 5번까지 --%>
		                    <c:forEach var="i" begin="1" end="5">
		                        <span class="star-svg-wrap" onclick="setRating(${i})">
		                            <svg viewBox="0 0 24 24" class="write-star-svg" data-index="${i}" style="width: 45px; height: 45px; fill: #003F96; transition: 0.2s;">
		                                <path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.828 1.48 8.279-7.416-3.967-7.417 3.967 1.481-8.279-6.064-5.828 8.332-1.151z"/>
		                            </svg>
		                        </span>
		                    </c:forEach>
		                </div>
		                <div id="scoreText" style="margin-top:15px; font-weight:700; font-size: 16px; color: #003F96;">아주 좋아요</div>
		            </div>
		
		            <%-- 내용 입력 영역 --%>
		            <div style="padding: 30px 0;">
		                <label style="display:block; font-weight:700; font-size: 17px; margin-bottom:15px; color:#000;">내용 입력</label>
		                <textarea name="reviewContent" style="width:100%; height:220px; padding:20px; border:1px solid #ddd; resize:none; box-sizing:border-box; font-size: 16px; line-height: 1.6;" 
		                          placeholder="착용감, 사이즈 등 솔직한 후기를 남겨주세요."></textarea>
		            </div>
		
		            <%-- 사진 첨부 영역 --%>
		            <div style="padding-bottom:30px; border-top: 1px solid #f9f9f9; padding-top: 20px;">
					    <label style="display:block; font-weight:700; font-size: 17px; margin-bottom:15px; color:#000;">
					        사진 첨부 
					        <%-- [NEW] 현재 몇 개 골랐는지 보여주는 숫자 카운터 추가 --%>
					        <span id="fileCount" style="font-size:14px; color:#003F96; font-weight:bold; margin-left:5px;">(0/4)</span>
					    </label>
					    
					    <div style="margin-top:10px;">
					        <%-- multiple 필수 --%>
					        <input type="file" id="reviewFiles" name="reviewFiles" accept="image/*" multiple onchange="handleImgPreview(this)" style="font-size: 15px;">
					    </div>
					
					    <%-- [중요] 여기가 미리보기가 들어갈 자리입니다. 이 div가 없으면 사진이 안 보여요! --%>
					    <div id="imgPreviewBox" style="display:flex; gap:10px; margin-top:15px; flex-wrap:wrap; min-height: 20px;">
					        <%-- 스크립트가 여기에 썸네일을 꽂아줍니다 --%>
					    </div>
					</div>
		
		            <%-- 등록 버튼 --%>
		            <div style="margin-top:20px; padding-bottom: 40px;">
		                <a href="javascript:void(0);" onclick="submitReviewAjax();" 
   style="display:block; width:100%; height:65px; line-height:65px; text-align:center; background:#000; color:#fff; font-size:19px; font-weight:700; border-radius:35px; text-decoration: none;">등록하기</a>
		            </div>
		        </form>
		    </div>
        </div>

    </div>
</div>

<script>
// [전역 변수]
var sel_files = [];
var isPhotoFirst = false; // 포토 리뷰 정렬 토글 변수
var currentSort = "date"; // 정렬 기준 (date: 최신순, rate: 별점순)

// 1. [정렬 변경] 최신순/별점순 탭 클릭 시
function changeSort(type) {
    currentSort = type; // date 또는 rate 저장
    
    // 스타일 변경
    if (type === 'date') {
        $("#sortDateBtn").css({"font-weight":"bold", "color":"#000"}).addClass("active");
        $("#sortRateBtn").css({"font-weight":"normal", "color":"#999"}).removeClass("active");
    } else {
        $("#sortRateBtn").css({"font-weight":"bold", "color":"#000"}).addClass("active");
        $("#sortDateBtn").css({"font-weight":"normal", "color":"#999"}).removeClass("active");
    }
    
    // 검색 실행
    searchReviews();
}

// 2. [검색어 입력] 엔터키 눌렀을 때 실행
function handleSearchKey(e) {
    if (e.keyCode === 13) { // 13번이 엔터키
        searchReviews();
    }
}

// 3. [통합 검색 요청] 모든 조건(포토, 정렬, 검색어)을 합쳐서 AJAX 요청
// (이 함수 하나로 모든 검색/정렬을 처리합니다!)
function searchReviews() {
    var productId = "${product.product_id}";
    var keyword = $("#searchKeyword").val(); // 검색어 가져오기
    
    // 정렬 로직 조합
    var finalSort = currentSort;
    if (isPhotoFirst) {
        if (currentSort === 'date') finalSort = "photo"; // 기존 'photo' = 사진우선 + 최신순
        else finalSort = "photo_rate"; // 신규 'photo_rate' = 사진우선 + 별점순
    }

    console.log("DB 요청: 정렬=" + finalSort + ", 검색어=" + keyword);
    
    $.ajax({
        url: "${pageContext.request.contextPath}/review/list.htm",
        type: "GET",
        data: { 
            product_id: productId,
            sort: finalSort,
            keyword: keyword
        },
        dataType: "html",
        success: function(htmlFragment) {
            $("#reviewListArea").html(htmlFragment);
            
            // 리스트 로드 후 높이 계산 (더보기 버튼용)
            // review_modal.jsp에 있는 함수나 review_list.jsp에 있는 함수 중 하나 실행
            if (typeof checkReviewHeight === 'function') {
                checkReviewHeight();
            } else if (typeof checkReviewHeightLocal === 'function') {
                checkReviewHeightLocal();
            }
        },
        error: function(err) {
            console.log("리스트 로드 실패", err);
        }
    });
}

// [포토 리뷰 필터 토글]
function togglePhotoFilter(btn) {
    isPhotoFirst = !isPhotoFirst; // 상태 반전
    $(btn).toggleClass("active"); // 클래스 변경
    searchReviews(); // DB 조회 요청 (위의 똑똑한 함수 호출)
}

// [여기 있던 옛날 searchReviews() 함수는 지웠습니다! 절대 다시 넣지 마세요!]

// [리뷰 더보기/접기 기능]
function toggleReviewText(btn) {
    var $textDiv = $(btn).parent().prev(); 
    
    if ($textDiv.hasClass("full")) {
        $textDiv.removeClass("full");
        $(btn).text("리뷰 더보기"); 
    } else {
        $textDiv.addClass("full");
        $(btn).text("리뷰 접기"); 
    }
}

// [높이 재는 함수] (모달 열 때 사용)
function checkReviewHeight() {
    $(".review-text-body").each(function() {
        if (this.scrollHeight > this.clientHeight) {
            $(this).next(".more-btn-wrap").show();
        } else {
            $(this).next(".more-btn-wrap").hide();
        }
    });
}

// [1] 모달 열기
function openReviewModal() {
    $('#reviewModal').fadeIn(200);
    $('body').addClass('no-scroll');
    switchToList();
    
    setTimeout(function() {
        checkReviewHeight(); 
    }, 50);
}

// [2] 모달 닫기
function closeReviewModal() {
    $('#reviewModal').fadeOut(200);
    $('body').removeClass('no-scroll');
    resetWriteForm();
}

// [3] 작성 화면 전환
function switchToWrite() {
    var isLogOut = ${empty auth}; 
    if (isLogOut) {
        alert("로그인이 필요한 기능입니다.");
        location.href = "${pageContext.request.contextPath}/login.htm";
        return; 
    }
    resetWriteForm(); 
    $('#reviewListView').hide(); 
    $('#reviewWriteView').css('display', 'flex'); 
}

// [초기화 함수]
function resetWriteForm() {
    sel_files = [];
    $("#imgPreviewBox").empty();
    $("#reviewFiles").val("");
    $("textarea[name='reviewContent']").val("");
    setRating(5);
    $("#scoreText").text("아주 좋아요");
    $(".write-star-svg").css("fill", "#003F96");
    $("#fileCount").text("(0/4)");
}

// [4] 목록 화면
function switchToList() {
    $('#reviewWriteView').hide();
    $('#reviewListView').css('display', 'flex');
}

// [5] 별점 설정
function setRating(rating) {
    $("#reviewScore").val(rating);
    $(".write-star-svg").each(function() {
        var starIndex = $(this).data("index");
        if (starIndex <= rating) $(this).css("fill", "#003F96");
        else $(this).css("fill", "#ddd");
    });
    var scoreTexts = ["", "별로예요", "그냥 그래요", "보통이에요", "맘에 들어요", "아주 좋아요"];
    $("#scoreText").text(scoreTexts[rating]);
}

// [6] 이미지 미리보기
function handleImgPreview(e) {
    var files = e.files;
    var filesArr = Array.prototype.slice.call(files);
    var totalCnt = sel_files.length + filesArr.length;

    if (totalCnt > 4) {
        alert("사진은 최대 4장까지만 등록 가능합니다.\n(현재 " + sel_files.length + "장 + 선택 " + filesArr.length + "장 = 총 " + totalCnt + "장)");
        $(e).val(""); 
        return;
    }

    filesArr.forEach(function(f) {
        if (!f.type.match("image.*")) {
            alert("이미지 파일만 업로드 가능합니다.");
            return;
        }
        sel_files.push(f); 
        var reader = new FileReader();
        reader.onload = function(e) {
            var html = 
                '<div class="img-thumb" style="position:relative; width:80px; height:80px; margin-right:10px; margin-bottom:10px; display:inline-block;">' +
                '   <img src="' + e.target.result + '" style="width:100%; height:100%; object-fit:cover; border-radius:4px; border:1px solid #ddd;">' +
                '   <button type="button" onclick="deleteSelImage(this, \'' + f.name + '\')" ' +
                '       style="position:absolute; top:-5px; right:-5px; background:#000; color:#fff; border:0; width:20px; height:20px; border-radius:50%; font-size:12px; cursor:pointer; display:flex; align-items:center; justify-content:center;">X</button>' +
                '</div>';
            $("#imgPreviewBox").append(html);
        }
        reader.readAsDataURL(f);
    });
    updateFileCount();
    $(e).val(""); 
}

function deleteSelImage(btn, fileName) {
    sel_files = sel_files.filter(function(f) { return f.name !== fileName; });
    $(btn).parent().remove();
    updateFileCount();
}

function updateFileCount() {
    $("#fileCount").text("(" + sel_files.length + "/4)");
}

// [AJAX] 리뷰 등록
function submitReviewAjax() {
    var content = $("textarea[name='reviewContent']").val();
    var rating = $("#reviewScore").val();
    var productNo = $("input[name='productNo']").val();

    if (!content) { alert("내용을 입력해주세요."); return; }

    var formData = new FormData();
    formData.append("productNo", productNo);
    formData.append("reviewContent", content);
    formData.append("reviewScore", rating);
    for (var i = 0; i < sel_files.length; i++) {
        formData.append("file" + (i+1), sel_files[i]);
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/review/insert.htm",
        type: "POST",
        data: formData,
        processData: false, 
        contentType: false, 
        dataType: "json",   
        success: function(res) {
            if (res.status === "success") {
                alert("리뷰가 등록되었습니다.");
                location.reload(); 
            } else {
                alert(res.message);
            }
        },
        error: function(err) {
            alert("등록 중 오류가 발생했습니다.");
            console.log(err);
        }
    });
}

// [필터 & 좋아요]
function toggleFilter(id) { var $el = $('#' + id); var isOpen = $el.is(':visible'); $('.filter-dropdown').hide(); if (!isOpen) $el.show(); }
function closeFilter(id) { $('#' + id).hide(); }
$(document).on('click', function(e) { if (!$(e.target).closest('.filter-wrapper').length) { $('.filter-dropdown').hide(); } });

function handleLike(btn, reviewId, type) {
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) { alert("로그인이 필요한 기능입니다."); location.href = "${pageContext.request.contextPath}/login.htm"; return; }
    $.ajax({
        url: "${pageContext.request.contextPath}/review/like.htm",
        type: "POST",
        data: { reviewId: reviewId, type: type },
        dataType: "text", 
        success: function(res) {
            var result = res.trim();
            if (result === "1") {
                var countSpan = $(btn).find("span");
                countSpan.text(parseInt(countSpan.text()) + 1);
                $(btn).find("svg").css("fill", "#003F96");
                $(btn).css("color", "#003F96");
                alert("반영되었습니다."); 
            } else if (result === "-1") { alert("이미 평가하신 리뷰입니다."); }
            else if (result === "login") { alert("로그인이 필요한 기능입니다."); location.href = "${pageContext.request.contextPath}/login.htm"; }
            else { alert("오류 발생"); }
        },
        error: function() { alert("통신 오류"); }
    });
}
</script>

<script>
function checkReviewPermission() {
    // 1. 로그인 여부 확인 (auth가 없으면 빈 문자열)
    var user = "${sessionScope.auth}"; 
    
    if (!user) {
        alert("로그인이 필요한 서비스입니다.");
        location.href = "/login/login.htm"; // 로그인 페이지 경로
        return;
    }

    // 2. 구매 여부 확인 (Handler에서 보내준 canReview 값 사용)
    // EL 표기법 ${canReview}는 true 또는 false로 변환됨
    var canReview = ${canReview}; 

    if (canReview) {
        // 구매했으면 원래 있던 글쓰기 화면 전환 함수 호출
        switchToWrite(); 
    } else {
        // 구매하지 않았으면 경고창
        alert("작성할 리뷰가 없습니다.");
    }
}
</script>