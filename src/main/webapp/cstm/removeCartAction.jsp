<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%
	//요청값 저장
	int cartNo = Integer.parseInt(request.getParameter("cartNo"));
	
	if(cartNo == 0){
		session.invalidate();
	}else{
		CartDao cartDao = new CartDao();
		int row = cartDao.deleteCart(cartNo);
	}
%>
