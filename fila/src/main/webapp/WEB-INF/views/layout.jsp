<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><tiles:insertAttribute name="title" ignore="true" /></title>
    <%-- 스타일 --%>
    <tiles:insertAttribute name="style" ignore="true"/>
    </head>
<body class="hd__style1 _style_main">
    <%-- 헤더 --%>
    <tiles:insertAttribute name="header" />

    <%-- 실제 각 페이지의 본문이 들어가는 자리 --%>
    <tiles:insertAttribute name="content" />

    <%-- 푸터 --%>
    <tiles:insertAttribute name="footer" />
    
    <%-- script --%>
    <tiles:insertAttribute name="script" ignore="true"/>
</body>
</html>