<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<section class="my-con">
		<h2 class="tit__style4">배송지 관리</h2>
		<a href="#" class="btn_sld__bk btn_rt add-addr__btn">신규 배송지 추가</a>


		<!-- 배송지 관리 -->
		<div class="my-address-box">

			<ul class="addr__list">
				<c:forEach var="a" items="${addrList}" varStatus="st">
					<li class="${a.isDefault == 1 ? '_default_addr' : ''}"><input
						type="radio" id="myAddr${st.index}" name="myAddrList"
						class="addr-chk" ${a.isDefault == 1 ? 'checked' : ''}> <label
						for="myAddr${st.index}"></label>

						<div class="addr-info">
							<div class="name-tel">
								<c:if test="${a.isDefault == 1}">
									<p class="tag">기본</p>
								</c:if>
								<p class="name">${a.recipientName}</p>
								<p class="tel">${a.recipientPhone}</p>
							</div>

							<div class="addr-detail">
								<p>
									(${a.zipcode}) ${a.mainAddr}<br>
									<c:out value="${a.detailAddr}" />
								</p>
							</div>
						</div>

						<div class="btn-box">
							<button type="button" class="modify__btn"
								data-addr-no="${a.addressId}">modify</button>
							<c:choose>
								<c:when test="${a.isDefault == 1}">
									<button type="button" class="delete__btn"
										onclick="alert('기본 배송지는 삭제하실 수 없습니다.');">delete</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="delete__btn"
										data-addr-no="${a.addressId}">delete</button>
								</c:otherwise>
							</c:choose>
						</div> <c:if test="${a.isDefault == 0}">
							<button type="button" class="default-addr__btn"
								onclick="addrDefault('${a.addressId}');">기본으로 설정</button>
						</c:if></li>
				</c:forEach>

				<c:if test="${empty addrList}">
					<li style="padding: 20px;">등록된 배송지가 없습니다.</li>
				</c:if>
			</ul>



		</div>
		<!-- //배송지 추가 -->
		<div id="AddaddressModalOverlay" class="style-modal-overlay"
			onclick="if(event.target === this) closeQnaModal();"
			style="display: none;">

			<div id="AddaddModalContent" class="style-modal-wrapper">
				<!-- AJAX로 qna_modal.jsp 들어올 자리 -->
			</div>
		</div>
		<!-- //배송지 수정 -->
		<div id="EditaddressModalOverlay" class="style-modal-overlay"
			onclick="if(event.target === this) closeQnaModal();"
			style="display: none;">

			<div id="EditaddModalContent" class="style-modal-wrapper">
				<!-- AJAX로 qna_modal.jsp 들어올 자리 -->
			</div>
		</div>
		<!-- 주소 -->

	</section>

	</div>
	</div>
