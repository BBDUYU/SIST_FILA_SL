<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
$(document).ready(function() {
    // 모델컷 슬라이더 설정
    if ($('.mc__slider').length > 0) {
        new Swiper('.mc__slider', {
            slidesPerView: 1,
            spaceBetween: 0,
            loop: ($('.mc__slider .swiper-slide').length > 1), // 슬라이드가 2장 이상일 때만 루프 실행
            pagination: {
                el: '.mc-swiper-pagination',
                clickable: true,
            },
            autoHeight: true,
            // 슬라이더가 처음엔 안 보였다가 나타날 때 크기를 다시 계산하게 해줌
            observer: true,
            observeParents: true
        });
    }
});
</script>

<script>
    // [리뷰 작성] 버튼 눌렀을 때 호출되는 함수
    function openReviewModal() {
       
        var modal = document.getElementById("reviewModal");
        if(modal) {
            modal.style.display = "block"; // 보이게 설정
            
            // (선택사항) 모달 열릴 때 스크롤 막기
            document.body.style.overflow = "hidden"; 
        } else {
            alert("모달창을 찾을 수 없습니다.");
        }
    }

    // [X] 버튼이나 배경 눌렀을 때 호출되는 함수
    function closeReviewModal() {
        var modal = document.getElementById("reviewModal");
        if(modal) {
            modal.style.display = "none"; // 안 보이게 설정
            
            // 스크롤 다시 풀기
            document.body.style.overflow = "auto";
        }
    }
</script>
<script>
    // [cart 관련 추가 4] 카트담기 클릭 처리
    // - 비로그인: 로그인 페이지로 (returnUrl 포함)
    // - 로그인: 장바구니 add로 (현재 수량 포함)
    
   function goCartAdd() {
    // 1. 사이즈 선택 체크
    var sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    if (!sizeChecked) {
        alert("사이즈를 선택해 주세요");
        return;
    }

    // 2. 로그인 체크 (생략 가능하면 유지)
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) {
        location.href = "${pageContext.request.contextPath}/user/login.jsp";
        return;
    }

    // 3. 값 추출
    var qty = document.getElementById("ProductQuantity").value;
    var combiId = sizeChecked.value; // 이제 여기엔 숫자가 들어있음

    // 4. URL 전송
    location.href = "${addCartBaseUrl}"
        + "&quantity=" + encodeURIComponent(qty)
        + "&combinationId=" + encodeURIComponent(combiId); // 파라미터명 변경 추천
}
</script>

<script>
document.addEventListener("DOMContentLoaded", function () {
  var minusBtn = document.getElementById("qtyMinus");
  var plusBtn  = document.getElementById("qtyPlus");
  var qtyInput = document.getElementById("ProductQuantity");
  var totalEl  = document.getElementById("buytotal");

  // 상품 1개 가격(숫자) - JSP에서 값 주입
  var unitPrice = ${finalPrice}; // 할인 적용된 1개 가격

  function renderTotal(qty) {
    if (!totalEl) return;
    var total = unitPrice * qty;
    totalEl.textContent = total.toLocaleString() + "원";
  }

  function getQty() {
    var v = parseInt(qtyInput.value, 10);
    return isNaN(v) || v < 1 ? 1 : v;
  }

  function setQty(v) {
    if (v < 1) v = 1;
    qtyInput.value = v;
    renderTotal(v);
  }

  if (minusBtn) {
    minusBtn.addEventListener("click", function () {
      setQty(getQty() - 1);
    });
  }

  if (plusBtn) {
    plusBtn.addEventListener("click", function () {
      setQty(getQty() + 1);
    });
  }

  // 첫 로드 시 주문금액 한번 맞춰주기
  setQty(getQty());
});
</script>

<script>
	window.addEventListener("pageshow", function(){
	  var btn = document.getElementById("wishBtn");
	  if(!btn) return;
	
	  // ✅ DB 결과(서버에서 내려준 wished)로 강제
	  var serverWished = ${wished ? "true" : "false"};
	  btn.classList.toggle("on", serverWished);
	});
</script>

<script>
function goBuyNow() {
    // 1. 선택된 사이즈(Combination ID) 가져오기
    var sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    if (!sizeChecked) {
        alert("사이즈를 선택해 주세요");
        return;
    }
    var combinationId = sizeChecked.value;

    // 2. 수량 가져오기 (ID 수정: ProductQuantity)
    var qtyInput = document.getElementById("ProductQuantity");
    var quantity = qtyInput ? qtyInput.value : 1;

    // 3. 로그인 체크
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) {
        alert("로그인이 필요한 서비스입니다.");
        // returnUrl을 포함하여 로그인 후 다시 이 페이지로 오게 설정하면 더 좋습니다.
        location.href = "${pageContext.request.contextPath}/login.htm?returnUrl=" + encodeURIComponent(location.href);
        return;
    }

    // 4. 결제 페이지로 이동
    var productId = "${product.product_id}"; 
    location.href = "${pageContext.request.contextPath}/order/orderForm.htm" 
                 + "?productId=" + productId 
                 + "&quantity=" + quantity 
                 + "&combinationId=" + combinationId;
}
</script>

<script>
(function(){
  // 버튼 상태를 BFCache/뒤로에서도 안정적으로 유지하려고 sessionStorage 사용
  var KEY = "wish_state_${product.product_id}"; // 상품별 키

  window.goWishAdd = function(){
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if(!isLogin){
      location.href = "${loginUrl}";
      return;
    }

    var btn = document.getElementById("wishBtn");
    if(!btn) return;

    var isOn = btn.classList.contains("on");
    var returnUrl = encodeURIComponent(location.pathname + location.search);

    if(isOn){
      // ✅ 즉시 UI 반영 (색 빠짐)
      btn.classList.remove("on");
      sessionStorage.setItem(KEY, "0"); // 내가 OFF 눌렀다고 기록
      location.href = "${wishDeleteUrl}" + "&returnUrl=" + returnUrl;
      return;
    }

    // 찜 추가는 사이즈 필요
    var sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    if(!sizeChecked){
      alert("사이즈를 선택해 주세요");
      return;
    }

    var label = document.querySelector('label[for="'+ sizeChecked.id +'"]');
    var sizeText = label ? label.textContent.trim() : "";

    // ✅ 즉시 UI 반영 (색 채움)
    btn.classList.add("on");
    sessionStorage.setItem(KEY, "1"); // 내가 ON 눌렀다고 기록
    location.href = "${wishAddUrl}"
      + "&returnUrl=" + returnUrl
      + "&sizeText=" + encodeURIComponent(sizeText);
  };

  // ✅ 뒤로가기/새로진입 시: 1) 서버가 내려준 wished(진짜 DB상태) 먼저 적용
  //                     2) 방금 내가 눌렀던 값(sessionStorage)이 있으면 그걸로 즉시 덮어씀
  window.addEventListener("pageshow", function(){
    var btn = document.getElementById("wishBtn");
    if(!btn) return;

    // 1) 서버 기준(DB) 상태
    var serverWished = ${wished ? "true" : "false"};
    btn.classList.toggle("on", serverWished);

    // 2) 방금 클릭한 UI 즉시 반영(redirect 전/후 BFCache 대비)
    var local = sessionStorage.getItem(KEY);
    if(local === "1") btn.classList.add("on");
    if(local === "0") btn.classList.remove("on");
  });

})();
</script>

<script>
	function goWishToggle(e) {
	  if (e) {
	    e.preventDefault();
	    e.stopPropagation();
	    // default.js 같은 다른 click 핸들러까지 싹 막기
	    if (e.stopImmediatePropagation) e.stopImmediatePropagation();
	  }
	
	  const btn = document.getElementById("wishBtn");
	  if (!btn) return;
	  
	  const productId = btn.dataset.wish;
	  
	// sizeText 추출
      const sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
      let sizeText = "";
      if (sizeChecked) {
          const label = document.querySelector('label[for="' + sizeChecked.id + '"]');
          sizeText = label ? label.textContent.trim() : "";
      }

      // 추가할 때만 사이즈 강제
      const isOn = btn.classList.contains("on");
      if (!isOn && !sizeChecked) {
          alert("사이즈를 선택해 주세요");
          return;
      }
	
	  const url = "${pageContext.request.contextPath}/wishlist/toggle.htm?product_id=" + encodeURIComponent(productId);
	
	  fetch(url, {
          method: "POST",
          headers: {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"},
          body: "product_id=" + encodeURIComponent(productId)
              + "&sizeText=" + encodeURIComponent(sizeText)
      })
      .then(async (res) => {
          const text = await res.text();
          if (!res.ok) throw new Error("HTTP " + res.status + " / " + text);
          return JSON.parse(text);
      })
      .then((data) => {
          if (data.wished === true) btn.classList.add("on");
          else btn.classList.remove("on");
      })
      .catch((err) => {
          console.error(err);
          alert("위시리스트 추가 실패\n" + err.message);
      });
	}
</script>
