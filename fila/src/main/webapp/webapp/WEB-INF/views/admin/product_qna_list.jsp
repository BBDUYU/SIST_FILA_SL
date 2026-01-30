<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="main-content">
		<div class="card">
			<h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">
                상품문의 관리
            </h2>
            <p style="color: #666; font-size: 14px;">고객님들이 남겨주신 상품 문의 내역입니다.</p>
			<hr>

			<table class="list-table">
                <thead>
                    <tr>
                        <th style="width: 5%;">번호</th>
                        <th style="width: 10%;">문의유형</th>
                        <th style="width: 13%;">상품정보</th> <th style="width: auto;">제목</th>
                        <th style="width: 10%;">이름</th>
                        <th style="width: 10%;">회원번호</th>
                        <th style="width: 10%;">작성일</th>
                        <th style="width: 10%;">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty qnaList}">
                            <c:forEach var="dto" items="${qnaList}">
                                <tr>
                                    <td>${dto.qna_id}</td>
                                    <td>${dto.type}</td>
                                    
                                    <td style="font-size: 13px; color: #888;">
                                        ${not empty dto.product_id ? dto.product_id : '-'}
                                    </td>
                                    
                                    <td class="td-subject">
									    <c:if test="${dto.is_secret == 1}">
									        <img src="//image.fila.co.kr/fila/kr/images/common/ico_lock.png" alt="잠금" style="width: 12px; opacity: 0.6; margin-right: 3px;">
									    </c:if>
									    <a href="${pageContext.request.contextPath}/admin/productQnaDetail.htm?qna_id=${dto.qna_id}" class="link-title">
									        ${dto.question}
									    </a>
									</td>
                                    
                                    <td>${dto.name}</td>
                                    <td>${dto.user_number}</td>
                                    
                                    <td>
                                        <fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    
                                    <td>
									    <c:choose>
									        <c:when test="${not empty dto.answer and dto.answer ne ''}">
									            <span class="status-badge">답변완료</span>
									        </c:when>
									        <c:otherwise>
									            <span class="status-badge pending">답변대기</span>
									        </c:otherwise>
									    </c:choose>
									</td>
									                                </tr>
                            </c:forEach>
                        </c:when>
                        
                        <c:otherwise>
                            <tr>
                                <td colspan="7" style="padding: 50px 0; color: #999;">
                                    등록된 문의 내역이 없습니다.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div style="text-align: center; margin-top: 30px;">
                </div>

		</div>
	</div>
