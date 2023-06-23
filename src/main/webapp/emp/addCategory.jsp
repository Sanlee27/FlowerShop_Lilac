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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
		$(document).ready(function(){
			if("<%=request.getParameter("msg")%>" != "null"){
				swal("경고", "<%=request.getParameter("msg")%>", "warning");
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
	<!-- 카테고리 추가폼 -->
	<h1>카테고리 추가</h1>
	<div class="font-line"></div>
	<form action="<%=request.getContextPath()%>/emp/addCategoryAction.jsp" method="post">
		<div class="form-list">
			<div>
				<div> 카테고리명</div> 
				<div><input type="text" name="categoryName"></div>
			</div>
			<br>
				<button type="submit" class="style-btn">추가</button>
				<button type="submit" class="style-btn" formaction="<%=request.getContextPath()%>/emp/category.jsp">이전</button>
		</div>
	</form>
</div>
<!-- footer -->
<jsp:include page="/inc/footer.jsp"></jsp:include>
</body>
</html>