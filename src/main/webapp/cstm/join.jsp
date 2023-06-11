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
					<!-- 아이디 중복확인 ajax 사용 -->
					<!-- <button type="button" name = "id" onclick="location.href='<%=request.getContextPath()%>/cstm/idCheckAction.jsp'">아이디 중복확인</button> -->
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
					<input type = "radio" name = "gender" value= "남" required="required"> 남
					<input type = "radio" name = "gender" value= "여" required="required"> 여
				</td> 
			</tr>
			<tr>
				<th>생년월일</th>
				<td>
					<input type = "date" name = "birth" required="required">
				</td>
			</tr>
			<tr>
				<th>주소</th>
				<td>
					<input type = "text" name = "address" required="required">
				</td>
			</tr>
			<tr>
				<th>연락처</th>
				<td>
					<select name = "phone1">
						<option value="010" selected="selected">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
						<option value="017">017</option>
						<option value="019">019</option>
					</select> - 
					<input type = "text" name = phone2 required="required"> - 
					<input type = "text" name = phone3 required="required"> 
				</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>
					<input type = "text" name = "email1" required="required"> @
					<select name = "email2">
						<option value="선택" selected="selected">선택하세요</option>
						<option value="naver.com">naver.com</option>
						<option value="daum.net">daum.net</option>
						<option value="gmail.com">gamil.com</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>약관동의</th>
				<td>
					<input type = "radio" name = "agree" value = "동의" required="required">Y
					<input type = "radio" name = "agree" value = "거부" required="required">N
				</td>
				<!-- 약관내용 -->
			</tr>
		</table>
		<button type = "submit">로그인</button>
	</form>
</body>
</html>