<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	
	String loginMemberId = (String)session.getAttribute("loginId");
	// System.out.println(loginMemberId);
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// 고객정보출력 메소드
	Customer cstm = new Customer();
	cstm = dao.selectCustomerInfo(loginMemberId);
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
		<h1>회원 탈퇴</h1>
		<form action="<%=request.getContextPath()%>/cstm/removeCstmInfoAction.jsp" method="post">
			<table>
				<tr>
					<th>아이디</th>
					<td><%=cstm.getId()%></td>
					<td>
						<input type="hidden" name="id" value="<%=cstm.getId()%>" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="pw" required="required">
					</td>
				</tr>
			</table>
			<a>탈퇴 후 재가입시 현재 아이디는 사용이 불가합니다.</a><br>
			<button type="submit">회원탈퇴</button>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/cstmInfo.jsp?id=<%=cstm.getId()%>'">뒤로가기</button>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/logoutAction.jsp'">로그아웃</button>
		</form>
	</div>
</body>
</html>