<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("loginId") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;	
	}
	
	//System.out.println(request.getParameter("id"));
	
	String id = request.getParameter("id");
	
	OrderDao dao = new OrderDao();
	ArrayList<HashMap<String, Object>> list = dao.getCstmOrderList(id);
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
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script>
		$(document).ready(function() {
			
			// 취소처리시 알림
			if("<%=request.getParameter("msg")%>" != "null"){
		 		swal("완료", "<%=request.getParameter("msg")%>", "success");
		 	}
		});
	</script>
	<style>
		.list-wrapper6 .list-item{
			grid-template-columns: 15% 20% 10% 20% 20% 15%;
		}
	</style>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>내 주문내역</h1>
		<div class="list-wrapper6">
			<div class="list-item">
				<div>상품 정보</div>
				<div>주문 일자</div>
				<div>주문 번호</div>
				<div>주문 금액(수량)</div>
				<div>주문 상태</div>
				<div>&nbsp;</div>
			</div>
			<%
				for(HashMap<String, Object> o : list){
					Order order = (Order)o.get("order");
					String productName = (String)o.get("productName");
					ProductImg pi = (ProductImg)o.get("productImg");
					String path = request.getContextPath() + "/product/" + pi.getProductSaveFilename();
			%>
					<div class="list-item">
						<div>
							<img src="<%=path%>" width="100px">
							<input type="button" value="<%=productName%>" onClick="location.href='<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=order.getProductNo()%>'"> 
						</div>
						<div><%=order.getCreatedate().substring(0, 10)%></div>
						<div><%=order.getOrderNo()%></div>
						<div><%=order.getOrderPrice()%>(<%=order.getOrderCnt()%>)</div>
						<div><%=order.getOrderStatus()%></div>
						<div>
							<a href="<%=request.getContextPath()%>/cstm/orderDetail.jsp?id=<%=id%>&orderNo=<%=order.getOrderNo()%>">상세보기</a> 
						</div>
					</div>
			<%		
				}
			%>
		</div>
		<br>
	</div>
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>