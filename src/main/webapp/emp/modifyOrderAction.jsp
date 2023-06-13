<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 요청값 유효성 검사 & 저장
	if(request.getParameter("orderNo") == null
	|| request.getParameter("orderNo").equals("")
	|| request.getParameter("orderStatus") == null
	|| request.getParameter("orderStatus").equals("")){
		response.sendRedirect(request.getContextPath() + "/emp/orderList.jsp");
		return;
	}

	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	String orderStatus = request.getParameter("orderStatus");
	
	// OrderDao객체 선언
	OrderDao orderDao = new OrderDao();
	
	// update실행할 Order객체 선언
	Order order = new Order();
	order.setOrderNo(orderNo);
	order.setOrderStatus(orderStatus);
	
	// update실행 후 결과값 저장
	int row = orderDao.updateOrderStatus(order);
	
	// 넘겨줄 결과값으로 변경
	String msg = row == 1 ? "success" : "fail";
	
	response.sendRedirect(request.getContextPath() + "/emp/orderList.jsp?msg=" + msg);
	
%>
