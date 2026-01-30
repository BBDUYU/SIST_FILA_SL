<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="contents" class="cs__contents">
    <div class="cs__area">
        <section class="cs-con">
            <h2 class="tit__style1">고객센터</h2>
            
            <div class="cs__tab-box">
                <a href="#">FAQ</a>
                <a href="#">매장안내</a>
                <a href="#">A/S 안내</a>
                <a href="${pageContext.request.contextPath}/noticeList.htm" class="on">공지사항</a>
                <a href="${pageContext.request.contextPath}/customer/membership.htm">Membership</a>
            </div>

            <div class="notice_sort-box">
			    <select name="category" id="searchCategory" class="sel__style1" onchange="searchNotice()">
				    <option value="" ${empty param.category ? 'selected' : ''}>전체</option>
				    <option value="브랜드" ${param.category == '브랜드' ? 'selected' : ''}>브랜드</option>
				    <option value="E-SHOP" ${param.category == 'E-SHOP' ? 'selected' : ''}>E-SHOP</option>
				    <option value="이벤트" ${param.category == '이벤트' ? 'selected' : ''}>이벤트</option>
				</select>
			    
			    <div class="str_inp-box not_inp-box">
			        <input type="text" id="keyword" class="search_txt" placeholder="검색어 입력" 
			               onkeyup="if(window.event.keyCode==13){searchNotice()}">
			        <div>
			            <button class="search" type="button" onclick="searchNotice()">검색</button>
			        </div>
			    </div>
</div>

            <div class="notice_wrap">
                <div class="not_list-wrap">
                    <div class="not_list-box">
                        <ul class="not_list">
                            <c:choose>
                                <c:when test="${empty noticeList}">
                                    <li style="text-align:center; padding:20px;">등록된 공지사항이 없습니다.</li>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="dto" items="${noticeList}" varStatus="status">
                                        <li class="notice-item ${status.first ? 'active' : ''}" 
                                            onclick="showImage(this, '${dto.image_url}')">
                                            <a href="javascript:void(0);">
                                                <span>${dto.category_name}</span>
                                                <span class="date">
                                                    <fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd"/>
                                                </span>
                                                <p class="title">${dto.title}</p>
                                            </a>
                                        </li>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </ul>

                        <div class="paging">
                            ${pageLink} 
                        </div>
                    </div>
                </div>

                <div class="not_info-box" style="position:relative; background:none; border:none; min-height:auto;">
				    <img id="noticeImgView" src="" style="width:100%; display:none; vertical-align: top;">
				    
				    <div id="emptyMsg" style="text-align:center; padding-top:100px; color:#999;"></div>
				</div>
            </div>
        </section>
    </div>
</div>
