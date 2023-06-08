<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String loginMemberId = (String)session.getAttribute("loginMemberId");

	String msg = null;
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head> 
<body>
	<h1>로그인</h1>
	<form method="post" name = "form">
		<table>
			<tr>
				<th>아이디</th>
				<td>
					<input type = "text" name = "id" required="required">
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
				<button type = "submit" onclick = "javascript: form.action='<%=request.getContextPath()%>/cstm/loginAction.jsp';">로그인</button>
		<%
			if(msg != null && msg.equals("휴면계정입니다. 다시 로그인해주세요.")){
		%>
				<button type = "submit" onclick = "javascript: form.action='<%=request.getContextPath()%>/cstm/modifyActiveAction.jsp';">로그인</button>
		<%	
			}
		%>
	</form>
</body>
</html>