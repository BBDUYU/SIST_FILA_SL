<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  if (request.getAttribute("detail") == null) {
    response.sendRedirect(request.getContextPath() + "/event?eventId=1");
    return;
  }
%>

<!DOCTYPE html>

<!--[if IE 6]> <html class="no-js lt-ie10 lt-ie9 lt-ie8 ie6" lang="ko-KR"> <![endif]-->
<!--[if IE 7]> <html class="no-js lt-ie10 lt-ie9 lt-ie8 ie7" lang="ko-KR"> <![endif]-->
<!--[if IE 8]> <html class="no-js lt-ie10 lt-ie9 ie8" lang="ko-KR"> <![endif]-->
<!--[if IE 9]> <html class="no-js lt-ie10 ie9" lang="ko-KR"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js" lang="ko-KR"> <!--<![endif]-->
<jsp:include page="/view/common/header.jsp" />

<body class="">
<c:set var="event" value="${detail.event}" />
<c:set var="sections" value="${detail.sections}" />

	<!-- start of :: wrap -->
	<div id="wrap">

<!-- start of :: header -->
<header id="header">
	<!-- logo -->
	<h1 class="logo">
		<a href="/main/main.asp">FILA</a>
	</h1>
	<!-- //logo -->

	<!-- gnb -->
	<nav class="gnb">
		<ul>

			<!--li class="_gnb_kids">
				<a href="/event/blackfriday2025/" style="color: rgb(10,1,254);">BLACK FRIDAY</a>
			</li-->

			
			<li>
				<a href="/main/women.asp">WOMEN</a>

				<!-- 2 Depth -->
				<div class="depth2-box">
					<div class="inner">
						<!-- side menu -->
						<div class="side-menu-box">
							<a class="link-tit">New &amp; Featured</a>

							<div>
								<ul>
									<li>
										<a href="/product/new.asp?no=2001">신상품</a>
									</li>
									<li>
										<a href="/product/best.asp?no=2001">베스트</a>
									</li>
									<li>
										<a href="/product/style.asp?cno=101">스타일</a>
									</li>
									<li>
										<a href="/product/sale.asp?no=2001">세일</a>
									</li>
								</ul>

								<ul>
									<li>
										<a href="/event/view.asp?seq=1309">1911 Knit Track</a>
									</li>
									<li>
										<a href="/product/list.asp?no=2246">Holiday Gifts</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1303">Ritmo Sleek</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1298">Glio Silver-Moon</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1294">플로우다운</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1289">Her Winter Ritual</a>
									</li>
									
									<li>
										<a href="/event/view.asp?seq=1285">HAREPIN 1998</a>
									</li>
									
									<li>
										<a href="/event/view.asp?seq=1279">한소희&김나영 에샤페</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1269">Sydney Trip with 차정원</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1277">에센셜 언더웨어</a>
									</li>
								</ul>
							</div>
						</div>
						<!-- //side menu -->

						<!-- category menu -->
						<div class="category-menu-box">

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2007" class="link-tit">의류</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2007">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2100" >패딩/다운점퍼</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2040" >바람막이/집업</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2267" >긴팔</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2041" >맨투맨/후디</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2048" >플리스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2046" >팬츠</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2047" >스커트/원피스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2044" >반팔</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2045" >브라탑/베스트</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2101" >쇼츠</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2303" >레깅스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2042" >트레이닝 셋업</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2043" >테니스</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2008" class="link-tit">신발</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2008">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2112" >윈터슈즈</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2049" >라이프스타일</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2050" >헤리티지</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2051" >테니스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2052" >러닝</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2053" >샌들/슬리퍼</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2210" >판테라 99/25</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2134" >에샤페</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2320" >하레핀</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=3134" >리트모</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=3136" >글리오</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2009" class="link-tit">용품</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2009">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2116" >26SS 신학기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2061" >테니스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2054" >백팩</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2095" >숄더/토트백</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2055" >메신저/크로스백</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2058" >짐백</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2057" >슬링백/힙색</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2059" >모자</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2060" >양말</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2110" >윈터 아이템</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2062" >기타</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div>
								
									<a href="/main/underwear_w.asp" class="link-tit">언더웨어</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2010">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=3137" >휠라 X 쿠키런</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2323" >에센셜 클래식</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2274" >러버스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2212" >멜로우</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2324" >버터소프트</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2211" >벨로</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2297" >퓨징</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2288" >F코튼</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2124" >파자마</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2118" >와이어브라</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2119" >노와이어브라</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2121" >패키지</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2117" >브라탑</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2067" >팬티</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2122" >사각드로즈</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2123" >이지웨어</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div class="cate">
								<a href="/main/tennis.asp" class="link-tit">스포츠</a>

								<div>
									<ul>
										<li>
											<a href="/main/tennis.asp">테니스</a>
										</li>
										<li>
											<a href="/main/running.asp">러닝/트레이닝</a>
										</li>
										
									</ul>
								</div>
							</div>
							<!-- //묶음 -->

						</div>
						<!-- //category menu -->
					</div>
				</div>
				<!-- //2 Depth -->						

				<div class="gnb-bg__wrap"></div>		
			</li>
			<li> <!-- 활성화시 클래스 on -->
				<a href="/main/men.asp">MEN</a>

				<!-- 2 Depth -->
				<div class="depth2-box">
					<div class="inner">
						<!-- side menu -->
						<div class="side-menu-box">
							<a class="link-tit">New &amp; Featured</a>

							<div>
								<ul>
									<li>
										<a href="/product/new.asp?no=2000">신상품</a>
									</li>
									<li>
										<a href="/product/best.asp?no=2000">베스트</a>
									</li>
									<!--li>
										<a href="/product/style.asp?cno=100">스타일</a>
									</li-->
									<li>
										<a href="/product/sale.asp?no=2000">세일</a>
									</li>
								</ul>

								<ul>
									<li>
										<a href="/product/list.asp?no=2246">Holiday Gifts</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1294">플로우다운</a>
									</li>
									
									<li>
										<a href="/event/view.asp?seq=1285">HAREPIN 1998</a>
									</li>
									
									<li>
										<a href="/event/view.asp?seq=1236">AXILUS 3 T9</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1214">Tennis Shoes</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1194">UNDERWEAR X BALANSA</a>
									</li>
								</ul>
							</div>
						</div>
						<!-- //side menu -->

						<!-- category menu -->
						<div class="category-menu-box">

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2003" class="link-tit">의류</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2003">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2102" >패딩/다운점퍼</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2014" >바람막이/집업</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2266" >긴팔</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2015" >맨투맨/후디</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2019" >팬츠</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2020" >플리스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2018" >반팔</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2318" >베스트</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2103" >쇼츠</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2016" >트레이닝 셋업</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2017" >테니스</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2004" class="link-tit">신발</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2004">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2111" >윈터슈즈</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2021" >라이프스타일</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2022" >헤리티지</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2023" >테니스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2024" >러닝</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2025" >샌들/슬리퍼</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2213" >에샤페</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2209" >판테라 99/25</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2319" >하레핀</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=3135" >리트모</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2005" class="link-tit">용품</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2005">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2115" >26SS 신학기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2033" >테니스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2026" >백팩</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2027" >메신저/크로스백</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2030" >숄더/짐백</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2029" >슬링백/힙색</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2031" >모자</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2032" >양말</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2109" >윈터 아이템</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2034" >기타</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div>
								
									<a href="/main/underwear_m.asp" class="link-tit">언더웨어</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2006">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=3138" >휠라 X 쿠키런</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2326" >슬라이스클럽</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2035" >패키지</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2036" >드로즈</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2298" >트렁크</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2125" >스포츠</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2126" >이지웨어</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2127" >파자마</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2295" >F코튼</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div class="cate">
								<a href="#" class="link-tit">스포츠</a>

								<div>
									<ul>
										<li>
											<a href="/main/tennis.asp">테니스</a>
										</li>										
										<li>
											<a href="/main/running.asp">러닝/트레이닝</a>
										</li>
										
									</ul>
								</div>
							</div>
							<!-- //묶음 -->

						</div>
						<!-- //category menu -->
					</div>
				</div>
				<!-- //2 Depth -->						

				<div class="gnb-bg__wrap"></div>		
			</li>			
			<li class="_gnb_kids">
				<a href="/main/kids.asp">KIDS</a>

				<!-- 2 Depth -->
				<div class="depth2-box">
					<div class="inner">
						<!-- side menu -->
						<div class="side-menu-box">
							<a class="link-tit">New &amp; Featured</a>

							<div>
								<ul>
									<li>
										<a href="/product/new.asp?no=2002">신상품</a>
									</li>
									<li>
										<a href="/product/best.asp?no=2002">베스트</a>
									</li>
									<li>
										<a href="/product/style.asp?cno=102">스타일</a>
									</li>
									<li>
										<a href="/product/sale.asp?no=2002">세일</a>
									</li>
								</ul>
								<ul>
									<li>
										<a href="/teeniepingrun/">FILA KIDS Teenieping Run</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1304">&#x1F392; 2026 신학기 백팩 컬렉션</a>
									</li>
								
									<li>
										<a href="/event/view.asp?seq=1292">&#127872; 여아 다운 & 부츠 컬렉션</a>
									</li>
								
									<li>
										<a href="/event/view.asp?seq=1286">&#128420; 프리미엄 구스 다운 : 아이스 블랙</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1287">&#128098; 코코부츠</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1270">&#128052; 마이 프렌즈 포니</a>
									</li>
								</ul>
							</div>
						</div>
						<!-- //side menu -->

						<!-- category menu -->
						<div class="category-menu-box kids">

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2011" class="link-tit">의류</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2011">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2078" >다운/플리스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2176" >경량/퀼팅</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2076" >바람막이/집업/자켓</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2075" >후드티/맨투맨</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2070" >상하의 셋업</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2072" >팬츠/레깅스</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2071" >티셔츠</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2074" >스커트</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2302" >원피스</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2012" class="link-tit">신발</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2012">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2084" >윈터슈즈</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2315" >리틀에샤페</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2316" >에픽런</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2104" >휠라꾸미</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2079" >운동화(130~160mm)</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2081" >운동화(170~240mm)</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2177" >레인부츠</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

							<!-- 묶음 -->
							<div>
								
									<a href="/product/list.asp?no=2013" class="link-tit">용품</a>
								
								<div>

									<ul>
									
										<li>
											<a href="/product/list.asp?no=2013">전체보기</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=3004" >26 신학기 책가방</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2092" >윈터 아이템</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2086" >책가방</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2087" >보조가방 </a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2088" >모자</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2089" >양말</a>
										</li>
										
										<li>
											<a href="/product/list.asp?no=2090" >기타</a>
										</li>
										
									</ul>

								</div>
							</div>
							<!-- //묶음 -->

						</div>
						<!-- //category menu -->
					</div>
				</div>
				<!-- //2 Depth -->							

				<div class="gnb-bg__wrap"></div>	
			</li>
		</ul>

		<div class="bar"></div>

		<ul>
			<!-- 2023-06-28 MEMBERS WEEK 추가 -->
			<!--li class="no-depth">
				<a href="/event/membersweek2023_2/index.asp" style="color: rgb(225,0,0);">MEMBERS WEEK</a>
			</li-->
			
			<li class="no-depth" style="display: none;"> <!-- 2023-07-11 숨김 -->
				<a href="/collabo/list.asp">COLLABORATION</a>
			</li>
			
			<!-- //2023-06-28 MEMBERS WEEK 추가 -->


			<!-- 2024-04-25 테니스 추가 -->
			<li class="_gnb_tennis"> <!-- 활성화시 클래스 on -->
				<a href="/main/tennis.asp">TENNIS</a>

				<!-- 2 Depth -->
				<div class="depth2-box">
					<div class="inner">
						<!-- side menu -->
						<div class="side-menu-box">
							<a class="link-tit">New &amp; Featured</a>

							<div>
								<ul>
									<li>
										<a href="/event/view.asp?seq=1236">AXILUS 3 T9</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1184">FIRE ACE T7​</a>
									</li>
									<li>
										<a href="https://clubmatch.fila.co.kr/main/main.asp">2025 FILA 클럽매치</a>
									</li>
									<li>
										<a href="/event/view.asp?seq=1214">Tennis Shoes Guide</a>
									</li>
									<li>
										<a href="/wos2025/">2025 WHITE OPEN SEOUL</a>
									</li>
								</ul>
							</div>
						</div>
						<!-- //side menu -->

						<!-- category menu -->
						<div class="category-menu-box">
							<div>								
								<a href="/product/list.asp?no=2043" class="link-tit">WOMEN</a>
								
								<div>
									<ul>
									
										<li>
											<a href="/product/list.asp?no=2043">의류</a>
										</li>
									
										<li>
											<a href="/product/list.asp?no=2051">신발</a>
										</li>

										<li>
											<a href="/product/list.asp?no=2061">용품</a>
										</li>

									</ul>
								</div>
	
								<div class="wide-link-box"> <!-- 2025-09-01 _v2 추가-->
									<a href="/customstudio/intro.asp" class="link-custom _v2">테니스화 커스텀 서비스</a>
								</div>
							</div>

							<div>								
								<a href="/product/list.asp?no=2017" class="link-tit">MEN</a>
								
								<div>
									<ul>
									
										<li>
											<a href="/product/list.asp?no=2017">의류</a>
										</li>
									
										<li>
											<a href="/product/list.asp?no=2023">신발</a>
										</li>

										<li>
											<a href="/product/list.asp?no=2033">용품</a>
										</li>

									</ul>
								</div>
							</div>

							<div>
								<div class="tennis-bot-ban">
									<ul>
										<!--li>
											<a href="/filatennis/index.asp#whiteSeoul">
												<div class="img">
													<img src="https://web1.fila.co.kr/data/contentsfile/d_gnb_tennis_01_240425.jpg" alt="">
												</div>
												<p>FILA White Open Seoul 2024</p>	
											</a>
										</li-->

										<li class="tennis-club-link">
											<a href="https://clubmatch.fila.co.kr/main/main.asp">
												<div class="img">
													<img src="//filacdn.styleship.com/filacontent2/data/contentsfile/d_gnb_banner_clubmatch2025_v2.png" alt="">
												</div>
												<p>FILA Club Match</p>	
											</a>
										</li>

										<li class="tennis-club-link">
											<a href="/event/view.asp?seq=1264">
												<div class="img">
													<img src="//filacdn.styleship.com/filacontent2/data/contentsfile/d_gnb_banner_FILAMATCH.png" alt="">
												</div>
												<p>2025 FILA MATCH</p>	
											</a>
										</li>

										<!--
										<li class="tennis-club-link">
											<a href="/customstudio/intro.asp">
												<div class="img">
													<img src="//filacdn.styleship.com/filacontent2/data/contentsfile/img_custom_d_240530.png" alt="">
												</div>
												<p>FILA Custom Studio</p>	
											</a>
										</li>
										-->
									</ul>
								</div>
							</div>
							
						</div>
						<!-- //category menu -->
					</div>
				</div>
				<!-- //2 Depth -->						

				<div class="gnb-bg__wrap"></div>		
			</li>			
			<!-- //2024-04-25 테니스 추가 -->


			<li class="_brand_gnb" style=""> 
				<a href="#">BRAND</a>

				<!-- 2 Depth -->
				<div class="depth2-box">
					<div class="inner">
						<ul class="brand-gnb__list">
							<li>
								<a href="/about/about.asp">
									<div class="photo">
										<img src="//filacdn.styleship.com/filacontent2/pc/resource/images/common/1.jpg" alt="">
									</div>

									<p>About FILA</p>
								</a>
							</li>

							<li>
								<a href="/collabo/list.asp">
									<div class="photo">
										<img src="//filacdn.styleship.com/filacontent2/pc/resource/images/common/2.jpg" alt="">
									</div>

									<p>Collaboration</p>
								</a>
							</li>

							<li>
								<a href="/sustainability/">
									<div class="photo">
										<img src="//filacdn.styleship.com/filacontent2/pc/resource/images/common/3_240626.jpg" alt="">
									</div>

									<p>Sustainability</p>
								</a>
							</li>

							<li>
								<a href="/brand/athletes/">
									<div class="photo">
										<img src="//filacdn.styleship.com/filacontent2/pc/resource/images/common/4.jpg" alt="">
									</div>

									<p>Athletes</p>
								</a>
							</li>

							<li>
								<a href="/brand/tennis/story.asp">
									<div class="photo">
										<img src="//filacdn.styleship.com/filacontent2/pc/resource/images/common/img_brand_tennis_d.jpg" alt="">
									</div>

									<p>Content</p>
								</a>
							</li>
						</ul>
					</div>
				</div>
				<!-- //2 Depth -->	

				<div class="gnb-bg__wrap"></div>
			</li>
			
			<!-- 2024-07-26 UPCOMING 추가 -->
			<li class=""> 
				<a href="/upcoming/list.asp">UPCOMING</a>
			</li>
			<!-- // 2024-07-26 UPCOMING 추가 -->
						

			<!-- 2025-12-18 -->
			<!--
			<li class=""> 
				<a href="/teeniepingrun/" style="color: #DE4888;">Teenieping Run</a>
			</li>
			<!-- //2025-12-18 -->

		</ul>
	</nav>
	<!-- //gnb -->

	<!-- util -->
	<div class="util">
		<div class="util-store">
			<a href="/customer/store.asp" class="store__btn">store</a>
		</div>

		<div class="util-search">
			<button type="button" class="search-open__btn" >search</button>
			<form action="javascript:searchRun2();" name="searchForm2" method="get"  autocomplete="off">
			<!-- search layer -->
			<div class="search__layer">	

				<div class="head">
					<div class="search-category-box">
						<div>
							<button type="button" class="on searchCate searchs" onclick="searchsCate('');">전체</button> <!-- 활성화시 클래스 on -->
							<button type="button" class="searchCate searchs2001" onclick="searchsCate('2001');">WOMEN</button>
							<button type="button" class="searchCate searchs2000" onclick="searchsCate('2000');">MEN</button>
							<button type="button" class="searchCate searchs2002" onclick="searchsCate('2002');">KIDS</button>
						</div>
					</div>
					

					<div class="search-input-box">
						<div>						
							<button type="button" class="close__btn"></button>

							<!--<input type="search" placeholder="검색어 입력" name="searchItem" id="searchItem2" value="" onfocus="this.value='';" >-->
							<input type="search" placeholder="검색어 입력" name="searchItem" id="searchItem2" value="">
							<input type="hidden" name="searchsCateNo" id="searchsCateNo" value="">

							<button type="button" class="search__btn" onclick="javascript:searchRun2();void(0);">search</button>
						</div>
						
						<button type="button" class="cancel__btn">취소</button>
					</div>
				</div>

				

				<div class="con">
					<div class="inner">
						<!-- 최근 검색어 -->
						<div class="keywords-box _recommend">
							<div>
								<p class="tit">최근 검색어</p>

								<button type="button" class="all-delete__btn" onclick="wordRemoveAll();">전체 기록 삭제</button>
							</div>

							<div>
								<ul class="latest__list" id="sWordHistory">
								</ul>
								
							</div>
						</div>
						<!-- //최근 검색어 -->


						<!-- 인기 검색어 -->
						<div class="keywords-box _popular">
							<div>
								<p class="tit">인기 검색어</p>

								<p class="update-txt">12:00 업데이트</p>
							</div>

							<div>
								<ul>

									<li>
										<a href="/search/search_result.asp?sWord=%uD55C%uC18C%uD76C">한소희</a>
									</li>

									<li>
										<a href="/search/search_result.asp?sWord=FS254RB01F002">FS254RB01F002</a>
									</li>

									<li>
										<a href="/search/search_result.asp?sWord=FK253CD01X008">FK253CD01X008</a>
									</li>

									<li>
										<a href="/search/search_result.asp?sWord=%uBE0C%uB77C">브라</a>
									</li>

									<li>
										<a href="/search/search_result.asp?sWord=FS253OD03X014">FS253OD03X014</a>
									</li>

									<li>
										<a href="/search/search_result.asp?sWord=%uD32C%uD2F0">팬티</a>
									</li>

									<li>
										<a href="/search/search_result.asp?sWord=%uC5D0%uC0E4%uD398">에샤페</a>
									</li>


								</ul>
							</div>
						</div>
						<!-- //인기 검색어 -->

						<!-- 추천 검색어 -->
						<div class="keywords-box _recommend">
							<div>
								<p class="tit">추천 검색어</p>
							</div>

							<div>
								<ul>

									<li>
										<a href="https://www.fila.co.kr/event/view.asp?seq=1269">차정원 신발</a>
									</li>

									<li>
										<a href="https://www.fila.co.kr/event/view.asp?seq=1268">판테라 LX</a>
									</li>

									<li>
										<a href="https://www.fila.co.kr/product/view.asp?ProductNo=60326">에픽런 포니</a>
									</li>

									<li>
										<a href="https://www.fila.co.kr/product/view.asp?ProductNo=60294">리틀에샤페</a>
									</li>

									<li>
										<a href="https://www.fila.co.kr/event/view.asp?seq=1233">피트니스</a>
									</li>


								</ul>
							</div>
						</div>
						<!-- //추천 검색어 -->

						<!-- 추천 상품 -->
						<div class="keywords-box _recommend_goods">
							<div>
								<p class="tit">추천상품</p>
							</div>

							<div>
								<div class="goods-scroll-box _type_v2"> <!-- 2024-08-05 클래스 추가 _type_v2 -->
									<div class="slider-box">
										<div class="goods__slider swiper">
											<div class="swiper-wrapper" id="headerProduct">

											</div>
										</div>

										<div class="goods-slider-scrollbar"></div>
									</div>				
								</div>
							</div>
						</div>
						<!-- //추천 상품 -->
					</div>
				</div>
			</form>
			</div>

			<div class="search-bg__wrap"></div>
			<!-- //search layer -->
			
		</div>

		<div class="util-account">
			<button type="button" class="account__btn" onclick="location.href='/member/login.asp'">account</button>

			<!-- account layer -->
			<div class="account__layer">
				<div class="inner">

					<div class="account-menu-box" >
						<ul>
							<li id="globalMenu1">
								&nbsp;
							</li>

							<li id="globalMenu2">
								&nbsp;
							</li>

							<li id="globalMenu3">
								&nbsp;
							</li>
							<li id="globalMenu7">
								&nbsp;
							</li>
							<li id="globalMenu4">
								&nbsp;
							</li>
							<li id="globalMenu5">
								&nbsp;
							</li>
							<li id="globalMenu8">
								&nbsp;
							</li>
						</ul>
						<button type="button" class="logout__btn" id="globalMenu6" onclick="location.href='/member/logout.asp';">로그아웃</button>
					</div>


					<!-- //로그인 후 -->
				</div>
			</div>
			<!-- //account layer -->
		</div>

		<div class="util-cart">
			<button type="button" class="cart__btn" data-num="0" id="cart_cnt" onclick="location.href='/order/cart.asp';" rel="nosublink">cart</button>
		</div>
	</div>
	<!-- //util -->
</header>		
<!-- // end of :: header -->	
<form name="searchFormReal" method="get"  autocomplete="off" action="/search/search_result.asp">
	<input type="hidden" name="sWord" value />
	<input type="hidden" name="searchsCateNo" value />
</form>	


		<!-- start of :: contents -->
		<div id="contents" class="brand__contents">
		<div style="background:yellow; padding:10px;">
  detail 존재? : ${not empty detail}<br/>
  sections 개수 : ${empty detail ? 0 : fn:length(detail.sections)}<br/>
  eventName : ${empty detail ? 'null' : detail.event.eventName}
</div>
		
			<section class="brand-view-box">
				<div class="head">
					<!--p class="category">Collaboration</p-->
					<p class="tit">${event.eventName}</p>
				</div>
				<div class="con">
					<!-- 클래스 wide-box_full - width: 1920px --> 
					<!-- 에디터 영역 -->
					<style>

						/* 이미지 영역 */
						.promo-banner {
							margin: 0 auto;
							overflow: hidden;
							position: relative;
							max-width: 1903px;
							background: rgb(255, 255, 255);
						}

						/* 각 이미지 url 수정하고, height 조정 */
						.promo-banner01 {
							height: 840px;
							background: url(/data/contentsfile/d_250522_Axilus_01.jpg) center no-repeat;
						}
						.promo-banner02 {
							height: 2270px;
							background: url(/data/contentsfile/d_250522_Axilus_02.jpg) center no-repeat;
						}
						.promo-banner03 {
							position: relative;
							height: 800px;
							background-color: rgb(0, 0, 0);
						}
						.promo-banner04 {
							height: 2030px;
							background: url(/data/contentsfile/d_250522_Axilus_04.jpg) center no-repeat;
						}

						/* 텍스트 나오는거 효과 이중에 하나 넣으면 됨 밑에 css랑 클래스 수정 */
						/* 
							.fadeIn {animation: fadeIn 1s forwards;}
							.shaking {animation: shaking 1s forwards;}
							.upDown {animation: upDown 1s forwards;}
							.showUp {animation: showUp 1s forwards;}
							.showDown {animation: showDown 1s forwards;}
							.showLeft {animation: showLeft 1s forwards;}
							.showRight {animation: showRight 1s forwards;}
						 */
						@keyframes fadeIn {
							0%{opacity: 0;}
							100%{opacity: 1;}
						}

						@keyframes shaking {
							0%{transform: rotate(0deg);}
							25%{transform: rotate(5deg);}
							50%{transform: rotate(2deg);}
							75%{transform: rotate(3deg);}
							100%{transform: rotate(0deg);}
						}
						@keyframes upDown {
							0% {
								transform: translateY(0);
							}
							100% {
								transform: translateY(calc(-10 / 780 * 100vw));
							}
						}
						@keyframes showUp {
							0% {
								opacity: 0;
								transform: translateY(calc(40 / 780 * 100vw));
							}
							100% {
								opacity: 1;
								transform: translateY(0px);
							}
						} 
						@keyframes showDown {
							0% {
								opacity: 0;
								transform: translateY(calc(-40 / 780 * 100vw));
							}
							100% {
								opacity: 1;
								transform: translateY(0px);
							}
						} 
						@keyframes showLeft {
							0% {
								opacity: 0;
								transform: translateX(calc(100 / 780 * 100vw));
							}
							100% {
								opacity: 1;
								transform: translateX(0px);
							}
						}
						@keyframes showRight {
							0% {
								opacity: 0;
								transform: translateX(calc(-100 / 780 * 100vw));
							}
							100% {
								opacity: 1;
								transform: translateX(0px);
							}
						}

						/* 텍스트 나오는거 css */
						.motion-box{
							position: absolute;
							top: 0;
							left: 0;
							width: 100%;
							height: 100%;
						}

						/* 아까 고른 효과 적용하는 곳 */
						.motion-box.on .fadeIn {animation: fadeIn 1s forwards;}
						.motion-box.on .showLeft {animation: showLeft 0.5s forwards;}
						.motion-box.on .showRight {animation: showRight 0.5s forwards;}
						/* 넣을 이미지 url, txt## 클래스명 수정하는 곳 */
						.motion-box .txt01 {background: url(/data/contentsfile/d_250522_Axilus_01_txt01.png) center no-repeat;}
						.motion-box .txt02 {background: url(/data/contentsfile/d_250522_Axilus_01_txt02.png) center no-repeat;}
						.motion-box .txt03 {background: url(/data/contentsfile/d_250522_Axilus_02_txt01.png) center no-repeat;}
						.motion-box .txt04 {background: url(/data/contentsfile/d_250522_Axilus_02_txt02.png) center no-repeat;}
						.motion-box .txt05 {background: url(/data/contentsfile/d_250522_Axilus_04_txt01.png) center no-repeat;}
						.motion-box .txt06 {background: url(/data/contentsfile/d_250522_Axilus_04_txt02.png) center no-repeat;}
						.motion-box > div{
							position: absolute;
							top: 0;
							left: 0;
							width: 100%;
							height: 100%;
							transition: all 1s;
							transition-delay: 0.8s;
							opacity: 0;
						}

						/* 딜레이 조정하는 곳 */
						.del1 {animation-delay: .2s !important;}
						.del2 {animation-delay: .4s !important;}
						.del3 {animation-delay: .6s !important;}
						.del4 {animation-delay: .8s !important;}
						.del5 {animation-delay: 1s !important;}
						.del6 {animation-delay: 1.2s !important;}
						.del7 {animation-delay: 1.4s !important;}
						.del8 {animation-delay: 1.6s !important;}

						.promo-slide .swiper-button-next { 
							all: unset;
							position: absolute;
							top: 370px;
							left: 50%;
							z-index: 5;
							width: 33px;
							height: 60px;
							background: url(/data/contentsfile/d_250522_Axilus_next.png) no-repeat 50% 50% /cover;
							cursor: pointer;
							transform: translateX(740px);
						}
						.promo-slide .swiper-button-prev { 
							all: unset;
							position: absolute;
							top: 370px;
							left: 50%;
							z-index: 5;
							width: 33px;
							height: 60px;
							background: url(/data/contentsfile/d_250522_Axilus_prev.png) no-repeat 50% 50% /cover;
							cursor: pointer;
							transform: translateX(-773px);
						}
						.swiper-button-next::after,
						.swiper-button-prev::after {
							display: none;
							content: none;
						}
						.promo-slide .swiper-slide {
							width: 1400px;
							height: 800px;
							transition: opacity 0.3s ease;
							opacity: 0.4;
						}
						.promo-slide .swiper-slide-active {
							opacity: 1;
						}
					</style>

					<div class="promo-banner01 promo-banner">
						<div class="motion-box01 motion-box">
							<div class="txt01 showRight del1"></div>
							<div class="txt02 showRight del3"></div>
						</div>
					</div>
					<div class="promo-banner02 promo-banner">
						<div class="motion-box02 motion-box">
							<div class="txt03 showRight del1"></div>
							<div class="txt04 showLeft del5"></div>
						</div>
					</div>
					<div class="promo-banner03 promo-banner">
						<div class="swiper mySwiper promo-slide promo-slide01">
							<div class="swiper-wrapper">
								<div class="swiper-slide">
									<img src="//filacdn.styleship.com/filacontent2/data/contentsfile/d_250522_Axilus_03_sl01.jpg" alt="">
								</div>
								<div class="swiper-slide">
									<img src="//filacdn.styleship.com/filacontent2/data/contentsfile/d_250522_Axilus_03_sl02.jpg" alt="">
								</div>
								<div class="swiper-slide">
									<img src="//filacdn.styleship.com/filacontent2/data/contentsfile/d_250522_Axilus_03_sl03.jpg" alt="">
								</div>
							</div>
							<div class="swiper-button-next"></div>
    						<div class="swiper-button-prev"></div>
						</div>
					</div>
					<div class="promo-banner04 promo-banner">
						<div class="motion-box03 motion-box">
							<div class="txt05 showRight del1"></div>
							<div class="txt06 showLeft del4"></div>
						</div>
					</div>
					

					<script src="/pc/resource/js/lib/scrollmagic/ScrollMagic.js"></script>

					<script>
						document.addEventListener("DOMContentLoaded",function () {
							// 글자 나오게 하기
							var controller = new ScrollMagic.Controller();
							var num = document.querySelectorAll(".motion-box").length;
							for(let i = 1; i <= num; i++){
								var promoBanner = new ScrollMagic.Scene({
									triggerElement:".motion-box0"+ i,
									duration: 0,
									triggerHook: 0.7,
									reverse: false,
									offset: 0
								})
								.setClassToggle(".motion-box0"+ i,"on")
								.addTo(controller);
							}
				
							 let promoSlide=document.querySelectorAll(".promo-slide")
							for(i=0;i<promoSlide.length;i++){
								let className = promoSlide[i].classList[3]
								var swiper = new Swiper(`.${className}`, {
									speed: 500,
									slidesPerView : 'auto',
									loop : true,
									autoplay : {
										delay : 3000,
										disableOnInteraction : false,
									},
									allowTouchMove : true,
									centeredSlides: true,
									navigation: {
										nextEl: ".promo-slide .swiper-button-next",
										prevEl: ".promo-slide .swiper-button-prev",
									},
								})
							}
						});
					</script>
				
					<!--div>
						<img src="/pc/resource/images/sub/collab_view_edit01.jpg" alt="">
					</div>	
					<div class="wide-box_full">
						<img src="/pc/resource/images/sub/collab_view_edit02.jpg" alt="">
					</div-->
					<!-- //에디터 영역 -->
				</div>
			</section>


			<div class="goods-bt">

				<!-- 2023-02-07 탭메뉴 추가 --> 
				<div class="box-line"></div>


				<div class="event_tab">
				  <c:forEach var="sec" items="${sections}">
				    <a href="#group${sec.sectionId}" id="gt${sec.sectionId}">${sec.title}</a>
				  </c:forEach>
				</div>



	<form name="sFrm" method="get" action="?">
	<input type="hidden" name="no" value="1236" />	
	<input type="hidden" name="page" value="" />
	</form>
				<!-- 2023-02-07 상품 리스트 추가 -->
				<div class="event_list_box">
  <c:forEach var="sec" items="${sections}">
    <div class="thumb4_wrap" id="group${sec.sectionId}">
      <p class="tit">${sec.title}</p>

      <!-- 섹션 이미지들 (원하면 상단 배너처럼 출력) -->
      <c:forEach var="img" items="${sec.images}">
        <c:choose>
          <c:when test="${not empty img.linkUrl}">
            <a href="${img.linkUrl}">
              <img src="${img.imageUrl}" alt="${img.altText}" />
            </a>
          </c:when>
          <c:otherwise>
            <img src="${img.imageUrl}" alt="${img.altText}" />
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <!-- 상품 리스트 -->
      <ul class="thumb4_list goods__list _type_v2">
        <c:forEach var="p" items="${sec.products}">
          <li class="goods">
            <div class="info">
              <a href="/product/view.asp?ProductNo=${p.productId}">
                <p class="name">${p.name}</p>
                <div class="price">
                  <p class="sale">
                    <fmt:formatNumber value="${p.price}" pattern="#,###" />원
                  </p>
                </div>
              </a>
            </div>
          </li>
        </c:forEach>
      </ul>
    </div>
  </c:forEach>
</div>

			</div>
		</div>
		<!-- // end of :: contents -->


		<div class="ssSocial-Sharing" style="display:none;"
			data-requestUrl="https://www.fila.co.kr/event/view.asp?seq=1236" 
			data-requestSns="F,KL,NV">
		</div>
		<!-- 하단 고정 버튼 (top, sns) -->
<div class="bot-fix-box">
	<div class="inner">


		<!-- 2023-10-05 오늘 본 상품 추가 (오늘 본 상품이 없는 경우 나타남) -->
		<button type="button" class="today-goods__btn">
			<svg id="btn_time" xmlns="http://www.w3.org/2000/svg" width="29" height="29" viewBox="0 0 29 29">
			  <g id="icon" transform="translate(-0.025 -0.025)">
				<path id="패스_706" data-name="패스 706" d="M17.05,24.66A14,14,0,1,0,19.5,9.572l.253-3.648" transform="translate(-15.29 -4.475)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1"/>
				<path id="패스_707" data-name="패스 707" d="M6.537,83.1a14.542,14.542,0,0,0-.3,12.37" transform="translate(-4.475 -75.062)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1" stroke-dasharray="40 40"/>
				<path id="패스_708" data-name="패스 708" d="M114.512,80.167v6.806l-3.662,3.662" transform="translate(-99.914 -72.362)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"/>
				<line id="선_542" data-name="선 542" x1="3.654" transform="translate(4.307 5.263)" fill="none" stroke="#707070" stroke-linecap="round" stroke-linejoin="round" stroke-width="1"/>
			  </g>
			</svg>

		</button>
		<!-- //2023-10-05 오늘 본 상품 추가 (오늘 본 상품이 없는 경우 나타남) -->


		<button type="button" class="kakaotalk__btn" onclick="doBizmsg();void(0);">
			<svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 50 50">
				<g id="btn_kakao" transform="translate(-330)">
					<circle id="타원_73" data-name="타원 73" cx="25" cy="25" r="25" transform="translate(330)" fill="#fedc00"/>
					<g id="그룹_18" data-name="그룹 18" transform="translate(345 15)">
						<path id="패스_8" data-name="패스 8" d="M192.79,193.223c-5.868,0-10.625,3.782-10.625,8.447a8.127,8.127,0,0,0,4.614,6.966l-.768,4.118a.236.236,0,0,0,.362.241l4.564-3.006s1.221.128,1.853.128c5.868,0,10.625-3.782,10.625-8.447s-4.757-8.447-10.625-8.447" transform="translate(-182.165 -193.223)" fill="#3c1e1e"/>
					</g>
				</g>
			</svg>
		</button>


		<script src="https://bizmessage.kakao.com/chat/includeScript"></script>
<script type="text/javascript">
function doBizmsg() {
var kakaoPop = window.open("about:blank","kakaoPop","width=350,height=550")
var frm = document.formbiz;
frm.submit();
//document.getElementById("form-biz").submit();

}
</script>
<form id="form-biz" name="formbiz" action="https://bizmessage.kakao.com/chat/open" method="post" target="kakaoPop">
<!--
<input type="hidden" name="uuid" value="@FILA" />
<input type="hidden" name="extra" value="FILA_M"/>
-->

<input type="hidden" name="uuid" value="@fila" />
<input type="hidden" name="extra" value="TCK_M"/>

<input type="hidden" name="bot" value="true" />
<input type="hidden" name="event" value="시작" />
</form>

		<button type="button" class="top__btn">top</button>		
	</div>
</div>


<jsp:include page="/view/common/footer.jsp" />

</body>
</html>