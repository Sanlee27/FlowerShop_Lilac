<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	//요청값 유효성 검사
	if(request.getParameter("productNo") == null
	|| request.getParameter("productNo").equals("")
	|| request.getParameter("orderCnt") == null
	|| request.getParameter("orderCnt").equals("")){
		return;
	}

	// 요청값 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	int cartCnt = Integer.parseInt(request.getParameter("cartCnt"));
	
	// 세션에서 로그인된 아이디 가져오기
	String loginId = (String)session.getAttribute("loginId");
	
	// 비로그인 상태일때
	if(loginId == null){
		// cart 데이터를 해쉬맵에 저장
		HashMap<String, Object> cart = new HashMap<>();
	   	cart.put("productNo", productNo);
	   	cart.put("cartCnt", cartCnt);
	   	// cart 데이터가 담긴 해쉬맵을 세션에 저장
	   	session.setAttribute("cart", cart);
	   return;
	}else{ // 로그인 상태일때
		// CartDao에 넘겨줄 Cart객체 생성
		Cart cart = new Cart();
		cart.setId(loginId);
		cart.setProductNo(productNo);
		cart.setCartCnt(cartCnt);
		
		// CartDao객체 생성
		CartDao cartDao = new CartDao();
		int row = cartDao.insertCart(cart);
		
		// 디버깅
		if(row == 1){
			System.out.println("장바구니 추가 성공");
		}else{
			System.out.println("장바구니 추가 실패");
		}
		return;
	}
	
%>