<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>1:1 문의 | FILA</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/normalize.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/opt-default.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sub.css">

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>

    <!-- 🔥 모달 강제 표시용 보정 CSS -->
    <style>
        .common__layer {
            position: fixed !important;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 9999 !important;
            display: none;
        }
        .common__layer .layer_dim {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,.6);
        }
        .common__layer .inner {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: #fff;
            width: 90%;
            max-width: 420px;
            border-radius: 8px;
            padding: 20px;
        }
        .common__layer .head {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>

<body>

<jsp:include page="/view/common/header.jsp"/>
<jsp:include page="/view/mypage/mypage.jsp"/>

<section class="my-con" style="user-select: auto !important;">
           			<h2 class="tit__style4" style="user-select: auto !important;">A/S 현황 조회</h2>
					
				<!-- A/S 현황 조회 -->
				<form name="asForm" method="post" style="user-select: auto !important;">
				<input type="hidden" name="brndNm" id="brndNm" value="" style="user-select: auto !important;">
				<div class="as-box" style="user-select: auto !important;">
					<p class="txt" style="user-select: auto !important;">A/S 접수증 하단에 있는 바코드 번호를 입력해 주세요.</p>

					<div class="coupon-inp-box" style="user-select: auto !important;">
						<input type="text" class="ipt" id="asnum" name="asnum" placeholder="바코드 번호" maxlength="7" onkeyup="ReturnAsVal(this,'');" style="user-select: auto !important;">

						<div style="user-select: auto !important;">
							<button type="button" onclick="asinfo2();" style="user-select: auto !important;">조회</button>
						</div>
					</div>
					<div class="srh-error" id="errorTxt" style="color: red; width: 100%; text-align: right; margin-top: 15px; user-select: auto !important;"></div>
					<!-- AS 기본 정보 -->
					<div class="as-info-box code-info" style="display: none; user-select: auto !important;">
					</div>
					<!-- //AS 기본 정보 -->
				</div>
				</form>
				<!-- //A/S 현황 조회 -->
					
				</section>

</div>
</div>
<jsp:include page="/view/common/footer.jsp"/>

<!-- ===================== -->
<!-- 🔥 JS : 이것만 있으면 무조건 뜸 -->
<!-- ===================== -->
<script>
$(function () {

    $('#btnOpenQna').on('click', function () {
        alert('버튼 눌림');   // ← 이거 뜨면 100% 정상
        $('#qnaWriteLayer').show();
    });

    $('#btnCloseQna, .layer_dim').on('click', function () {
        $('#qnaWriteLayer').hide();
    });

});
</script>

</body>
</html>
