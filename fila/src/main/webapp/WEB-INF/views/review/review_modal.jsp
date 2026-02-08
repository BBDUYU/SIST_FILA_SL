<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1. 재료 준비: 이거 지우면 절대 안됨! --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/js/list.js"></script>
<script src="${pageContext.request.contextPath}/resources/review/review_script.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/review/review_style.css">

<%-- 2. 실행 명령: 아까 드린 강제 호출 코드 --%>
<script>
    $(document).ready(function() {
        console.log(">>> jQuery 준비 완료 및 리스트 강제 호출 시도");
        
        // 0.5초 뒤에 실행 (다른 스크립트 에러가 나더라도 무시하고 실행하기 위함)
        setTimeout(function() {
            if(typeof searchReviews === 'function') {
                console.log(">>> searchReviews 함수 실행!");
                searchReviews();
            } else {
                console.error(">>> 에러: searchReviews 함수를 찾을 수 없습니다. (함수 정의 확인 필요)");
            }
        }, 500);
    });

    window.forceLoadReview = function() {
        searchReviews();
    };
</script>

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
        
        <%-- [1] 리뷰 리스트 화면 --%>
        <div id="reviewListView" style="height:100%; display:flex; flex-direction:column;">
            <div class="head">
                <div class="goods-info">
                    <div class="photo">
    <%-- product.productId가 안 넘어오면 파라미터에서 직접 땡겨오도록 처리 --%>
    <c:set var="pId" value="${not empty product.productId ? product.productId : param.productId}" />
    <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${pId}/${pId}_main_1.jpg" 
         onerror="this.src='//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS253IP02F003_734.jpg'" alt="상품이미지">
</div>
                    <div class="info">
                        <div><p class="txt1">${product.name != null ? product.name : '상품명'}</p></div>
                        <button type="button" class="review-write__btn" onclick="checkReviewPermission()">작성하기</button>
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
                    <div class="point-badges"><span>텍스트 리뷰 500P</span><span>포토 리뷰 1,000P</span></div>
                </div>

                <div style="margin-top: 30px; margin-bottom: 20px;">
                    <h3 style="font-weight: 700; font-size: 16px; color:#000; margin-bottom:15px;">REVIEW</h3>
                    <div class="big-rating" style="display: flex; align-items: center; gap: 10px;">
                        <span style="display: flex; align-items: center;">
                            <svg viewBox="0 0 24 24" style="width: 32px; height: 32px; fill: #003F96;"><path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.828 1.48 8.279-7.416-3.967-7.417 3.967 1.481-8.279-6.064-5.828 8.332-1.151z"/></svg>
                        </span> 
                        <span style="font-size: 32px; font-weight: 800; color: #000;">
                            <c:choose>
                                <c:when test="${reviewSummary.avg_score > 0}"><fmt:formatNumber value="${reviewSummary.avg_score}" pattern="0.0" /></c:when>
                                <c:otherwise>0.0</c:otherwise>
                            </c:choose>
                        </span>
                        <div style="width: 1px; height: 30px; background: #eee; margin: 0 15px;"></div>
                        <div style="font-size: 14px; color: #333;">
                            <div><strong style="color: #003F96;">${reviewSummary.best_rate != null ? reviewSummary.best_rate : 0}%</strong>가 <b>아주 좋아요</b> 라고 평가했습니다.</div>
                            <div style="color: #999; font-size: 13px; margin-top: 3px;">리뷰 ${reviewSummary.total_cnt != null ? reviewSummary.total_cnt : 0}개</div>
                        </div>
                    </div>
                </div>

                <div class="filter-toolbar" style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
                    <div class="sort-opts">
                        <a href="javascript:void(0);" id="sortDateBtn" class="active" onclick="changeSort('date')" style="margin-right:10px; font-weight:bold; color:#000; text-decoration:none;">최신순</a>
                        <a href="javascript:void(0);" id="sortRateBtn" onclick="changeSort('rate')" style="color:#999; text-decoration:none;">별점순</a>
                    </div>
                    <div style="display:flex; align-items:center; gap: 15px;">
                        <button type="button" id="photoFilterBtn" onclick="togglePhotoFilter(this)">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="16 9 12 15 8 11"></polyline></svg>
                            <span style="letter-spacing:-0.5px; margin-top:2px;">포토리뷰 먼저 보기</span>
                        </button>
                        <div class="search-box" style="position:relative; width: 200px;">
                            <svg style="position:absolute; left:10px; top:50%; transform:translateY(-50%); width:16px; height:16px; stroke:#999;" viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            <input type="text" id="searchKeyword" placeholder="리뷰 키워드 검색" onkeyup="handleSearchKey(event)" style="width:100%; height:34px; border:1px solid #ddd; border-radius:4px; padding-left:32px; padding-right:10px; box-sizing:border-box; font-size:13px;">
                        </div>
                    </div>
                </div>

                <%-- 리뷰 리스트 영역 --%>
                <div class="review-content-area" id="reviewListArea">
                    <%-- <jsp:include page="review_list.jsp" /> 인클루드 주석 --%>
                </div>
            </div>
        </div>

        <%-- [2] 리뷰 작성 화면 --%>
        <div id="reviewWriteView" style="height:100%; display:none; flex-direction:column;">
            <div class="head">
                <div class="goods-info">
                    <div class="photo">
    <%-- product.productId가 살아있다면 이 경로가 무조건 정답입니다 --%>
    <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${product.productId}/${product.productId}_main_1.jpg" 
         onerror="this.src='//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS253IP02F003_734.jpg'" alt="상품이미지">
</div>
                    <div class="info"><p class="txt1">후기 작성</p></div>
                </div>
                <button type="button" class="close__btn" onclick="switchToList()">close</button>
            </div>
            <div class="con" style="flex:1; overflow-y:auto; padding: 0 20px;">
                <form id="reviewForm" enctype="multipart/form-data">
                    <input type="hidden" name="productId" value="${product.productId}">
                    <div style="text-align:center; padding: 40px 0; border-bottom:1px solid #eee;">
                        <p style="font-weight:700; font-size: 18px; margin-bottom:20px; color:#000;">상품은 만족하셨나요?</p>
                        <div class="stars-wrap" style="display:flex; justify-content:center; gap:8px; cursor:pointer;" id="starBox">
                            <input type="hidden" name="rating" id="reviewScore" value="5">
                            <c:forEach var="i" begin="1" end="5">
                                <span class="star-svg-wrap" onclick="setRating(${i})">
                                    <svg viewBox="0 0 24 24" class="write-star-svg" data-index="${i}" style="width: 45px; height: 45px; fill: #003F96; transition: 0.2s;"><path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.828 1.48 8.279-7.416-3.967-7.417 3.967 1.481-8.279-6.064-5.828 8.332-1.151z"/></svg>
                                </span>
                            </c:forEach>
                        </div>
                        <div id="scoreText" style="margin-top:15px; font-weight:700; font-size: 16px; color: #003F96;">아주 좋아요</div>
                    </div>
                    <div style="padding: 30px 0;">
                        <label style="display:block; font-weight:700; font-size: 17px; margin-bottom:15px; color:#000;">내용 입력</label>
                        <textarea name="content" style="width:100%; height:220px; padding:20px; border:1px solid #ddd; resize:none; box-sizing:border-box; font-size: 16px; line-height: 1.6;" placeholder="착용감, 사이즈 등 솔직한 후기를 남겨주세요."></textarea>
                    </div>
                    <div style="padding-bottom:30px; border-top: 1px solid #f9f9f9; padding-top: 20px;">
                        <label style="display:block; font-weight:700; font-size: 17px; margin-bottom:15px; color:#000;">사진 첨부 <span id="fileCount" style="font-size:14px; color:#003F96; font-weight:bold; margin-left:5px;">(0/4)</span></label>
                        <div style="margin-top:10px;">
                            <input type="file" id="reviewFiles" name="reviewFile" accept="image/*" multiple onchange="handleImgPreview(this)" style="font-size: 15px;">
                        </div>
                        <div id="imgPreviewBox" style="display:flex; gap:10px; margin-top:15px; flex-wrap:wrap; min-height: 20px;"></div>
                    </div>
                    <div style="margin-top:20px; padding-bottom: 40px;">
                        <a href="javascript:void(0);" onclick="submitReviewAjax();" style="display:block; width:100%; height:65px; line-height:65px; text-align:center; background:#000; color:#fff; font-size:19px; font-weight:700; border-radius:35px; text-decoration: none;">등록하기</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
// =========================================
//  전역 변수
// =========================================
var sel_files = [];       
var isPhotoFirst = false; 
var currentSort = "date"; 

// =========================================
//  1. 조회 및 필터링
// =========================================
function changeSort(type) {
    currentSort = type;
    if (type === 'date') {
        $("#sortDateBtn").css({"font-weight":"bold", "color":"#000"}).addClass("active");
        $("#sortRateBtn").css({"font-weight":"normal", "color":"#999"}).removeClass("active");
    } else {
        $("#sortRateBtn").css({"font-weight":"bold", "color":"#000"}).addClass("active");
        $("#sortDateBtn").css({"font-weight":"normal", "color":"#999"}).removeClass("active");
    }
    searchReviews();
}

function handleSearchKey(e) {
    if (e.keyCode === 13) searchReviews();
}

function togglePhotoFilter(btn) {
    isPhotoFirst = !isPhotoFirst; 
    $(btn).toggleClass("active"); 
    searchReviews(); 
}

//[1] 리뷰 목록 불러오기 및 렌더링
function searchReviews() {
	var productId = window.__REVIEW_PRODUCT_ID__ || $("input[name='productId']").val();
    var target = $("#reviewListArea");

    $.ajax({
        url: "${pageContext.request.contextPath}/review/list.htm",
        type: "GET",
        data: { 
            productId: productId,
            sort: currentSort,
            isPhotoFirst: isPhotoFirst
        },
        dataType: "json",
        success: function(data) {
            console.log(">>> [응답 데이터 확인]", data);

            // [요약 정보 업데이트]
            var s = data.reviewSummary;
            if(s) {
                var total = s.total_cnt || s.TOTAL_CNT || 0;
                var avg = s.avg_score || s.AVG_SCORE || 0;
                var rate = s.best_rate || s.BEST_RATE || 0;

                $(".big-rating span:nth-child(2)").text(parseFloat(avg).toFixed(1));
                $(".big-rating strong").text(rate + "%");
                $(".big-rating div[style*='color: #999']").text("리뷰 " + total + "개");
            }

            // [리스트 그리기]
            var list = data.reviewList;
            if (!list || list.length === 0) {
                target.html('<div style="text-align:center; padding:80px 0; color:#999;">작성된 리뷰가 없습니다.</div>');
                return;
            }

            var html = "";
            list.forEach(function(dto) {
                // 데이터 매핑 (오라클 대소문자 방어)
                var rId   = dto.reviewId || dto.REVIEWID;
                var cont  = dto.content  || dto.CONTENT;
                var rate  = dto.rating   || dto.RATING;
                var rImg  = dto.reviewImg || dto.REVIEWIMG;
                var uId   = dto.userId   || dto.USERID || '비회원';
                var regD  = dto.regDate  || dto.REGDATE;
                var lCnt  = dto.likeCnt  || dto.LIKECNT || 0;
                var dlCnt = dto.dislikeCnt || dto.DISLIKECNT || 0;
                var myL   = (dto.myLike !== undefined) ? dto.myLike : dto.MYLIKE;

                // 날짜 처리
                var d = new Date(regD);
                var dateStr = d.getFullYear() + ". " + (d.getMonth() + 1) + ". " + d.getDate() + ".";
                
                // 별점 SVG 생성
                var stars = "";
                for(var i=1; i<=5; i++) {
                    var color = (i <= rate) ? "#003F96" : "#ddd";
                    stars += '<svg viewBox="0 0 24 24" style="width: 16px; height: 16px; fill: ' + color + '; margin-right:2px;"><path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.828 1.48 8.279-7.416-3.967-7.417 3.967 1.481-8.279-6.064-5.828 8.332-1.151z"/></svg>';
                }

                // --- [중요] 새로고침 시 파란색 유지 로직 ---
                var likeColor = (myL == 1) ? "#003F96" : "#666";
                var likeFill  = (myL == 1) ? "#003F96" : "#999";
                var dislikeColor = (myL == 0) ? "#003F96" : "#666";
                var dislikeFill  = (myL == 0) ? "#003F96" : "#999";

                html += '<div class="review-card" style="display: flex; border-bottom: 1px solid #f4f4f4; padding: 30px 0; min-height: 200px; width: 100%;">';
                html += '  <div style="flex: 1; padding-right: 40px;">';
                html += '    <div style="display: flex; margin-bottom: 15px;">' + stars + '</div>';
                html += '    <div style="margin-bottom: 20px; white-space: pre-wrap; font-size:14px; line-height:1.6; color:#333;">' + cont + '</div>';
                
                if(rImg) {
                    var cleanPath = rImg.replace(/\\/g, "/");
                    var contextPath = "${pageContext.request.contextPath}";
                    var finalSrc = contextPath + "/displayImage.do?path=" + cleanPath;

                    html += '    <div style="margin-bottom: 20px;">';
                    html += '        <img src="' + finalSrc + '" ';
                    html += '             style="width: 100px; height: 100px; object-fit: cover; border-radius: 4px; border:1px solid #eee; cursor:pointer;" ';
                    html += '             onclick="window.open(this.src)"';
                    html += '             onerror="this.src=\'https://via.placeholder.com/100?text=No+Image\'">';
                    html += '    </div>';
                }

                // 버튼 섹션 (서버에서 받은 myL 값에 따라 색상 적용)
                html += '    <div class="like-section" style="display: flex; align-items: center; gap: 15px; margin-top: 10px;">';
                html += '      <button type="button" onclick="handleLike(this, ' + rId + ', 1)" style="background: none; border: none; cursor: pointer; display: flex; align-items: center; font-size: 12px; padding: 0; color:' + likeColor + ';">';
                html += '        <svg viewBox="0 0 24 24" style="width: 16px; height: 16px; margin-right: 4px; fill:' + likeFill + ';"><path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z"/></svg>';
                html += '        도움돼요 <span style="margin-left: 4px; font-weight: bold;">' + lCnt + '</span>';
                html += '      </button>';
                html += '      <button type="button" onclick="handleLike(this, ' + rId + ', 0)" style="background: none; border: none; cursor: pointer; display: flex; align-items: center; font-size: 12px; padding: 0; color:' + dislikeColor + ';">';
                html += '        <svg viewBox="0 0 24 24" style="width: 16px; height: 16px; margin-right: 4px; transform: rotate(180deg); fill:' + dislikeFill + ';"><path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z"/></svg>';
                html += '        도움안돼요 <span style="margin-left: 4px; font-weight: bold;">' + dlCnt + '</span>';
                html += '      </button>';
                html += '    </div>';
                html += '  </div>';

                var displayId = uId.substring(0,3) + '****';
                html += '  <div style="width: 150px; border-left: 1px solid #f4f4f4; padding-left: 20px; flex-shrink: 0;">';
                html += '    <div style="font-size: 13px; font-weight: bold; margin-bottom: 8px; color:#000;">' + displayId + '</div>';
                html += '    <div style="font-size: 12px; color: #999;">' + dateStr + '</div>';
                html += '  </div>';
                html += '</div>';
            });
            target.html(html);
        }
    });
}

// [2] 도움돼요 클릭 처리 함수
function handleLike(btn, reviewId, type) {
    var $btn = $(btn);
    var $countSpan = $btn.find("span");

    $.ajax({
        url: "${pageContext.request.contextPath}/review/like.do",
        type: "POST",
        data: { reviewId: reviewId, type: type },
        success: function(res) {
            var result = res.trim();
            if (result === "1") {
                var count = parseInt($countSpan.text()) || 0;
                $countSpan.text(count + 1);
                $btn.css("color", "#003F96");
                $btn.find("svg").css("fill", "#003F96");
                alert("반영되었습니다.");
            } else if (result === "-1") {
                alert("이미 참여하신 리뷰입니다.");
            } else if (result === "login") {
                alert("로그인이 필요합니다.");
                location.href = "${pageContext.request.contextPath}/member/login.htm";
            }
        }
    });
}

// 리뷰 텍스트 더보기 접기
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

function checkReviewHeight() {
    $(".review-text-body").each(function() {
        if (this.scrollHeight > this.clientHeight) {
            $(this).next(".more-btn-wrap").show();
        } else {
            $(this).next(".more-btn-wrap").hide();
        }
    });
}

// =========================================
//  2. 모달 제어
// =========================================
function openReviewModal() {
    $('#reviewModal').fadeIn(200);
    $('body').addClass('no-scroll');
    switchToList(); 
    searchReviews();
}

function closeReviewModal() {
    $('#reviewModal').fadeOut(200);
    $('body').removeClass('no-scroll');
    resetWriteForm(); 
}

function switchToList() {
    $('#reviewWriteView').hide();
    $('#reviewListView').css('display', 'flex');
}

function switchToWrite() {
    resetWriteForm(); 
    $('#reviewListView').hide(); 
    $('#reviewWriteView').css('display', 'flex'); 
}

// =========================================
//  3. 작성 관련
// =========================================
function checkReviewPermission() {
    // 1. 로그인 체크
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (isLogin === "false") {
        if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/member/login.htm";
        }
        return;
    }

    // 2. 서버에 실제 구매 및 작성 여부 확인 (AJAX)
    var productId = "${product.productId}" || $("input[name='productId']").val();
    
    $.ajax({
        url: "${pageContext.request.contextPath}/review/checkAuthority.do",
        type: "GET",
        data: { productId: productId },
        success: function(res) {
            var result = res.trim(); // 공백 제거 (안전장치)
            
            if (result === "success") {
                // 권한 통과! 작성 폼으로 이동
                switchToWrite(); 
            } 
            else if (result === "login_required" || result === "login") { 
                // [수정] 로그인 알림 후 이동
                alert("로그인이 필요한 기능입니다. 로그인 페이지로 이동합니다.");
                location.href = "${pageContext.request.contextPath}/member/login.htm"; 
            } 
            else {
                // 주문 내역이 없거나 이미 다 쓴 경우
                alert("작성할 리뷰가 없습니다.");
            }
        },
        error: function() {
            alert("권한 확인 중 서버 오류가 발생했습니다.");
        }
    });
}

function resetWriteForm() {
    sel_files = [];
    $("#imgPreviewBox").empty();
    $("#reviewFiles").val("");
    $("textarea[name='content']").val(""); 
    setRating(5);
    $("#scoreText").text("아주 좋아요");
    $(".write-star-svg").css("fill", "#003F96");
    $("#fileCount").text("(0/4)");
}

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

function handleImgPreview(e) {
    var files = e.files;
    var filesArr = Array.prototype.slice.call(files);
    var totalCnt = sel_files.length + filesArr.length;

    if (totalCnt > 4) {
        alert("사진은 최대 4장까지만 등록 가능합니다.");
        $(e).val(""); 
        return;
    }

    filesArr.forEach(function(f) {
        if (!f.type.match("image.*")) return;
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

function submitReviewAjax() {
    var productId = "${product.productId}" || $("input[name='productId']").val();
    var content = $("textarea[name='content']").val();
    var rating = $("#reviewScore").val();

    if (!content.trim()) { alert("내용을 입력해주세요."); return; }

    var formData = new FormData();
    formData.append("productId", productId);
    formData.append("content", content);
    formData.append("rating", rating);
    
    // [핵심] 파일 파라미터 강제 주입
    if (sel_files.length > 0) {
        for (var i = 0; i < sel_files.length; i++) {
            formData.append("reviewFile", sel_files[i]);
        }
    } else {
        // 파일이 없으면 빈 값이라도 reviewFile 이름으로 보내야 400 에러 안 남
        formData.append("reviewFile", new File([], "")); 
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/review/write.do",
        type: "POST",
        data: formData,
        processData: false, 
        contentType: false, 
        success: function(res) {
            alert("리뷰가 등록되었습니다!");
            location.reload(); 
        },
        error: function(xhr) {
            console.error("등록 실패 사유:", xhr.responseText);
            alert("등록 오류 발생 (사유: " + xhr.status + ")");
        }
    });
}

// =========================================
//  4. 좋아요 등 기타
// =========================================
function handleLike(btn, reviewId, type) {
    var $btn = $(btn);
    var $countSpan = $btn.find("span");

    $.ajax({
        url: "${pageContext.request.contextPath}/review/like.do",
        type: "POST",
        data: { reviewId: reviewId, type: type },
        success: function(res) {
            var result = res.trim();
            
            if (result === "1") { // 성공!
                // 숫자 1 증가
                var count = parseInt($countSpan.text()) || 0;
                $countSpan.text(count + 1);
                
                // 버튼 색깔 파란색으로 (디자인 입히기)
                $btn.css("color", "#003F96");
                $btn.find("svg").css("fill", "#003F96");
                
                alert("반영되었습니다!");
            } else if (result === "-1") {
                alert("이미 참여하신 리뷰입니다.");
            } else if (result === "login") {
                alert("로그인이 필요한 서비스입니다.");
                location.href = "${pageContext.request.contextPath}/member/login.htm";
            } else {
                alert("처리에 실패했습니다.");
            }
        },
        error: function() {
            alert("서버 통신 중 에러가 발생했습니다.");
        }
    });
}
</script>