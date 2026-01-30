<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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