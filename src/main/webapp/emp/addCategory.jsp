<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lilac</title>
	<!-- css파일 -->
	<link href="<%=request.getContextPath()%>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath()%>/images/favicon.png"/>
</head>
<body>
<!-- 메인메뉴 -->
<div>
<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
</div>

<div class="container">
	<!-- 메세지 -->
	     	<%
			if(request.getParameter("msg") != null) {
		%>
			<div><%=request.getParameter("msg")%></div>				
		<%
	        	}
		%>
		
	<!-- 카테고리 추가폼 -->
	<form action="<%=request.getContextPath()%>/emp/addCategoryAction.jsp" method="post">
		<div> 카테고리명 <input type="text" name="categoryName"></div>
		<div><button type="submit">추가</button></div>
	</form>
</div>
</body>
</html>