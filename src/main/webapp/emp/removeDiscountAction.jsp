<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");

	String[] productNos = request.getParameterValues("productNos");
	// System.out.println(Arrays.toString(productNos));

	DiscountDao dao = new DiscountDao();
	
	for (int i = 0; i < productNos.length; i++) {
		// 쉼표로 구분, 배열에 다시 저장
		String[] numbers = productNos[i].split(",");
		// 개별로 다시 저장
	    for (int j = 0; j < numbers.length; j++) {
	        int productNo = Integer.parseInt(numbers[j]);
		
			int removeDiscount = dao.delDiscountRate(productNo);
	    }
	}
	
	String msg = URLEncoder.encode("할인 상품이 삭제되었습니다.","UTF-8");
	response.sendRedirect(request.getContextPath()+"/emp/discount.jsp?msg="+msg);
%>