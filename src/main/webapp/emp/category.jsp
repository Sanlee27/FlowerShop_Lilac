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
		
	<!-- 카테고리 리스트 -->
	<ul>카테고리이름	생성일 	수정일</ul>
		
		<%
			for(Category c : categoryList) {
		%>
			<form action="<%=request.getContextPath()%>/emp/modifyCategoryAction.jsp">
				<input type="hidden" name="oriCategory" value = "<%=c.getCategoryName()%>">
				<input type="text" name="newCategory" value = "<%=c.getCategoryName()%>">
				<%=c.getCreatedate()%>
				<%=c.getUpdatedate()%>
				<button type="submit">수정</button>
				<a href="<%=request.getContextPath()%>/emp/removeCategoryAction.jsp?categoryName=<%=c.getCategoryName()%>">삭제</a>
			</form>
		<%
			}
		%>
</div>
</body>
</html>