<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="no-js" lang="ko-KR">
<!--[if IE 6]> <html class="no-js lt-ie10 lt-ie9 lt-ie8 ie6" lang="ko-KR"> <![endif]-->
<!--[if IE 7]> <html class="no-js lt-ie10 lt-ie9 lt-ie8 ie7" lang="ko-KR"> <![endif]-->
<!--[if IE 8]> <html class="no-js lt-ie10 lt-ie9 ie8" lang="ko-KR"> <![endif]-->
<!--[if IE 9]> <html class="no-js lt-ie10 ie9" lang="ko-KR"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="ko-KR"> <!--<![endif]-->
<head>

<!-- End Google Tag Manager -->
<!-- #HJ 2020-05-27 Google optimize 2022-04-28 제거함 -->

	<meta charset="UTF-8">
	<meta name="format-detection" content="telephone=no">

<title>위시리스트 | FILA</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.1, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">

<link rel="icon" type="image/x-icon" href="//filacdn.styleship.com/filacontent2/favicon.ico" />

<link rel="stylesheet" href="http://localhost/SIST_FILA/css/layout.css">
<link rel="stylesheet" href="http://localhost/SIST_FILA/css/normalize.css" />
<link rel="stylesheet" href="http://localhost/SIST_FILA/css/opt-default.css" >
<link rel="stylesheet" href="http://localhost/SIST_FILA/css/product.css">
<link rel="stylesheet" href="http://localhost/SIST_FILA/css/SpoqaHanSansNeo.css">
<link rel="stylesheet" href="http://localhost/SIST_FILA/css/sub.css">
<link rel="stylesheet" href="http://localhost/SIST_FILA/css/swiper-bundle.css">

<script src="http://localhost/SIST_FILA/js/default.js"></script>
<script src="http://localhost/SIST_FILA/js/jquery-1.12.4.js"></script>
<script src="http://localhost/SIST_FILA/js/matizResizeMap.1.0.0.js"></script>
<script src="http://localhost/SIST_FILA/js/mighty.base.1.5.7.js"></script>
<script src="http://localhost/SIST_FILA/js/swiper-bundle.js"></script>
<script src="http://localhost/SIST_FILA/js/TweenMax.js"></script>

<!-- 개별 css, js -->
<script src="https://www.fila.co.kr/pc/resource/js/pages/mypage.js"></script>
<script>
        // 개별 삭제
        function deleteWish(wishId) {
            if(confirm("정말 삭제하시겠습니까?")) {
                // TODO: 나중에 실제 삭제 페이지로 연결
                alert("삭제 기능: wishlist_delete.jsp?wish_id=" + wishId);
            }
        }

        // 장바구니 담기
        function addToCart(productId) {
            if(confirm("장바구니에 담으시겠습니까?")) {
                // TODO: 나중에 실제 장바구니 페이지로 연결
                alert("장바구니 기능: cart_add.jsp?product_id=" + productId);
            }
        }

        // 선택 삭제 (체크박스)
        function deleteSelected() {
            var checked = $("input[name=checkwish]:checked");
            if(checked.length == 0) {
                alert("삭제할 상품을 선택해주세요.");
                return;
            }
            if(confirm("선택한 " + checked.length + "개 상품을 삭제하시겠습니까?")) {
                alert("선택 삭제 기능 실행");
            }
        }

        // 전체 선택 체크박스
        $(document).ready(function(){     
            $("#checkAll").click(function(){
                $("input[name=checkwish]").prop("checked", $("#checkAll").prop("checked"));
            });
        });
    </script>

</head>
<body class="">
	<!-- start of :: wrap -->
	<div id="wrap">
		<!-- header include -->
		<jsp:include page="common/header.jsp" />
		
		<!-- start of :: contents -->
		<div id="contents" class="mypage__contents">

			<div class="mypage__tab">
				<div class="inner">
					<!-- 회원등급, 회원정보 -->
					<div class="my-info-box">
						<div class="top">
							<p class="level">WHITE</p>
							<a href="#" class="benefit__btn">혜택보기</a>
						</div>
						<p class="name">
							<span>${sessionScope.userName}</span>님
						</p>
						<a href="#" class="info-modify__btn">내 정보 변경</a>

					</div>
					<!-- 쿠폰, 포인트, 위시리스트, 주문내역 -->
					<div class="my-link-box">
                        <div><a href="#"><dl><dt>쿠폰</dt><dd>0개</dd></dl></a></div>
                        <div><a href="#"><dl><dt>포인트</dt><dd>0P</dd></dl></a></div>
                        <div><a href="#"><dl><dt>위시리스트</dt><dd>0개</dd></dl></a></div>
                        <div><a href="#"><dl><dt>주문내역</dt><dd>0건</dd></dl></a></div>
                    </div>
				</div>
			</div>



			<div class="mypage__area">

				<div class="my-lnb">
           			<h2 class="tit__style4">마이페이지</h2>
					<div>
						<p class="tit">쇼핑정보</p>
						<ul>
							<li><a href="#">주문 · 배송 조회</a></li>
                            <li><a href="#">교환 · 취소 · 반품 조회</a></li>
                            <li><a href="#">리뷰</a></li>
						</ul>
					</div>
					<div>
						<p class="tit">상품정보</p>
						<ul>
							<li  class='on'><a href="wishlist.jsp" >위시리스트</a> </li>
							<li ><a href="#">오늘 본 상품</a></li>
							<li ><a href="#">커스텀 스튜디오</a></li>
							<li ><a href="#">재입고 알림</a></li>
						</ul>
					</div>
					<div>
						<p class="tit">회원정보</p>
						<ul>
							<li><a href="#" class="#">내 정보 변경</a></li>
							<li ><a href="#">배송지 관리</a></li>
							<li ><a href="#">로그인 관리</a></li>
						</ul>
					</div>
					<div>
						<p class="tit">고객센터</p>
						<ul>
							<li ><a href="#">1:1 문의</a></li>
							<li ><a href="#">A/S 현황 조회</a></li>
						</ul>
					</div>
				</div>

				<section class="my-con wishlist">
           			<h2 class="tit__style4">위시리스트</h2>

					<div class="odr-box">
                        <div class="odr-hd">
                            <div>
                                <input type="checkbox" id="checkAll" title="상품 선택" class="cb__style1" />
                                <label for="checkAll">선택</label>
                            </div> 
                            <div class="txt-btn">
                                <a href="javascript:void(0);" onclick="deleteSelected()">선택삭제</a>
                            </div>
							
						</div>
						<ul class="odr__list __my_chk">

							<li>
							
								<div class="_soldout">
							
									<input type="checkbox" id="checkwish1" name="checkwish" value="60451"  class="cb__style1" />
									<label for="checkwish1">선택</label>

								</div>
								<div class="goods-thumb"><a href="#"><img src="//filacdn.styleship.com/filaproduct2/data/productimages/a/2/FS253FT01X001_234.jpg" alt="샘플상품"></a></div>
								<div class="goods-info">
									<p class="sex">FILA</p>
									<p class="tit">1911 유니 니트트랙 집업</p>
									<p class="info">BROWN/DARK BROWN</p>
									<p class="price">
										<span class="sale">119,000원</span> 

									</p>
								</div>
								<div class="goods-etc">
									<p class="ico">
										<!-- 2023-04-26 리뷰보기 버튼 추가 -->
										<button type="button" class="btn_review">리뷰보기</button>
										<!-- // 2023-04-26 리뷰보기 버튼 추가 -->
										<button type="button" class="del" onclick="deleteWish('60451')">삭제</button>
									</p>
									<p class="btn-box" >
										<!--button type="button" class="btn_sld__gr Wishoption-change__btn" data-no="362865">옵션변경</button-->
										
									</p>
								</div>
							</li>

						</ul>
				</form>
					</div>	
				</section>
			</div>

		</div>

		<!-- // end of :: contents -->

		<!-- 하단 고정 버튼 (top, sns) -->
<div class="bot-fix-box">
	<div class="inner">

		<!-- 2023-12-13 오늘 본 상품 있는 경우 (상품 썸네일 변경) -->
		<button type="button" class="today-goods__thumb today-goods__btn">
			<img src="//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS254DJ01F001_561.jpg" alt="">
		</button>
		<!-- // 2023-12-13 오늘 본 상품 있는 경우 (상품 썸네일 변경) -->

		<button type="button" class="top__btn" onclick="window.scrollTo(0,0);">top</button>		
	</div>
</div>
<!-- //하단 고정 버튼 (top, sns) -->

<!-- footer clude -->
<jsp:include page="common/footer.jsp" />



	</div>
    <!-- // end of :: wrap -->  
    
    <script>
        window.addEventListener("pageshow", function(event) {
            if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
                window.location.reload();
            }
        });
    </script>
      
</body>
</html>