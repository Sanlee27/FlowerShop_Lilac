<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="main-menu-container">
	<div class="main-menu">
		<div>
			<a href="<%=request.getContextPath()%>/home.jsp">
				<img src="<%=request.getContextPath() %>/images/logo.png" width="150px">
			</a>
		</div>
		<nav>
			<a href="<%=request.getContextPath()%>/cstm/productList.jsp">상품보기</a>
			<a href="<%=request.getContextPath()%>/cstm/reviewList.jsp">리뷰</a>
			<a href="<%=request.getContextPath()%>/cstm/QnaList.jsp">문의게시판</a>
			<a href="<%=request.getContextPath()%>/cstm/cstmInfo.jsp">마이페이지</a>
		</nav>
		<div class="icons">
			<a href="">
				<img src="<%=request.getContextPath() %>/images/cart.png">
			</a>
			<a>
				<img src="<%=request.getContextPath() %>/images/login.png">
			</a>
		</div>
	</div>
	<div class="divide-line"></div>
</div>

