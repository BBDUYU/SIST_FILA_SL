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
           			<h2 class="tit__style4" style="user-select: auto !important;">로그인 관리</h2>
					
					<!-- 로그인 관리 -->
				<div class="my-login-box" style="user-select: auto !important;">
					<ul style="user-select: auto !important;">
	
						<li style="user-select: auto !important;">
							<p style="user-select: auto !important;">
								<svg xmlns="http://www.w3.org/2000/svg" width="14.12" height="14" viewBox="0 0 14.12 14" style="user-select: auto !important;">
									<path id="패스_132" data-name="패스 132" d="M563.574,195.493,558.339,188H554v14h4.546v-7.493L563.78,202h4.34V188h-4.546Z" transform="translate(-554 -188.001)" fill="#03c75a" style="user-select: auto !important;"></path>
								</svg>

								<span style="user-select: auto !important;">네이버 연동하기</span>
							</p>

							<div class="chk" style="user-select: auto !important;">
								<input type="checkbox" id="snsLogin02" onclick="javascript:connectChk('NV');$(this).prop('checked',false);void(0);" style="user-select: auto !important;">
								<label for="snsLogin02" style="user-select: auto !important;">on/off</label>
							</div>
						</li>
	
						<li style="user-select: auto !important;">
	
	
							<p style="user-select: auto !important;">
								<svg id="그룹_70" data-name="그룹 70" xmlns="http://www.w3.org/2000/svg" width="17" height="15.85" viewBox="0 0 17 15.85" style="user-select: auto !important;">
									<path id="패스_8" data-name="패스 8" d="M190.665,193.223c-4.695,0-8.5,3.026-8.5,6.758a6.5,6.5,0,0,0,3.691,5.573l-.614,3.294a.189.189,0,0,0,.29.192l3.651-2.405s.976.1,1.482.1c4.694,0,8.5-3.025,8.5-6.758s-3.806-6.758-8.5-6.758" transform="translate(-182.165 -193.223)" fill="#3c1e1e" style="user-select: auto !important;"></path>
								</svg>

								<span style="user-select: auto !important;">카카오 연동하기</span>
								<span class="date" style="user-select: auto !important;">2025-11-30</span>
							</p>

							<div class="chk" style="user-select: auto !important;">
								<input type="checkbox" id="snsLogin01" checked="" onclick="javascript:snsClear('01','4614269245');$(this).prop('checked',true);void(0);" style="user-select: auto !important;">
								<label for="snsLogin01" style="user-select: auto !important;">on/off</label>
							</div>

						</li>

						<!-- <li>
							<p>
								<img src="/mo/resource/images/sub/ico_toss_20x18.png" alt="" />
						
								<span>토스 연동하기</span>
							</p>
						
							<div class="chk">
								<input type="checkbox" id="snsLogin03">
								<label for="snsLogin03">on/off</label>
							</div>
						</li> -->
					</ul>
				</div>
					<!-- //로그인 관리 -->
					
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
