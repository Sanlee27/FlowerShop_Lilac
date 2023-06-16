<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	// 요청값 저장
	int cartNo = Integer.parseInt(request.getParameter("cartNo"));
	int cartCnt = Integer.parseInt(request.getParameter("cartCnt"));
	
	// cartNo가 없으면(비로그인 상태)
	if(cartNo == 0){
		// session에서 기존 cart데이터 가져오기
		HashMap<String, Object> originCart = (HashMap<String, Object>)session.getAttribute("cart");
		
		// 새로운 cart데이터 담아줄 HashMap선언
		HashMap<String, Object> newCart = new HashMap<String, Object>();
		
		newCart.put("productNo", originCart.get("productNo"));
		newCart.put("cartCnt", cartCnt);
		
		session.setAttribute("cart", newCart);
		return;
	}else{
		// 전달할 cart객체 생성
		Cart cart = new Cart();
		cart.setCartNo(cartNo);
		cart.setCartCnt(cartCnt);
		
		// CartDao객체 선언
		CartDao cartDao = new CartDao();
		int row = cartDao.updateCart(cart);
		
		return;
	}
%>