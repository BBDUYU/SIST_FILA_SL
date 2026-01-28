<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="no-js" lang="ko-KR">
<head>
    <meta charset="UTF-8">
    <meta name="format-detection" content="telephone=no">
    <title>공지사항 | FILA</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.1, minimum-scale=1.0, user-scalable=no">
	
<style>
.not_info-box {
    background-color: transparent !important; /* 배경색 완전 제거 */
    border: none !important;                /* 테두리 제거 (필요시) */
    min-height: 0 !important;               /* 최소 높이 해제 */
}

#noticeImgView {
    display: block;
    width: 100%;       /* 가로 너비는 영역에 맞춤 */
    height: auto;      /* 세로는 원본 비율 유지 */
}

/* 클릭된 항목(active)의 제목 아래에 검은색 밑줄 추가 */
.notice-item.active {
    border-bottom: 2px solid #000 !important; /* 검은색 두꺼운 밑줄 */
}

.notice-item {
    cursor: pointer;
    padding: 15px 10px;
    border-bottom: 1px solid #eee; /* 기본 밑줄 */
    transition: all 0.3s ease;
}
</style>
</head>
<body>
<jsp:include page="../common/header.jsp" />

<div id="contents" class="cs__contents">
    <div class="cs__area">
        <section class="cs-con">
            <h2 class="tit__style1">고객센터</h2>
            
            <div class="cs__tab-box">
                <a href="#">FAQ</a>
                <a href="#">매장안내</a>
                <a href="#">A/S 안내</a>
                <a href="${pageContext.request.contextPath}/noticeList.htm" class="on">공지사항</a>
                <a href="${pageContext.request.contextPath}/customer/membership.htm">Membership</a>
            </div>

            <div class="notice_sort-box">
			    <select name="category" id="searchCategory" class="sel__style1" onchange="searchNotice()">
				    <option value="" ${empty param.category ? 'selected' : ''}>전체</option>
				    <option value="브랜드" ${param.category == '브랜드' ? 'selected' : ''}>브랜드</option>
				    <option value="E-SHOP" ${param.category == 'E-SHOP' ? 'selected' : ''}>E-SHOP</option>
				    <option value="이벤트" ${param.category == '이벤트' ? 'selected' : ''}>이벤트</option>
				</select>
			    
			    <div class="str_inp-box not_inp-box">
			        <input type="text" id="keyword" class="search_txt" placeholder="검색어 입력" 
			               onkeyup="if(window.event.keyCode==13){searchNotice()}">
			        <div>
			            <button class="search" type="button" onclick="searchNotice()">검색</button>
			        </div>
			    </div>
</div>

            <div class="notice_wrap">
                <div class="not_list-wrap">
                    <div class="not_list-box">
                        <ul class="not_list">
                            <c:choose>
                                <c:when test="${empty noticeList}">
                                    <li style="text-align:center; padding:20px;">등록된 공지사항이 없습니다.</li>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="dto" items="${noticeList}" varStatus="status">
                                        <li class="notice-item ${status.first ? 'active' : ''}" 
                                            onclick="showImage(this, '${dto.image_url}')">
                                            <a href="javascript:void(0);">
                                                <span>${dto.category_name}</span>
                                                <span class="date">
                                                    <fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd"/>
                                                </span>
                                                <p class="title">${dto.title}</p>
                                            </a>
                                        </li>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </ul>

                        <div class="paging">
                            ${pageLink} 
                        </div>
                    </div>
                </div>

                <div class="not_info-box" style="position:relative; background:none; border:none; min-height:auto;">
				    <img id="noticeImgView" src="" style="width:100%; display:none; vertical-align: top;">
				    
				    <div id="emptyMsg" style="text-align:center; padding-top:100px; color:#999;"></div>
				</div>
            </div>
        </section>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script>
$(document).ready(function() {
    // 1. 페이지 로드 시 첫 번째 항목 찾기
    var $firstNotice = $(".notice-item").first();
    
    if ($firstNotice.length > 0) {
        // 2. data 속성이나 인자에서 이미지 경로 가져오기
        // (JSP forEach문 li에 onclick="showImage(this, '${dto.image_url}')"이 있으니 그걸 활용)
        $firstNotice.trigger("click"); 
        
        // 3. 만약 trigger로 안 되면 강제로 함수 호출
        var firstImgUrl = "${noticeList[0].image_url}";
        if(firstImgUrl && firstImgUrl !== 'null') {
            showImage($firstNotice[0], firstImgUrl);
        }
        
        console.log("첫 번째 이미지 즉시 로드 시도");
    }
});

function showImage(li, imgUrl) {
    // 1. 밑줄 효과 처리
    $(".notice-item").removeClass("active");
    $(li).addClass("active");

    var $imgView = $("#noticeImgView");
    var $emptyMsg = $("#emptyMsg");

    // 2. 이미지 주소 처리
    if (imgUrl && imgUrl !== 'null' && imgUrl !== '') {
        var displayUrl = "${pageContext.request.contextPath}/imageDisplay.htm?fileName=" + encodeURIComponent(imgUrl);
        
        // src를 먼저 바꾸고 나서 show()를 해야 바로 뜨는 느낌이 납니다.
        $imgView.attr("src", displayUrl);
        $imgView.show();
        $emptyMsg.hide();
    } else {
        $imgView.hide();
        $emptyMsg.text("등록된 상세 내용(이미지)이 없습니다.").show();
    }
}

function searchNotice() {
    // 1. 카테고리 선택값과 검색어 입력값 가져오기
    var category = $("#searchCategory").val(); 
    var keyword = $("#keyword").val();
    
    // 2. 서버 경로 설정
    var url = "${pageContext.request.contextPath}/noticeList.htm";
    
    // 3. 파라미터 조합 (값이 있을 때만 깔끔하게 보냄)
    url += "?category=" + encodeURIComponent(category);
    url += "&keyword=" + encodeURIComponent(keyword);
    
    // 4. 페이지 이동 (이때 DAO의 selectList가 실행됨)
    location.href = url;
}
</script>

</body>
</html>