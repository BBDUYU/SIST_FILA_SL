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
        
        <%-- [1] 리뷰 리스트 화면 --%>
        <div id="reviewListView" style="height:100%; display:flex; flex-direction:column;">
            
            <div class="head">
                <div class="goods-info">
                    <div class="photo">
                        <%-- [수정] product.imageUrl --%>
                        <img src="${not empty product.imageUrl ? product.imageUrl : '//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS253IP02F003_734.jpg'}" alt="상품이미지">
                    </div>

                    <div class="info">
                        <div>
                            <p class="txt1">${product.name != null ? product.name : '상품명'}</p>
                        </div>
                        
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
                        <span style="display: flex; align-items: center;">
                            <svg viewBox="0 0 24 24" style="width: 32px; height: 32px; fill: #003F96;">
                                <path d="M12 .587l3.668 7.568 8.332 1.151-6.064 5.828 1.48 8.279-7.416-3.967-7.417 3.967 1.481-8.279-6.064-5.828 8.332-1.151z"/>
                            </svg>
                        </span> 
                        
                        <span style="font-size: 32px; font-weight: 800; color: #000;">
                            <%-- [확인] Map Key는 XML에서 지정한 이름(snake_case) 그대로 둡니다 --%>
                            <c:choose>
                                <c:when test="${reviewSummary.avg_score > 0}">
                                    <fmt:formatNumber value="${reviewSummary.avg_score}" pattern="0.0" />
                                </c:when>
                                <c:otherwise>0.0</c:otherwise>
                            </c:choose>
                        </span>
                
                        <div style="width: 1px; height: 30px; background: #eee; margin: 0 15px;"></div>
                        
                        <div style="font-size: 14px; color: #333;">
                            <div>
                                <strong style="color: #003F96;">${reviewSummary.best_rate != null ? reviewSummary.best_rate : 0}%</strong>가 <b>아주 좋아요</b> 라고 평가했습니다.
                            </div>
                            <div style="color: #999; font-size: 13px; margin-top: 3px;">
                                리뷰 ${reviewSummary.total_cnt != null ? reviewSummary.total_cnt : 0}개
                            </div>
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
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="16 9 12 15 8 11"></polyline>
                            </svg>
                            <span style="letter-spacing:-0.5px; margin-top:2px;">포토리뷰 먼저 보기</span>
                        </button>
                
                        <div class="search-box" style="position:relative; width: 200px;">
                            <svg style="position:absolute; left:10px; top:50%; transform:translateY(-50%); width:16px; height:16px; stroke:#999;" viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <input type="text" id="searchKeyword" placeholder="리뷰 키워드 검색" onkeyup="handleSearchKey(event)" 
                                   style="width:100%; height:34px; border:1px solid #ddd; border-radius:4px; padding-left:32px; padding-right:10px; box-sizing:border-box; font-size:13px;">
                        </div>
                    </div>
                </div>

                <%-- 리뷰 리스트 로드 영역 --%>
                <div class="review-content-area" id="reviewListArea">
                    <jsp:include page="review_list.jsp" />
                </div>
                
            </div>
        </div>

        <%-- [2] 리뷰 작성 화면 --%>
        <div id="reviewWriteView" style="height:100%; display:none; flex-direction:column;">
            
            <div class="head">
                <div class="goods-info">
                    <div class="photo">
                        <img src="${not empty product.imageUrl ? product.imageUrl : '//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS253IP02F003_734.jpg'}" alt="상품이미지">
                    </div>
                    <div class="info">
                        <p class="txt1">후기 작성</p>
                    </div>
                </div>
                <button type="button" class="close__btn" onclick="switchToList()">close</button>
            </div>

            <div class="con" style="flex:1; overflow-y:auto; padding: 0 20px;">
                <%-- [수정] action URL -> /review/write.do --%>
                <form id="reviewForm" action="${pageContext.request.contextPath}/review/write.do" method="post" enctype="multipart/form-data">
                    <%-- [수정] name="productNo" -> name="productId" --%>
                    <input type="hidden" name="productId" value="${product.productId}">
                    
                    <%-- 별점 선택 --%>
                    <div style="text-align:center; padding: 40px 0; border-bottom:1px solid #eee;">
                        <p style="font-weight:700; font-size: 18px; margin-bottom:20px; color:#000;">상품은 만족하셨나요?</p>
                        <div class="stars-wrap" style="display:flex; justify-content:center; gap:8px; cursor:pointer;" id="starBox">
                            <%-- [수정] name="reviewScore" -> name="rating" --%>
                            <input type="hidden" name="rating" id="reviewScore" value="5">
                            
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
        
                    <%-- 내용 입력 --%>
                    <div style="padding: 30px 0;">
                        <label style="display:block; font-weight:700; font-size: 17px; margin-bottom:15px; color:#000;">내용 입력</label>
                        <%-- [수정] name="reviewContent" -> name="content" --%>
                        <textarea name="content" style="width:100%; height:220px; padding:20px; border:1px solid #ddd; resize:none; box-sizing:border-box; font-size: 16px; line-height: 1.6;" 
                                  placeholder="착용감, 사이즈 등 솔직한 후기를 남겨주세요."></textarea>
                    </div>
        
                    <%-- 사진 첨부 --%>
                    <div style="padding-bottom:30px; border-top: 1px solid #f9f9f9; padding-top: 20px;">
                        <label style="display:block; font-weight:700; font-size: 17px; margin-bottom:15px; color:#000;">
                            사진 첨부 
                            <span id="fileCount" style="font-size:14px; color:#003F96; font-weight:bold; margin-left:5px;">(0/4)</span>
                        </label>
                        
                        <div style="margin-top:10px;">
                            <%-- [수정] name="reviewFiles" -> name="reviewFile" (Controller @RequestParam과 일치) --%>
                            <input type="file" id="reviewFiles" name="reviewFile" accept="image/*" multiple onchange="handleImgPreview(this)" style="font-size: 15px;">
                        </div>
                        
                        <div id="imgPreviewBox" style="display:flex; gap:10px; margin-top:15px; flex-wrap:wrap; min-height: 20px;"></div>
                    </div>
        
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
var isPhotoFirst = false; 
var currentSort = "date"; 

// 1. [정렬]
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

// 2. [검색어 엔터]
function handleSearchKey(e) {
    if (e.keyCode === 13) searchReviews();
}

// 3. [리스트 로드] AJAX
function searchReviews() {
    // [수정] product_id -> productId
    var productId = "${product.productId}";
    var keyword = $("#searchKeyword").val();
    
    var finalSort = currentSort;
    if (isPhotoFirst) {
        if (currentSort === 'date') finalSort = "photo";
        else finalSort = "photo_rate";
    }

    $.ajax({
        // [수정] URL: /review/list.htm -> /review/list
        url: "${pageContext.request.contextPath}/review/list",
        type: "GET",
        // [수정] 파라미터명: product_id -> productId
        data: { 
            productId: productId,
            sort: finalSort,
            keyword: keyword
        },
        dataType: "html",
        success: function(htmlFragment) {
            $("#reviewListArea").html(htmlFragment);
            if (typeof checkReviewHeightLocal === 'function') checkReviewHeightLocal();
        },
        error: function(err) { console.log("리스트 로드 실패", err); }
    });
}

function togglePhotoFilter(btn) {
    isPhotoFirst = !isPhotoFirst; 
    $(btn).toggleClass("active"); 
    searchReviews(); 
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
        if (this.scrollHeight > this.clientHeight) $(this).next(".more-btn-wrap").show();
        else $(this).next(".more-btn-wrap").hide();
    });
}

function openReviewModal() {
    $('#reviewModal').fadeIn(200);
    $('body').addClass('no-scroll');
    switchToList();
    setTimeout(function() { checkReviewHeight(); }, 50);
}

function closeReviewModal() {
    $('#reviewModal').fadeOut(200);
    $('body').removeClass('no-scroll');
    resetWriteForm();
}

function switchToWrite() {
    // [수정] 세션 변수명 auth.userNumber 등으로 접근 가능
    var isLogOut = ${empty sessionScope.auth}; 
    if (isLogOut) {
        alert("로그인이 필요한 기능입니다.");
        location.href = "${pageContext.request.contextPath}/login.htm";
        return; 
    }
    resetWriteForm(); 
    $('#reviewListView').hide(); 
    $('#reviewWriteView').css('display', 'flex'); 
}

function resetWriteForm() {
    sel_files = [];
    $("#imgPreviewBox").empty();
    $("#reviewFiles").val("");
    // [수정] name="reviewContent" -> name="content"
    $("textarea[name='content']").val("");
    setRating(5);
    $("#scoreText").text("아주 좋아요");
    $(".write-star-svg").css("fill", "#003F96");
    $("#fileCount").text("(0/4)");
}

function switchToList() {
    $('#reviewWriteView').hide();
    $('#reviewListView').css('display', 'flex');
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

// [AJAX] 리뷰 등록
function submitReviewAjax() {
    // [수정] content로 변경
    var content = $("textarea[name='content']").val();
    var rating = $("#reviewScore").val();
    var productId = $("input[name='productId']").val();

    if (!content) { alert("내용을 입력해주세요."); return; }

    var formData = new FormData();
    // [수정] 파라미터 이름 Controller와 일치시킴
    formData.append("productId", productId);
    formData.append("content", content);
    formData.append("rating", rating);
    
    // [중요] 파일 파라미터 이름을 'reviewFile'로 통일 (List<MultipartFile> 또는 단일 처리)
    for (var i = 0; i < sel_files.length; i++) {
        formData.append("reviewFile", sel_files[i]);
    }

    $.ajax({
        // [수정] URL: /review/write.do
        url: "${pageContext.request.contextPath}/review/write.do",
        type: "POST",
        data: formData,
        processData: false, 
        contentType: false, 
        dataType: "text", // 리턴타입에 따라 변경 (보통 String 리턴이면 text)
        success: function(res) {
            // Controller에서 "common/message"를 리턴하면 HTML이 옴. 
            // 만약 JSON을 리턴한다면 로직 변경 필요. 여기선 성공으로 간주하고 리로드.
            alert("리뷰가 등록되었습니다.");
            location.reload(); 
        },
        error: function(err) {
            alert("등록 중 오류가 발생했습니다.");
            console.log(err);
        }
    });
}

function handleLike(btn, reviewId, type) {
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) { alert("로그인이 필요한 기능입니다."); location.href = "${pageContext.request.contextPath}/login.htm"; return; }
    
    $.ajax({
        // [수정] URL: /review/like (가정)
        url: "${pageContext.request.contextPath}/review/like",
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
            else { alert("오류 발생"); }
        },
        error: function() { alert("통신 오류"); }
    });
}

function checkReviewPermission() {
    var user = "${sessionScope.auth}"; 
    if (!user) {
        alert("로그인이 필요한 서비스입니다.");
        location.href = "/login.htm";
        return;
    }
    // [수정] Controller에서 Model로 넘겨준 구매여부 변수
    var canReview = ${canReview != null ? canReview : 'false'}; 

    if (canReview) {
        switchToWrite(); 
    } else {
        alert("구매확정된 상품에 한해 작성 가능합니다.");
    }
}
</script>