<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 회원 관리</title>
<style>
    :root {
        --fila-navy: #001E62;
        --fila-red: #E2001A;
        --fila-gray: #F4F4F4;
    }

    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: var(--fila-gray);
        margin: 0;
        display: flex;
    }

    /* 사이드바 */
    .sidebar {
        width: 240px;
        height: 100vh;
        background: var(--fila-navy);
        color: white;
        position: fixed;
    }

    .sidebar .logo {
        padding: 30px;
        text-align: center;
        border-bottom: 1px solid #1a3578;
        font-weight: bold;
        font-size: 24px;
        letter-spacing: 2px;
    }

    .nav-item {
        padding: 15px 25px;
        cursor: pointer;
        border-bottom: 1px solid #1a3578;
        transition: 0.3s;
    }

    .nav-item:hover, .nav-item.active {
        background: var(--fila-red);
    }

    /* 메인 컨텐츠 */
    .main-content {
        margin-left: 240px;
        padding: 40px;
        width: calc(100% - 240px);
    }

    .card {
        background: white;
        border: 1px solid #ddd;
        border-radius: 0;
        padding: 25px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    /* 테이블 스타일 */
    .table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    .table th {
        background-color: var(--fila-navy);
        color: white;
        padding: 12px;
        font-weight: 500;
    }

    .table td {
        padding: 12px;
        border-bottom: 1px solid #eee;
        text-align: center;
    }

    .badge {
        padding: 4px 8px;
        font-size: 12px;
        color: white;
        font-weight: bold;
    }

    .btn-detail {
        background: white;
        border: 1px solid var(--fila-navy);
        color: var(--fila-navy);
        padding: 5px 10px;
        cursor: pointer;
        transition: 0.3s;
    }

    .btn-detail:hover {
        background: var(--fila-navy);
        color: white;
    }
</style>
</head>
<body>

    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="currentPage" value="user" />
    </jsp:include>

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

</body>
</html>