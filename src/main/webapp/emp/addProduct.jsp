<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	// DAO 불러오기
	CategoryDao categorydao = new CategoryDao();
	ProductDao productdao = new ProductDao();
	
	// 값 불러오기
	ArrayList<Category> categoryList = categorydao.selectCategoryList();
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
		
	<!-- 상품 추가폼 -->
	<form action = "<%=request.getContextPath()%>/emp/addProductAction.jsp" method="post" encType="multipart/form-data">
		<div> 상품 카테고리
			<select name="categoryName">
			<%
				for(Category c : categoryList) {
			%>
				<option><%=c.getCategoryName()%></option>
			<%
				}
			%>
			</select>
		</div>
		<div>상품명 
			<input type="text" name = "productName">
		</div>
		<div>상품 설명 
			<textarea rows="3" cols="100" name = "productInfo"></textarea>
		</div>
		<div>상품 가격 
			<input type="number" name = "productPrice">
		</div>
		<div>상품 상태 
			<select name="productStatus">
				<option>판매중</option>
				<option>품절</option>
			</select>
		</div>
		<div>재고량 
			<input type="number" name = "productStock">
		</div>
		<div>상품 이미지  
			<input type="file" name = "productImg">
		</div>
		<div>
			<button type="submit">등록</button>
			<button type="submit" formaction="<%=request.getContextPath()%>/emp/productList.jsp">이전</button>
		</div>
	</form>
</div>
</body>
</html>