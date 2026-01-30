<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
  <div class="main-content"> 
        <div class="card">
            <h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">회원 목록 관리</h2>
            <p style="color: #666; font-size: 14px;">전체 가입 회원 리스트를 조회하고 관리합니다.</p>
            <hr>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>가입일</th>
                        <th>등급</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${userList}">
                        <tr>
                            <td>${user.usernumber}</td>
                            <td><strong>${user.id}</strong></td>
                            <td>${user.name}</td> <td>${user.email}</td>
                            <td><fmt:formatDate value="${user.createAt}" pattern="yyyy-MM-dd" /></td>
                            <td><span style="border: 1px solid #ccc; padding: 2px 5px; font-size: 11px;">${user.grade}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.status eq 'ACTIVE'}">
                                        <span style="color: #28a745; font-weight: bold;">정상</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--fila-red); font-weight: bold;">차단</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button class="btn-detail" onclick="location.href='${pageContext.request.contextPath}/admin/userDetail.htm?userNum=${user.usernumber}'">상세보기</button>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty userList}">
                        <tr>
                            <td colspan="8" style="padding: 100px 0; color: #999;">등록된 회원이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
