<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String loginMemberId = (String)session.getAttribute("고객");

	// 로그인한 상태로 로그인폼에 접근시, 홈으로 이동
	if(loginMemberId != null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
	}
		
	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	String id = request.getParameter("id");
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
		<h1>로그인</h1>
		<form method="post" name = "form">
			<table>
				<tr>
					<th>아이디</th>
					<td>
						<%
							// 메세지가 없거나(=로그인 디폴트) 휴면계정 메세지 아닐때(비밀번호 틀림 표시 등일때)
							if(msg == null || !msg.equals("휴면계정입니다. 다시 로그인해주세요.") && !msg.equals("비밀번호를 확인하세요.")){
						%>
								<input type = "text" name = "id" required="required">
						<%	
							// 휴면계정 일 경우 재로그인 요구
							} else if(msg != null && msg.equals("휴면계정입니다. 다시 로그인해주세요.")){
						%>
								<input type = "text" name = "id" value=<%=id%> readonly="readonly">
						<%
							} else if (msg != null && msg.equals("비밀번호를 확인하세요.")) {
						%>
						    	<input type="text" name="id" value="<%=id%>" readonly="readonly">
						<%
							}
						%>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type = "password" name = "pw" required="required">
					</td>
				</tr>
			</table>
			<%
				if(msg != null){
			%>
					<%=msg%>
			<%
				}
			%>
			<br>
			<%
				if(msg == null || (msg != null && !msg.equals("휴면계정입니다. 다시 로그인해주세요.") && !msg.equals("비밀번호를 확인하세요."))){
			%>
					<button type = "submit" onclick = "javascript: form.action='<%=request.getContextPath()%>/cstm/loginAction.jsp';">로그인</button>
			<%
				} else if(msg != null && (msg.equals("휴면계정입니다. 다시 로그인해주세요.") || msg.equals("비밀번호를 확인하세요."))){
			%>
					<button type = "submit" onclick = "javascript: form.action='<%=request.getContextPath()%>/cstm/modifyActiveAction.jsp';">로그인</button>
			<%	
				}
			%>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/join.jsp'">회원가입</button>
		</form>
	</div>
</body>
</html>