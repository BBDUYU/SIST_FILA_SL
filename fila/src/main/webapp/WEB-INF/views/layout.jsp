<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><tiles:insertAttribute name="title" ignore="true" /></title>
    <%-- 스타일 --%>
    <tiles:insertAttribute name="style" ignore="true"/>
    <tiles:insertAttribute name="add" ignore="true"/>
    </head>
    
    <%-- c --%>
    <tiles:insertAttribute name="c_start" ignore="true"/>
    
    <%-- 헤더 --%>
    <tiles:insertAttribute name="header" />
<body class="hd__style1 _style_main">

    <%-- 실제 각 페이지의 본문이 들어가는 자리 --%>
    <tiles:insertAttribute name="content" />

    <%-- 푸터 --%>
    <tiles:insertAttribute name="footer" />
    
    <%-- 모달 --%>
    <tiles:insertAttribute name="modal1" ignore="true"/>
    
    <%-- 모달 --%>
    <tiles:insertAttribute name="modal2" ignore="true"/>
    
    <%-- script --%>
    <tiles:insertAttribute name="script" ignore="true"/>
</body>

 <%-- c --%>
    <tiles:insertAttribute name="c_end" ignore="true"/>
</html>