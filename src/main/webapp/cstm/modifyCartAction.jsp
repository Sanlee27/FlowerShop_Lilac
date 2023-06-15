<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	// 요청값 저장
	int cartNo = Integer.parseInt(request.getParameter("cartNo"));
	int cartCnt = Integer.parseInt(request.getParameter("cartCnt"));
	
	// 전달할 cart객체 생성
	Cart cart = new Cart();
	cart.setCartNo(cartNo);
	cart.setCartCnt(cartCnt);
	
	// CartDao객체 선언
	CartDao cartDao = new CartDao();
	int row = cartDao.updateCart(cart);
	
	return;
%>