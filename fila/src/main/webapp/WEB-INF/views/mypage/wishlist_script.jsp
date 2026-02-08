<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
(function(){
  const $ = window.jQuery;
  const CTX = "${pageContext.request.contextPath}";

  // ✅ returnUrl: 현재 페이지 그대로 돌아오게
  function getReturnUrl(){
    const path = location.pathname.startsWith(CTX)
      ? location.pathname.substring(CTX.length)
      : location.pathname;
    return encodeURIComponent(path + location.search);
  }

  /* ===============================
     0) 전체 선택 (checkAll)
  =============================== */
  $('#checkAll').on('change', function(){
    $('.wishChk').prop('checked', this.checked);
  });

  $('.odr__list').on('change', '.wishChk', function(){
    const total = $('.wishChk').length;
    const checked = $('.wishChk:checked').length;
    $('#checkAll').prop('checked', total > 0 && total === checked);
  });

  /* ===============================
     1) 단건 삭제 (.btnDelOne)
     - "선택삭제 컨트롤러"로 1개만 ids 넘겨서 재사용
  =============================== */
  $('.odr__list').on('click', '.btnDelOne', function(){
    const id = $(this).data('wishid');
    if(!id) return;

    if(!confirm('삭제하시겠습니까?')) return;

    location.href =
      CTX + "/mypage/wishDeleteSelected.htm?ids=" + encodeURIComponent(id)
      + "&returnUrl=" + getReturnUrl();
  });

  /* ===============================
     2) 선택 삭제 (#btnDeleteSelected)
  =============================== */
  $('#btnDeleteSelected').on('click', function(){
    const ids = $('.wishChk:checked').map(function(){ return this.value; }).get();
    if(ids.length === 0){
      alert('삭제할 상품을 선택하세요.');
      return;
    }
    if(!confirm('선택한 상품을 삭제하시겠습니까?')) return;

    location.href =
      CTX + "/mypage/wishDeleteSelected.htm?ids=" + encodeURIComponent(ids.join(','))
      + "&returnUrl=" + getReturnUrl();
  });

})();
</script>

<script>
/* =========================================
   ✅ 리뷰보기 (버튼 onclick 유지)
   - fetch로 상세페이지 HTML 가져오지 않음
   - wishlist.jsp에 이미 있는 #reviewModal을 그냥 열고,
     productId만 주입해서 searchReviews()가 그걸로 조회하게 함
========================================= */
window.openReviewFromWishlist = function (productId) {
	  const CTX = "${pageContext.request.contextPath}";

	  // 1) 모달 존재 확인
	  const modal = document.getElementById("reviewModal");
	  if (!modal) {
	    alert("wishlist.jsp에 #reviewModal이 없습니다. (include 위치 확인)");
	    return;
	  }

	  // 2) 위시리스트에서 클릭한 상품의 이름/썸네일 찾기
	  const items = document.querySelectorAll(".odr__list li");
	  let productName = "";
	  let productImg = "";
	  
	  items.forEach(li => {
	    const a = li.querySelector(".goods-thumb a");
	    if (!a) return;

	    const u = new URL(a.getAttribute("href"), location.origin);
	    const pid = u.searchParams.get("productId") || u.searchParams.get("product_id");
	    if (pid !== productId) return;

	    const tit = li.querySelector(".goods-info .tit");
	    const img = li.querySelector(".goods-thumb img");
	    productName = tit ? tit.textContent.trim() : "";
	    productImg = img ? img.getAttribute("src") : "";
	  });

	  // 3) 모달 헤더에 상품명 세팅
	  const nameEl = modal.querySelector(".goods-info .info .txt1");
	  if (nameEl) nameEl.textContent = productName || "상품명";

	  // 4) productId hidden 값 세팅(리스트뷰/작성뷰 둘 다 있을 수 있어서 전체 세팅)
	  modal.querySelectorAll('input[name="productId"]').forEach((i) => {
	    i.value = productId;
	  });

	  // 5) ✅ 이미지 세팅 (리스트뷰/작성뷰의 img가 2개라서 전부 바꿔야 안 틀어짐)
	  const mainImgUrl =
	    CTX +
	    "/displayImage.do?path=" +
	    encodeURIComponent(
	      "C:/fila_upload/product/" + productId + "/" + productId + "_main_1.jpg"
	    );

	  modal.querySelectorAll(".goods-info .photo img").forEach((img) => {
	    img.onerror = null; // 기존 onerror 초기화
	    img.src = mainImgUrl;
	    img.onerror = function () {
	      this.src = CTX + "/images/no_image.jpg";
	    };
	  });

	  // (선택) 위시리스트 썸네일을 그대로 쓰고 싶으면 위 mainImgUrl 대신 아래 주석 해제해서 사용
	  // if (productImg) {
	  //   modal.querySelectorAll(".goods-info .photo img").forEach(img => img.src = productImg);
	  // }

	  // 6) 리뷰 조회에서 사용할 productId 전역 저장
	  window.__REVIEW_PRODUCT_ID__ = productId;

	  // 7) 모달 오픈 + 리뷰 로딩
	  modal.style.display = "block";
	  document.body.style.overflow = "hidden";

	  if (typeof window.switchToList === "function") window.switchToList();
	  if (typeof window.searchReviews === "function") window.searchReviews();
	};
</script>