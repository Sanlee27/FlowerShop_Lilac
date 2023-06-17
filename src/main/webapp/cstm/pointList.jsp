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
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>내 포인트</h1>
		<h3>보유 포인트 : <%=curPoint.getCstmPoint()%></h3>
		<table>
			<tr>
				<th>상태</th>
				<th>적립금</th>
				<th>적립 내용</th>
				<th>주문 번호</th>
				<th>적용 일시</th>
			</tr>
			<%
				for(Point p : list){
					String path = request.getContextPath() + "/product/" + p.getProductSaveFileName();
			%>
					<tr>
						<%
							if(p.getPointPm().equals("+")){
						%>
								<td>적립</td>
						<%
							} else {
						%>
								<td>사용/취소</td>
						<%
							}
						%>
						<td>
							<%=p.getPointPm()+p.getPoint()%>
						</td>
						<td>
							<img src="<%=path%>" width="100px">
							<%=p.getProductName()%>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/cstm/orderDetail.jsp?id=<%=id%>&orderNo=<%=p.getOrderNo()%>">
								<%=p.getOrderNo()%>
							</a>
						</td>
						<td><%=p.getCreatedate().substring(0, 10)%></td>
					</tr>
			<%
				}
			%>
		</table>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/cstmInfo.jsp?id=<%=id%>'">마이페이지로</button>
	</div>
</body>
</html>