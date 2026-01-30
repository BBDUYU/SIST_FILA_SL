<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<style>
    .sidebar {
        width: 240px;
        height: 100vh;
        background: #00205b; 
        color: white;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 1000;
    }

    .sidebar .logo {
        padding: 30px;
        text-align: center;
        border-bottom: 1px solid #1a3578;
        font-weight: bold;
        font-size: 24px;
        letter-spacing: 5px;
    }

    .sidebar .nav-item {
        padding: 15px 25px;
        cursor: pointer;
        border-bottom: 1px solid #1a3578;
        transition: 0.3s;
        color: rgba(255, 255, 255, 0.8);
        font-size: 14px;
    }

    .sidebar .nav-item:hover, .sidebar .nav-item.active {
        background: #e21836; 
        color: white;
    }

    .sidebar .nav-sub-item {
        padding: 10px 25px 10px 45px;
        cursor: pointer;
        font-size: 13px;
        opacity: 0.8;
        transition: 0.2s;
    }

    .sidebar .nav-sub-item:hover {
        opacity: 1;
        color: #e21836;
    }
</style>

<div class="sidebar">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/index.htm" style="text-decoration: none; color: inherit;">FILA</a>
        <span style="font-weight: 300; font-size: 16px; display: block; color: rgba(255, 255, 255, 0.5); letter-spacing: 1px;">ADMIN</span>
    </div>
    
    <div class="nav-item ${param.currentPage eq 'user' ? 'active' : ''}" 
         onclick="location.href='${pageContext.request.contextPath}/admin/userList.htm'">회원 관리</div>
    
    <div class="nav-item ${param.currentPage eq 'product' ? 'active' : ''}" 
         onclick="location.href='${pageContext.request.contextPath}/admin/productList.htm'">상품 관리</div>
         
    <div class="nav-item ${param.currentPage eq 'tag' ? 'active' : ''}" 
         onclick="location.href='${pageContext.request.contextPath}/admin/tagList.htm'">태그 관리</div>
         
    <div class="nav-item ${param.currentPage eq 'coupon' ? 'active' : ''}"
    	onclick="location.href='${pageContext.request.contextPath}/admin/coupon_list.htm'">쿠폰 관리</div>
    <div class="nav-item ${param.currentPage eq 'style' ? 'active' : ''}"
    	onclick="location.href='${pageContext.request.contextPath}/admin/styleList.htm'">스타일 관리</div>
    <div class="nav-item ${param.currentPage eq 'inquiry' ? 'active' : ''}" 
         onclick="location.href='${pageContext.request.contextPath}/admin/inquiryList.htm'">
        1:1 문의 <span style="background: #e21836; padding: 2px 6px; border-radius: 10px; font-size: 10px;">3</span>
    </div>
    <div class="nav-item ${pageName eq 'productQna' ? 'active' : ''}"
    	onclick="location.href='${pageContext.request.contextPath}/admin/productQnaList.htm'">
    	상품문의 관리
    </div>

    <div class="nav-item ${pageName eq 'notice' ? 'active' : ''}"
	    onclick="location.href='${pageContext.request.contextPath}/admin/noticeManage.htm'">
	    공지사항 관리
	</div>
</div>