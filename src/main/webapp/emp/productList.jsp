<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDao"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%@ page import = "java.text.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 유효성검사
	
	// 변수
	String searchCategory = null;
	String searchName = null;
	String order = null;
	int startRow = 0;
	int rowPerPage = 10;
	
	// dao
	ProductDao productDao = new ProductDao();
	
	// ProductDao 값 불러오기
	ArrayList<HashMap<String, Object>> list = productDao.getAllProductList(searchCategory, searchName, order, startRow, rowPerPage);
	
	// 가격 표시해줄 포맷터
	DecimalFormat dc = new DecimalFormat("###,###,###,###");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lilac</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
</head>
<body>
<!-- 메인메뉴 -->
<div>
<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>

<div class="container">
	<!--메세지 -->
	     	<%
			if(request.getParameter("msg") != null) {
		%>
			<div><%=request.getParameter("msg")%></div>				
		<%
	        	}
		%>
		
	<!-- 상품 리스트 -->
	<div class="list-wrapper9">
		<h2>상품 리스트
		</h2>
		<a href="<%=request.getContextPath()%>/emp/addProduct.jsp">+</a>	
		<div class="list-item">
			<div>상품번호</div>
			<div>상품명</div>
			<div>가격</div>
			<div>상품상태</div>
			<div>판매량</div>
			<div>할인율</div>
			<div>할인가격</div>
			<div>&nbsp;</div>
			<div>&nbsp;</div>
		</div>
	<%
		for(HashMap<String, Object> map : list) {
			Product product = (Product)map.get("product");
			double discountRate = (double)map.get("discountRate");
			int discountPrice = (int)map.get("discountPrice");	
	%>
		<div class="list-item">
			<div><%=product.getProductNo()%></div>
			<div><%=product.getProductName()%></div>
			<div><%=dc.format(product.getProductPrice())%></div>
			<div><%=product.getProductStatus()%></div>
			<div><%=product.getProductSaleCnt()%></div>
			<div><%=discountRate%></div>
			<div><%=dc.format(discountPrice)%></div>
			<div>
				<a href="<%=request.getContextPath()%>/emp/modifyProduct.jsp?productNo=<%=product.getProductNo()%>">수정</a>
			</div>
			<div>
				<a href="<%=request.getContextPath()%>/emp/removeProductAction.jsp?productNo=<%=product.getProductNo()%>">삭제</a>
			</div>
		</div>
	<%
		}
	%>
	</div>
</div>

</body>
</html>