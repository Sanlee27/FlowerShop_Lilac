<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>


<%
	//인코딩 설정
	request.setCharacterEncoding("UTF-8");

	//dao 객체선언
	ProductDao productDao = new ProductDao();
	
	//dao의 리스트 가져오기
	ArrayList<HashMap<String, Object>> list = productDao.getNewProducts();
	ArrayList<HashMap<String, Object>> elist = productDao.getDiscountProducts();
	
 %>	



<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Lilac</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- jQuery, home부분 js파일 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="<%=request.getContextPath() %>/script/homeScript.js" type="text/javascript" defer></script>
	<!-- data-aos 라이브러리(fade up구현해주는 - 스크롤이벤트) -->
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
	<script>
		function productClick(productNo){
			location.href="<%= request.getContextPath() %>" + "/cstm/product.jsp?productNo=" + productNo;
		}
	</script>
</head>
<body>
	<div>
		<!-- 메인메뉴 -->
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		
		<!-- 이미지 슬라이드 부분 -->
		
		<div class="image-slide">
				<ul class="images">
					<li class="main1">
						<img src="images/main1.jpg">
						<div class="comment">
							분위기 전환이 필요할때
							<br>
							<span>화사한 꽃병으로 거실을 더 환하게!</span>
						</div>
					</li>
					<li class="main2">
						<img src="images/main2.jpg">
						<div class="comment">
							선물이 필요할때
							<br>
							<span>화려한 꽃바구니로 마음을 전하세요!</span>
						</div>
					</li>
					<li class="main3">
						<img src="images/main3.jpg">
						<div class="comment">
							아주 특별한 날에도
							<br>
							<span>주문제작 부케로 특별하게!</span>
						</div>
					</li>
				</ul>
			</div>
		</div>
		
		<!-- deco -->
		<div class="down-arrow">
				<img src="images/down-arrow.png">
		</div>
		
		<!-- 신상품 보여주는 부분 -->
		<div class="product-list" data-aos="fade-up" data-aos-duration="3000">
			<h2>신상품</h2>
			<div class="products">
			<%
				ArrayList<HashMap<String, Object>> newProducts = productDao.getNewProducts();
			    for (HashMap<String, Object> map : newProducts) {
			      Product p = (Product) map.get("product");
			      ProductImg pi = (ProductImg) map.get("productImg");
			      double discountRate = (double) map.get("discountRate");
			      int discountPrice = (int) map.get("discountPrice");
			%>
				  
					<div data-aos="fade-up" data-aos-duration="3000" onclick="productClick(<%= p.getProductNo() %>)">
							<img src="<%= request.getContextPath() %>/product/<%= pi.getProductSaveFilename() %>">
							<div class="divide-line"></div>
							<div class="content">
								<%= p.getProductName() %>
								<br>
								 <% if (discountRate > 0) { %>
									<del><%= p.getProductPrice() %> 원</del>
									<br>
									<span class="price"><%= discountPrice %> 원</span>
								<% } else { %>
									<%= p.getProductPrice()%> 원
								<% } %>
							</div>
						
					</div>
			<% 
			} 
			%>
			</div>
		</div>
		
		<!-- 이벤트 상품 보여주는 부분 -->
		<div class="product-list" data-aos="fade-up" data-aos-duration="3000">
			<h2>event</h2>
			<div class="products">
			<%
				ArrayList<HashMap<String, Object>> eventProducts = productDao.getDiscountProducts();
			    for (HashMap<String, Object> map : eventProducts) {
			      Product p = (Product) map.get("product");
			      ProductImg pi = (ProductImg) map.get("productImg");
			      double discountRate = (double) map.get("discountRate");
			      int discountPrice = (int) map.get("discountPrice");
			%>
				
					<div data-aos="fade-up" data-aos-duration="3000" onclick="productClick(<%= p.getProductNo() %>)">
						<img src="<%= request.getContextPath() %>/product/<%= pi.getProductSaveFilename() %>">
						<div class="divide-line"></div>
						<div class="content">
						<%= p.getProductName() %>
						<br>
						<% if (discountRate > 0) { %>
							<del><%= p.getProductPrice()*10 %> 원</del>
							<br>
							<span class="price"><%= discountPrice *10 %>원</span>
						<% } else { %>
							<%= p.getProductPrice()*10%> 원
						<% } %>
						</div>
					</div>

				
			<% 
			} 
			%>
		
		</div>
	</div>
	<!-- 장바구니 모달 -->
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
	
	<!-- footer -->
	<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>