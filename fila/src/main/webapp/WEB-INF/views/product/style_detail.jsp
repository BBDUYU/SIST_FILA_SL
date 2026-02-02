<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
	<div id="wrap">
		<div id="contents" class="goods__contents">
			<section class="goods-list-box _thumb03 _type_style">
				<h2 class="hidden">상품 리스트</h2>

				<div class="head">
					<div class="tit-box">
						<p class="tit">
							스타일<span>${fn:length(styleList)}</span>
						</p>
					</div>

					<div class="sorting-box">
						<div></div>

						<div>
							<!--select>
								<option value="">등록순</option>
								<option value="">정렬 01</option>
								<option value="">정렬 02</option>
							</select-->

							<div class="col-box">
								<button type="button" class="col3__btn">3단</button>
								<button type="button" class="col4__btn">4단</button>
							</div>
						</div>
					</div>
				</div>

				<div class="con">
					<!-- filter -->
					<div class="filter-box"></div>
					<!-- //filter -->

					<!-- 상품 리스트 -->
					<div class="list-box">
						<ul class="goods__list">
							<c:forEach var="style" items="${styleList}" varStatus="status">
								<li class="style-goods _sg">
									<div class="photo" onclick="codiCart('${style.style_id}')">
										<div class="before">
											<a href="javascript:;"> <img src="${pageContext.request.contextPath}/displayImage.do?path=${style.main_image_url}" alt="${style.style_name}">
											</a>
										</div>

										<div class="after">
											<!-- slider -->
											<div
												class="hover__slider swiper">
												<div class="swiper-wrapper"
													id="swiper-wrapper-632841ba10db29418" aria-live="polite"
													style="transform: translate3d(-351px, 0px, 0px); transition-duration: 0ms;">
													<c:forEach var="img" items="${style.images}" varStatus="imgStatus">
												        <div class="swiper-slide" 
												             data-swiper-slide-index="${imgStatus.index}" 
												             role="group" 
												             aria-label="${imgStatus.count} / ${fn:length(style.images)}">
												            
												            <a href="javascript:;">
												                <img src="${pageContext.request.contextPath}/displayImage.do?path=${img.image_url}" 
                 alt="${not empty img.alt_text ? img.alt_text : '스타일 이미지'}">
												            </a>
												        </div>
												    </c:forEach>
													
												</div>
												<span class="swiper-notification" aria-live="assertive"
													aria-atomic="true"></span>
											</div>
											<!-- //slider -->

										</div>
										
										<div class="bot__layer _show">

										<!-- slider button -->
										<div class="slider-btn-box">
											<button type="button" class="prev__btn" tabindex="0"
												aria-label="Previous slide"
												aria-controls="swiper-wrapper-632841ba10db29418">
												<svg xmlns="http://www.w3.org/2000/svg" width="7.071"
													height="11.314" viewBox="0 0 7.071 11.314">
												<g id="_" data-name="&lt;"
														transform="translate(1120.057 1377.444) rotate(-135)">
													<rect id="사각형_18" data-name="사각형 18" width="8" height="2"
														rx="1" transform="translate(1754 178)" fill="#fff"></rect>
													<rect id="사각형_19" data-name="사각형 19" width="8" height="2"
														rx="1" transform="translate(1762 178) rotate(90)"
														fill="#fff"></rect>
												</g>
											</svg>
											</button>

											<div
												class="sg-swiper-pagination swiper-pagination-clickable swiper-pagination-bullets swiper-pagination-horizontal">
												<span
													class="swiper-pagination-bullet swiper-pagination-bullet-active"
													tabindex="0" role="button" aria-label="Go to slide 1"
													aria-current="true"></span><span
													class="swiper-pagination-bullet" tabindex="0" role="button"
													aria-label="Go to slide 2"></span><span
													class="swiper-pagination-bullet" tabindex="0" role="button"
													aria-label="Go to slide 3"></span><span
													class="swiper-pagination-bullet" tabindex="0" role="button"
													aria-label="Go to slide 4"></span><span
													class="swiper-pagination-bullet" tabindex="0" role="button"
													aria-label="Go to slide 5"></span>
											</div>

											<button type="button" class="next__btn" tabindex="0"
												aria-label="Next slide"
												aria-controls="swiper-wrapper-632841ba10db29418">
												<svg xmlns="http://www.w3.org/2000/svg" width="7.071"
													height="11.314" viewBox="0 0 7.071 11.314">
												<g id="_" data-name="&gt;"
														transform="translate(-1112.986 -1366.13) rotate(45)">
													<rect id="사각형_18" data-name="사각형 18" width="8" height="2"
														rx="1" transform="translate(1754 178)" fill="#fff"></rect>
													<rect id="사각형_19" data-name="사각형 19" width="8" height="2"
														rx="1" transform="translate(1762 178) rotate(90)"
														fill="#fff"></rect>
												</g>
											</svg>
											</button>
										</div>
										<!-- //slider button -->
									</div>
									</div>

									
								</li>
							</c:forEach>



						</ul>

					</div>
					<!-- //상품 리스트 -->
				</div>
			</section>
		</div>
		
	</div>
	<div id="styleModalOverlay" class="style-modal-overlay" onclick="if(event.target == this) closeModal();" style="display:none;">
    <div id="styleModalContent" class="style-modal-wrapper">
        </div>
</div>