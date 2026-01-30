<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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