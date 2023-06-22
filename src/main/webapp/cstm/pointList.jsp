<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("loginId") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;		
	}
	
	String id = request.getParameter("id");
	// System.out.println(id);
	
	// 클래스 객체 생성
	PointDao dao = new PointDao();
	
	// 현재 포인트
	Customer cstm = new Customer();
	cstm.setId(id);
	
	Customer curPoint = dao.selectCstmPoint(cstm);
	
	// 포인트 증감이력
	ArrayList<Point> list = dao.selectPointHistory(id);
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
	<style>
		.list-wrapper5 .list-item{
			grid-template-columns: 15% 15% 25% 25% 20%;
		}
	</style>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>내 포인트</h1>
		<div class="font-line"></div>
		<h3>
			보유 포인트 : <fmt:formatNumber value="<%=curPoint.getCstmPoint()%>" pattern="###,###,###"/>
		</h3>
		<br>
		<div class="list-wrapper5">
			<div class="list-item">
				<div>상태</div>
				<div>적립금</div>
				<div>적립 내용</div>
				<div>적용 일시</div>
				<div>&nbsp;</div>
			</div>
			<%
				for(Point p : list){
					String path = request.getContextPath() + "/product/" + p.getProductSaveFileName() + ".jpg";
			%>
					<div class="list-item">
						<%
							if(p.getPointPm().equals("+")){
						%>
								<div>적립</div>
						<%
							} else {
						%>
								<div>사용/취소</div>
						<%
							}
						%>
						<div>
							<%=p.getPointPm()+p.getPoint()%>
						</div>
						<div class="product-info">
							<img src="<%=path%>">
							<div>
								<div onClick="location.href='<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=p.getProductNo()%>'"><%=p.getProductName()%></div>
							</div> 
						</div>
						<div><%=p.getCreatedate().substring(0, 10)%></div>
						<div>
							<a class="style-btn" href="<%=request.getContextPath()%>/cstm/orderDetail.jsp?id=<%=id%>&orderNo=<%=p.getOrderNo()%>">
								주문정보
							</a>
						</div>
					</div>
			<%
				}
			%>
		</div>
	</div>
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>