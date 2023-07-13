<%@page import="java.io.File"%>
<%@page import="vo.ProductImg"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.util.HashMap"%>
<%@page import="vo.Product"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

 	//유효성검사
	if(request.getParameter("productNo") == null
		||request.getParameter("productNo").equals("")
		){
		response.sendRedirect(request.getContextPath() + "/emp/productList.jsp");
		System.out.println("productNo, productName, ProductNameRe 값 필요");
		return;
	}
 	
	//변수
	String dir = request.getServletContext().getRealPath("/product");
	String msg = "";
	int productNo = Integer.parseInt(request.getParameter("productNo"));

	//DAO 불러오기
	ProductDao productdao = new ProductDao();
	HashMap<String, Object> map = productdao.getProductDetail(productNo);
	Product product = (Product)map.get("product");
	
	//변수 
	String productName = product.getProductName();
	System.out.println(productName + "<--productName");
	
	int row = productdao.deleteProduct(productNo);
	if(row == 1) {
		ProductImg productImg = (ProductImg)map.get("productImg");
		// imgFile을 삭제
		 if(productImg != null) {
			 
			//이미 저장된 파일 삭제
			String saveFilename = productImg.getProductSaveFilename();

			//파일 경로 설정
			File f = new File(dir + "/" + saveFilename);
			if(f.exists()) {
				f.delete();
					System.out.println(dir + "/" + saveFilename + "파일삭제");
			}	
		 }
		System.out.println("삭제 성공");
		msg = URLEncoder.encode(productName + " 상품이 삭제되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/productList.jsp?msg=" + msg);
	} else{
		response.sendRedirect(request.getContextPath() + "/emp/productList.jsp");
		System.out.println("삭제 실패");
	}
%>