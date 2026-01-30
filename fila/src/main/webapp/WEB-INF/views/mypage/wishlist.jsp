<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>위시리스트 | FILA</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/normalize.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/opt-default.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sub.css">

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/js/jquery-1.12.4.js"></script>

</head>

<body>

<jsp:include page="/view/common/header.jsp"/>
<jsp:include page="/view/mypage/mypage.jsp"/>

	<section class="my-con wishlist">
  <h2 class="tit__style4">위시리스트</h2>

  <div class="odr-box">
    <form name="form5">
      <div class="odr-hd">
        <div>
          <input type="checkbox" id="checkAll" title="상품 선택" class="cb__style1">
          <label for="checkAll">선택</label>
        </div>
        <div class="txt-btn">
          <a href="javascript:void(0);" id="btnDeleteSelected">선택삭제</a>
        </div>
      </div>

      <ul class="odr__list __my_chk">
		  <c:choose>
		    <c:when test="${empty wishList}">
		      <p class="odr-txt_none">위시리스트가 비었습니다.</p>
		    </c:when>
		
		    <c:otherwise>
		      <c:forEach var="w" items="${wishList}" varStatus="st">
		        <li>
		
		          <!-- ✅ 공홈처럼: 체크박스 + label -->
		          <div class="_soldout">
		            <c:set var="cid" value="checkwish${st.index}" />
		            <input type="checkbox"
		                   id="${cid}"
		                   name="checkwish"
		                   value="${w.wishlist_id}"
		                   class="cb__style1 wishChk">
		            <label for="${cid}">선택</label>
		          </div>
		
		          <!-- ✅ 공홈처럼 썸네일 -->
		          <div class="goods-thumb">
		            <a href="${pageContext.request.contextPath}/product/product_detail.htm?product_id=${w.product_id}">
		              <img src="${w.image_url}" alt="${w.product_name}"
		                   onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
		            </a>
		          </div>
		
		          <!-- ✅ 공홈처럼 상품정보 -->
		          <div class="goods-info">
		            <p class="sex">FILA</p>
		            <p class="tit">${w.product_name}</p>
		            <p class="info">${w.size_text}</p>
		            <p class="price">
		              <span class="sale"><fmt:formatNumber value="${w.price}" pattern="#,###"/>원</span>
		            </p>
		          </div>
		
		          <!-- ✅ 공홈처럼 우측 버튼 -->
		          <div class="goods-etc">
		            <p class="ico">
		              <button type="button"
						      class="btn_review"
						      onclick="openReviewFromWishlist('${w.product_id}')">
						리뷰보기
						</button>
		              <!-- ❗class/id 변경 금지라서 del + btnDelOne 같이 둠 -->
		              <button type="button"
		                      class="del btnDelOne"
		                      data-wishid="${w.wishlist_id}">
		                삭제
		              </button>
		            </p>
		            <p class="btn-box"></p>
		          </div>
		
		        </li>
		      </c:forEach>
		    </c:otherwise>
		  </c:choose>
		</ul>
      
    </form>
  </div>
</section>

</div>
</div>
<jsp:include page="/view/common/footer.jsp"/>

<script>
(function(){
  const $ = window.jQuery;
  const ctx = "${pageContext.request.contextPath}";

  // ✅ returnUrl: 현재 페이지 그대로 돌아오게
  function getReturnUrl(){
    return encodeURIComponent(location.pathname + location.search);
  }

  /* ===============================
     0) 전체 선택 (checkAll)
  =============================== */
  $('#checkAll').on('change', function(){
    $('.wishChk').prop('checked', this.checked);
  });

  // ✅ 개별 체크 변경하면 checkAll 상태도 맞추기
  $('.odr__list').on('change', '.wishChk', function(){
    const total = $('.wishChk').length;
    const checked = $('.wishChk:checked').length;
    $('#checkAll').prop('checked', total > 0 && total === checked);
  });

  /* ===============================
     1) 단건 삭제 (.btnDelOne)
  =============================== */
  $('.odr__list').on('click', '.btnDelOne', function(){
    const id = $(this).data('wishid');
    if(!id) return;

    if(!confirm('삭제하시겠습니까?')) return;

    location.href =
      ctx + "/mypage/wish/delete.htm?wishlist_id=" + encodeURIComponent(id)
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
      ctx + "/mypage/wish/deleteSelected.htm?ids=" + encodeURIComponent(ids.join(','))
      + "&returnUrl=" + getReturnUrl();
  });

})();
</script>

<script>
/* ✅ [수정] 위시리스트에서 리뷰 모달을 product_detail과 동일 스타일로 띄우기 */
function openReviewFromWishlist(productId) {
  const CTX = "${pageContext.request.contextPath}";

  fetch(CTX + "/product/product_detail.htm?product_id=" + encodeURIComponent(productId))
    .then(res => res.text())
    .then(html => {
      const temp = document.createElement("div");
      temp.innerHTML = html;

      // ✅ 1) product_detail의 CSS들을 wishlist <head>에 주입 (중복은 자동 방지)
      injectDetailStyles(temp);

      // ✅ 2) 리뷰 모달만 추출
      const modal = temp.querySelector("#reviewModal");
      if (!modal) {
        alert("리뷰 모달(#reviewModal)을 찾지 못했습니다.");
        return;
      }

      // ✅ 3) 위시리스트 페이지에 꽂기
      const container = document.getElementById("reviewModalContainer");
      container.innerHTML = "";
      container.appendChild(modal);

      // ✅ 4) product_detail에서 모달 스타일이 body class(view__style1)에 걸려있을 수 있어서
      //       모달 열릴 동안만 body에 클래스 추가
      document.body.classList.add("view__style1");

      // ✅ 5) 열기
      modal.style.display = "block";
      document.body.style.overflow = "hidden";

      // ✅ 6) 닫기 함수는 wishlist에서 확실히 먹게 “추가만”으로 오버라이드
      window.closeReviewModal = function () {
        const m = document.getElementById("reviewModal");
        if (m) m.style.display = "none";
        document.body.style.overflow = "auto";
        document.body.classList.remove("view__style1"); // ✅ 원복
      };

      // ✅ 7) 모달 내부에 swiper/높이체크 같은게 있다면, 실행 트리거 (있을 때만)
      if (typeof window.checkReviewHeightLocal === "function") {
        setTimeout(window.checkReviewHeightLocal, 120);
      }
    })
    .catch(err => {
      console.error(err);
      alert("리뷰 로딩 실패");
    });
}

/* ✅ [추가] product_detail의 CSS를 wishlist head에 주입 */
function injectDetailStyles(tempRoot) {
  const head = document.head;

  // product_detail의 <link rel="stylesheet">를 전부 가져와서 head에 넣기
  const links = tempRoot.querySelectorAll('link[rel="stylesheet"][href]');
  links.forEach(l => {
    const href = l.getAttribute("href");
    if (!href) return;

    // ✅ 이미 같은 href가 있으면 스킵 (중복 방지)
    const exists = head.querySelector('link[rel="stylesheet"][href="' + href + '"]');
    if (exists) return;

    const newLink = document.createElement("link");
    newLink.rel = "stylesheet";
    newLink.href = href;
    head.appendChild(newLink);
  });

  // 혹시 product_detail이 head에 <style>로 모달 스타일을 박아놨으면 그것도 복사
  const styles = tempRoot.querySelectorAll("style");
  styles.forEach(s => {
    const css = (s.textContent || "").trim();
    if (!css) return;

    // 너무 많이 복사하면 과할 수 있어서, 'review' / 'common__layer' 관련만 골라서 주입
    if (css.includes("common__layer") || css.includes("_review") || css.includes("review")) {
      const tag = document.createElement("style");
      tag.textContent = css;
      head.appendChild(tag);
    }
  });
}
</script>

<!-- ✅ [추가] 리뷰 모달이 삽입될 자리 -->
<div id="reviewModalContainer"></div>

</body>
</html>