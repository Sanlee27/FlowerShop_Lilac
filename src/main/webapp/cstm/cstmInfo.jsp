<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("고객") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;		
	}
	
	String loginMemberId = (String)session.getAttribute("고객");
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
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>마이페이지</h1>
		<table>
			<tr>
				<th>아이디</th>
				<td><%=cstm.getId() %></td>
			</tr>
			<tr>
				<th>이름</th>
				<td><%=cstm.getCstmName()%></td>
			</tr>
			<tr>
				<th>성별</th>
				<td><%=cstm.getCstmGender()%></td>
			</tr>
			<tr>
				<th>생년월일</th>
				<td><%=cstm.getCstmBirth().substring(0, 10)%></td>
			</tr>
			<tr>
				<th>연락처</th>
				<td><%=cstm.getCstmPhone()%></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><%=cstm.getCstmEmail()%></td>
			</tr>
			<tr>
				<th>주소</th>
				<td><%=cstm.getCstmAddress()%></td>
			</tr>
			<tr>
				<th>약관 동의</th>
				<td><%=cstm.getCstmAgree()%></td>
			</tr>
			<tr>
				<th>보유 포인트</th>
				<td><%=cstm.getCstmPoint()%></td>
			</tr>
			<tr>
				<th>현재 등급</th>
				<td><%=cstm.getCstmRank()%></td>
			</tr>
			<tr>
				<th>가입 일자</th>
				<td><%=cstm.getCreatedate().substring(0, 10)%></td>
			</tr>
		</table>
		<br>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/modifyCstmInfo.jsp?id=<%=cstm.getId()%>'">수정하기</button>
	</div>
</body>
</html>