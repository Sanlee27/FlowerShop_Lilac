<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CategoryDao"%> 
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	/* //유효성 검사
	if(request.getParameter("id") == null) {
		System.out.println("id 값 확인필요");
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	} */

	//DAO 불러오기
	CategoryDao categorydao = new CategoryDao();
	
	//ArrayList<Category>로 반환되는 categorydao를 categoryList에 저장
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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
		$(document).ready(function(){
			
			if("<%=request.getParameter("msg")%>" == "상품을 모두 삭제 후 카테고리를 삭제해주세요.") {
				swal("경고", "<%=request.getParameter("msg")%>", "warning");
			}else if("<%=request.getParameter("msg")%>" != "null") {
				swal("완료", "<%=request.getParameter("msg")%>", "success");
			}
		});
	</script>
</head>
<body>
<!-- 메인메뉴 -->
<div>
<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>
	
<div class="container">	
	<!-- 카테고리 리스트 -->
	<div class="list-wrapper5">
		<h2>카테고리 리스트</h2>
		<a href="<%=request.getContextPath()%>/emp/addCategory.jsp">✚</a>	
	<br>
		<div class="list-item">
			<div>카테고리명</div>
			<div>생성일</div>
			<div>수정일</div>
			<div>&nbsp;</div>
			<div>&nbsp;</div>
		</div>

		<%
			for(Category c : categoryList) {
		%>
			<form action="<%=request.getContextPath()%>/emp/modifyCategoryAction.jsp" method="post">
				<div class="list-item">
					<div>
						 <input type="hidden" name="oriCategory" value = "<%=c.getCategoryName()%>">
						 <input type="text" name="newCategory" value = "<%=c.getCategoryName()%>">
					</div>
					
					<div>
						<%=c.getCreatedate()%>
					</div>
					
					<div>
						<%=c.getUpdatedate()%>
					</div>
					
					<div>
						<button type="submit">수정</button>
					</div>
					
					<div>
						<a href="<%=request.getContextPath()%>/emp/removeCategoryAction.jsp?categoryName=<%=c.getCategoryName()%>">삭제</a>
					</div>
				</div>
			</form>
		<%
			}
		%>
		</div>
</div>
</body>
</html>