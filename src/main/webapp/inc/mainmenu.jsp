<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="main-menu-container">
	<div class="main-menu">
	<script>
		function cartModalOpen(){
			$('#cartModal').show();
		}
	</script>
		<div>
			<a href="<%=request.getContextPath()%>/home.jsp">
				<img src="<%=request.getContextPath() %>/images/logo.png" width="150px">
			</a>
		</div>
		<nav>
			<%
				if(session.getAttribute("loginId") != null
				&& (session.getAttribute("loginId").equals("admin1")
				|| session.getAttribute("loginId").equals("admin2"))){
			%>
					<a href="<%=request.getContextPath()%>/employees.jsp">관리자메인</a>
					<a href="<%=request.getContextPath()%>/emp/category.jsp">카테고리관리</a>
					<a href="<%=request.getContextPath()%>/emp/productList.jsp">상품관리</a>
					<a href="<%=request.getContextPath()%>/emp/discount.jsp">할인관리</a>
					<a href="<%=request.getContextPath()%>/emp/orderList.jsp">주문관리</a>
			<%
				}else{
			%>
				<a href="<%=request.getContextPath()%>/cstm/productList.jsp">상품보기</a>
				<a href="<%=request.getContextPath()%>/cstm/reviewList.jsp">후기게시판</a>
				<a href="<%=request.getContextPath()%>/cstm/questionList.jsp">문의게시판</a>
				<a href="<%=request.getContextPath()%>/cstm/cstmInfo.jsp">마이페이지</a>
			<%
				} 
			%>
		</nav>
		<div class="icons">
			<a onclick='cartModalOpen()'>
				<img src="<%=request.getContextPath() %>/images/cart.png">
			</a>
			<%
				if(session.getAttribute("loginId") == null){
			%>
					<a href="<%=request.getContextPath()%>/cstm/login.jsp">
						<img src="<%=request.getContextPath() %>/images/login.png">
					</a>
			<%
				}else{
			%>
					<a href="<%=request.getContextPath()%>/cstm/logoutAction.jsp">
						<img src="<%=request.getContextPath() %>/images/logout.png">
					</a>
			<%
				}
			%>
			
		</div>
	</div>
	<div class="divide-line"></div>
</div>

