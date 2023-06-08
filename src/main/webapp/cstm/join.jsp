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
<title>회원가입</title>
</head>
<body>
	<h1>회원가입</h1>
	<form action="<%=request.getContextPath()%>/cstm/joinAction.jsp">
		<table>
			<tr>
				<th>아이디</th>
				<td>
					<input type = "text" name = "id" placeholder = "아이디를 입력하세요" required="required">
					<button type="button" name = "id" onclick="location.href='<%=request.getContextPath()%>/cstm/idCheckAction.jsp'">아이디 중복확인</button>
				</td>
			</tr>
				<%
					if(msg != null){
				%>
						<%=msg%>
				<%
					}
				%>
			<tr>
				<th>비밀번호</th>
				<td>
					<input type = "password" name = "pw" required="required">
				</td>
			</tr>
			<tr>
				<th>비밀번호 재입력</th>
				<td>
					<input type = "password" name = "rePw" required="required">
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td>
					<input type = "text" name = "name" required="required">
				</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>
					<input type = "radio" name = "gender" value= "남"> 남
					<input type = "radio" name = "gender" value= "여"> 여
				</td> 
			</tr>
			<tr>
				<th>생년월일</th>
				<td>
					<input type = "date" name = "birth">
				</td>
			</tr>
			<tr>
				<th>주소</th>
				<td>
					<input type = "text" name = "address">
				</td>
			</tr>
			<tr>
				<th>연락처</th>
				<td>
				</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>
				</td>
			</tr>
			<tr>
				<th>약관동의</th>
				<td>
				</td>
			</tr>
		</table>
	</form>
	<script>
		function winopen(){
			window.open("idCheckForm.jsp?id="+document.fr.id.value,"","width=500, height=300");
		}
	</script>
</body>
</html>