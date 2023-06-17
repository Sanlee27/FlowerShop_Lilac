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
	int beginRow = 0;
	int rowPerPage = 10;
	
	QuestionDao dao = new QuestionDao();
	ArrayList<Question> list = dao.Questioncust(id, beginRow, rowPerPage);
	
	ProductDao pDao = new ProductDao();
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
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>나의 문의내역</h1>
		<table>
			<tr>
				<th>상품 정보</th>
				<th>문의 제목</th>
				<th>문의 내용</th>
				<th>문의 유형</th>
				<th>작성일</th>
				<th>처리 상태</th>
				<th>&nbsp;</th>
			</tr>
			<%
				for(Question q : list){
					int productNo = q.getProductNo();
					// 상품정보
					HashMap<String, Object> pInfo = pDao.getProductDetail(productNo);
					Product p = (Product)pInfo.get("product");
					ProductImg pi = (ProductImg)pInfo.get("productImg");
					String path = request.getContextPath() + "/product/" + pi.getProductSaveFilename();
			%>
					<tr>
						<td>
							<img src="<%=path%>" width="100px">
							<a href="<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=productNo%>"><%=p.getProductName()%></a>
						</td>
						<td><%=q.getqTitle()%></td>
						<td><%=q.getqContent()%></td>
						<td><%=q.getqCategory()%></td>
						<td><%=q.getCreatedate().substring(0, 10)%></td>
						<%
							if(q.getqAnswer().equals("Y")){
						%>
								<td>답변완료</td>
						<%
							} else {
						%>
								<td>답변 대기중</td>
						<%
							}
						%>
						<td>
							<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/question.jsp?id=<%=id%>&qNo=<%=q.getqNo()%>'">상세보기</button>
						</td>
					</tr>
			<%
				}
			%>
		</table>
		<br>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/cstmInfo.jsp?id=<%=id%>'">마이페이지로</button>
	</div>
</body>
</html>