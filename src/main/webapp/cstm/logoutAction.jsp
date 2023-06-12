<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate(); // 모든 세션 삭제, 갱신
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>