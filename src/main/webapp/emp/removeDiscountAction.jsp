<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// System.out.println(request.getParameter("productNo"));
	System.out.println(request.getParameter("productNos"));
	String[] productNos = request.getParameter("productNos").split(",");
	// System.out.println(productNos);

	int productNo = Integer.parseInt(request.getParameter("productNo"));
	
	DiscountDao dao = new DiscountDao();
	
	int removeDiscount = dao.delDiscountRate(productNo);
	
	String msg = null;
	msg = URLEncoder.encode("할인 제품이 삭제되었습니다.","UTF-8");
	response.sendRedirect(request.getContextPath()+"/emp/discount.jsp?msg="+msg);
%>