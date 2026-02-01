<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
        $(document).ready(function(){
            if(typeof Swiper !== 'undefined') {
                new Swiper('.goods__slider', {
                    slidesPerView: 4,
                    spaceBetween: 10,
                    freeMode: true,
                    scrollbar: {
                        el: '.goods-slider-scrollbar',
                        draggable: true,
                    },
                });
            }
        });
</script>

<script>
(function () {
  // ✅ 중복 바인딩 방지
  if (window.__WISH_LIST_BOUND) return;
  window.__WISH_LIST_BOUND = true;

  const CTX = "${pageContext.request.contextPath}";
  const IS_LOGIN = ${empty sessionScope.auth ? "false" : "true"};

  // 로그인 페이지(프로젝트에 맞게 필요하면 바꾸세요)
  const LOGIN_URL = CTX + "/login.htm?returnUrl=" + encodeURIComponent(location.pathname + location.search);

  // ✅ 리스트(동적 로딩 포함) 버튼 클릭 이벤트 위임
  document.addEventListener("click", async function (e) {
    const btn = e.target.closest("button.wish__btn[data-wish]");
    if (!btn) return;

    e.preventDefault();
    e.stopPropagation();
    if (e.stopImmediatePropagation) e.stopImmediatePropagation();

    if (!IS_LOGIN) {
      location.href = LOGIN_URL;
      return;
    }

    const productId = btn.getAttribute("data-wish");
    if (!productId) return;

    // ✅ 서버 토글 URL (너희 WishToggleHandler 매핑 주소랑 같아야 함)
    const url = CTX + "/wishlist/toggle.htm";

    // 리스트는 사이즈 선택 UI가 없으므로, sizeText는 기본으로 미전송
    // (서버가 SIZE_REQUIRED를 주면 상세로 보내서 사이즈 선택하게 처리)
    const body = new URLSearchParams();
    body.append("product_id", productId);
    
    const body = new URLSearchParams();
    body.append("product_id", productId);
    
 	// 리스트에서 눌렀다는 표시
    body.append("from", "list");

    try {
      btn.disabled = true;

      const res = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
        body: body.toString(),
      });

      const text = await res.text();

      if (res.status === 401) { // 로그인 필요
        location.href = LOGIN_URL;
        return;
      }

      let data;
      try { data = JSON.parse(text); }
      catch (err) { throw new Error("JSON 파싱 실패: " + text); }
      
	  /* 
      // ✅ (선택) 서버가 사이즈 필요하다고 응답하게 만들었다면 여기로 처리
      if (!res.ok && data && data.error === "SIZE_REQUIRED") {
        alert("사이즈를 선택해야 찜할 수 있습니다. 상세페이지로 이동합니다.");
        location.href = CTX + "/product/product_detail.htm?product_id=" + encodeURIComponent(productId);
        return;
      }
       */

      if (!res.ok) throw new Error("HTTP " + res.status + " / " + text);

      // ✅ UI 반영 (product_detail과 동일하게 on 토글)
      if (data.wished === true) btn.classList.add("on");
      else btn.classList.remove("on");

    } catch (err) {
      console.error(err);
      alert("찜 처리 실패\n" + err.message);
    } finally {
      btn.disabled = false;
    }
  }, true);
})();
</script>

<script>
async function wishToggleFromList(e, btn) {
  // ✅ default.js(jQuery)로 이벤트가 넘어가는 걸 차단
  e.preventDefault();
  e.stopPropagation();
  if (e.stopImmediatePropagation) e.stopImmediatePropagation();

  const CTX = "${pageContext.request.contextPath}";
  const IS_LOGIN = ${empty sessionScope.auth ? "false" : "true"};

  if (!IS_LOGIN) {
    location.href = CTX + "/login.htm?returnUrl=" + encodeURIComponent(location.pathname + location.search);
    return false;
  }

  const productId = btn.getAttribute("data-wish");
  if (!productId) return false;

  try {
    btn.disabled = true;

    const body = new URLSearchParams();
    body.append("product_id", productId);
    body.append("from", "list"); // ✅ [추가] 서버가 list 요청인지 구분(사이즈 null 저장용)

    const res = await fetch(CTX + "/wishlist/toggle.htm", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
      body: body.toString()
    });

    const text = await res.text();

    if (res.status === 401) {
      location.href = CTX + "/login.htm?returnUrl=" + encodeURIComponent(location.pathname + location.search);
      return false;
    }

    const data = JSON.parse(text);

    if (!res.ok) {
      // list는 사이즈 없이 들어가야 하니까 SIZE_REQUIRED면 에러로 보지 말고 서버 로직부터 맞춰야 함
      alert("찜 처리 실패: " + (data.error || text));
      return false;
    }

    // ✅ UI on/off
    if (data.wished === true) btn.classList.add("on");
    else btn.classList.remove("on");

  } catch (err) {
    console.error(err);
    alert("찜 처리 실패\n" + err.message);
  } finally {
    btn.disabled = false;
  }

  return false; // ✅ inline onclick에서 return false → 기본동작 완전 차단
}
</script>