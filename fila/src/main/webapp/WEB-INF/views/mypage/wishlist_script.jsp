<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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