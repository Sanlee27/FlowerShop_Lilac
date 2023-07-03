<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String loginId = (String)session.getAttribute("loginId");

	// 로그인한 상태로 로그인폼에 접근시, 홈으로 이동
	if(loginId != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	}
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
		input[type='date']::before {
		  content: attr(data-placeholder);
		  width: 100%;
		}
	</style>
</head> 
<body>
	<div class="container">
		<form method="post" name = "form" class="login-form">
		<a href="<%=request.getContextPath() %>/home.jsp">
			<img src="<%=request.getContextPath() %>/images/logo.png">
		</a>
			<div>
				<div>
					<input type = "text" name = "name" required="required" placeholder="이름">
				</div>
				<div>
					<input type = "date" name = "birth" required="required" data-placeholder="생년월일">
				</div>
				<div>
					<input type = "email" name = "email" required="required" placeholder="이메일">
				</div>
			</div>
			<button type="submit" onclick="location.href='<%=request.getContextPath()%>/cstm/findIdAction.jsp'" class="style-btn">아이디 찾기</button>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/findPw.jsp'" class="style-btn">비밀번호 찾기</button>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/login.jsp'" class="style-btn">로그인 화면으로</button>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/join.jsp'" class="style-btn">회원가입</button>
		</form>
	</div>
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>