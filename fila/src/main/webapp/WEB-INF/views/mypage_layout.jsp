<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title><tiles:insertAttribute name="title" ignore="true" /></title>
    <%-- 스타일 --%>
    <tiles:insertAttribute name="style" ignore="true"/>
    
    <%-- 개별 css/js --%>
    <tiles:insertAttribute name="add" ignore="true"/>
    <link rel="icon" type="image/x-icon"
		href="//filacdn.styleship.com/filacontent2/favicon.ico" />
	<link href="${pageContext.request.contextPath}/css/SpoqaHanSansNeo.css"
		rel="stylesheet">
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/css/normalize.css">
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/css/opt-default.css">
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/css/swiper-bundle.css">
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/css/layout.css">
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/css/product.css">
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/css/sub.css">
	<link rel="stylesheet"
		href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
    </head>
<body>

    <%-- 헤더 --%>
    <tiles:insertAttribute name="header" ignore="true"/>
    
    <%-- 헤더 --%>
    <tiles:insertAttribute name="aside" ignore="true"/>
	
    <%-- 실제 각 페이지의 본문이 들어가는 자리 --%>
    <tiles:insertAttribute name="content" ignore="true"/>
    
    <%-- 실제 각 페이지의 본문이 들어가는 자리 --%>
    <tiles:insertAttribute name="footer" ignore="true"/>

	<%-- script --%>
    <tiles:insertAttribute name="script" ignore="true"/>
	
</body>
</html>