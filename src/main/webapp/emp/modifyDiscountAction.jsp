<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	System.out.println(request.getParameterValues("productNo"));
	System.out.println(request.getParameterValues("discountStart"));
	System.out.println(request.getParameterValues("discountEnd"));
	System.out.println(request.getParameterValues("discountRate"));

	// 받아온 값_배열을 변수에 저장
	String[] productNos = request.getParameterValues("productNo");
	String[] discountStarts = request.getParameterValues("discountStart");
	String[] discountEnds = request.getParameterValues("discountEnd");
	String[] discountRates = request.getParameterValues("discountRate");
	
	DiscountDao dao = new DiscountDao();
	
	for (int i = 0; i < productNos.length; i++) {
	    // 반복문으로 각각의 배열의 값을 분리 저장
	    int productNo = Integer.parseInt(productNos[i]);
	    String discountStart = discountStarts[i];
	    String discountEnd = discountEnds[i];
	    double discountRate = Double.parseDouble(discountRates[i]);
	    
	    if (discountStart != null && discountEnd != null && !discountStart.isEmpty() && !discountEnd.isEmpty()) {
		    /* System.out.println(productNo);
		    System.out.println(discountStart);
		    System.out.println(discountEnd);
		    System.out.println(discountRate/100); */
		    
		    Discount discount = new Discount();
		    discount.setDiscountStart(discountStart);
		    discount.setDiscountEnd(discountEnd);
		    discount.setDiscountRate(discountRate/100);
		    discount.setProductNo(productNo);
		    
		    // discount테이블에 상품번호 존재 유무에 따라 insert / update 구분
		    int ckProductNo = dao.ckProduct(discount);
		    // System.out.println(ckProductNo); 1 > update 0 > insert
		    int addDiscount = 0;
		    int uptDiscount = 0;
		    
		    if(ckProductNo == 1){
		    	uptDiscount = dao.uptDiscountRate(discount);
		    } else {
		    	addDiscount = dao.addDiscountRate(discount);
		    }
	    }
	}
	    
    String msg = URLEncoder.encode("할인이 변경되었습니다.","UTF-8");
	response.sendRedirect(request.getContextPath()+"/emp/discount.jsp?msg="+msg);
%>