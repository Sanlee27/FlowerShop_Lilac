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
	<style>
		.list-wrapper7 .list-item{
			grid-template-columns: 20% 15% 20% 10% 10% 10% 15%;
		}
	</style>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>나의 문의내역</h1>
		<div class="font-line"></div>
		<br>
		<div class="list-wrapper7">
			<div class="list-item">
				<div>상품 정보</div>
				<div>문의 제목</div>
				<div>문의 내용</div>
				<div>문의 유형</div>
				<div>작성일</div>
				<div>처리 상태</div>
				<div>&nbsp;</div>
			</div>
			<%
				for(Question q : list){
					int productNo = q.getProductNo();
					// 상품정보
					HashMap<String, Object> pInfo = pDao.getProductDetail(productNo);
					Product p = (Product)pInfo.get("product");
					ProductImg pi = (ProductImg)pInfo.get("productImg");
					String path = request.getContextPath() + "/product/" + pi.getProductSaveFilename() + "." + pi.getProductFiletype();
			%>
					<div class="list-item">
						<div class="product-info">
							<img src="<%=path%>">
							<div onClick="location.href='<%=request.getContextPath()%>/cstm/product.jsp?productNo=<%=p.getProductNo()%>'"><%=p.getProductName()%></div>
						</div>
						<div><%=q.getqTitle()%></div>
						<div><%=q.getqContent()%></div>
						<div><%=q.getqCategory()%></div>
						<div><%=q.getCreatedate().substring(0, 10)%></div>
						<%
							if(q.getqAnswer().equals("Y")){
						%>
								<div>답변완료</div>
						<%
							} else {
						%>
								<div>답변 대기중</div>
						<%
							}
						%>
						<div>
							<button type="button" class="style-btn" onclick="location.href='<%=request.getContextPath()%>/cstm/question.jsp?id=<%=id%>&qNo=<%=q.getqNo()%>'">상세보기</button>
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