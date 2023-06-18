<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	DiscountDao dao = new DiscountDao();

	int removeDiscount = dao.delDiscountRateByDate();
	
	String msg = null;
	msg = URLEncoder.encode("할인종료 제품 이력이 삭제되었습니다.","UTF-8");
	response.sendRedirect(request.getContextPath()+"/emp/discount.jsp?msg="+msg);
%>