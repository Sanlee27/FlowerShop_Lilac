<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "dao.*" %>

<%
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//유효성 검사

	//요청값 변수에 저장
	//int qNo = Integer.parseInt(request.getParameter("qNo"));
	int qNo = 2;

	//클래스 객체 생성
	QuestionDao questionDao = new QuestionDao();
	
	//상세페이지 객체 생성
	Question one = questionDao.questionOne(qNo);

	System.out.println(one);
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>문의 수정</h1>
	<form action="<%=request.getContextPath()%>/cstm/modifyQuestionAction.jsp" method="get">
		<table>
			<tr>
				<td>qNo</td>
				<td><%=one.getqNo() %></td>
			</tr>

			<tr>
				<td>id</td>
				<td>
					<input type="text" name="id" value="<%=one.getId()%>" readonly = "readonly" >
				</td>
			</tr>
			
			<tr>
				<td>qCategory</td>
				<td><select name= "qCategory">
						<option value="상품">상품</option>
						<option value="결제">결제</option>
						<option value="배송">배송</option>
						<option value="기타">기타</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>qAnswer</td>
				<td>
					<input type="text" name="qAnswer" value="<%=one.getqAnswer()%>" readonly = "readonly" >
				</td>
			</tr>
			
			<tr>
				<td>qTitle</td>
				<td>
					<input type= "hidden" name ="id" value=<%=one.getId() %>>
					<input type= "text" name="qTitle"  onclick="if(this.value=='타이틀을 입력하세요'){this.value=''}" value="타이틀을 입력하세요"> <!-- text를 클릭하면 value 값 지워짐 -->
				</td>
			</tr>
			<tr>
				<td>qContent</td>
				<td>
					<input type= "hidden" name ="id" value=<%=one.getId() %>>
					<input type= "text" name="qContent" onclick="if(this.value=='내용을 입력하세요'){this.value=''}" value="내용을 입력하세요" > 
				</td>
			</tr>
			<tr>
				<td>updatedate</td>
				<td><%=one.getUpdatedate() %></td>
			</tr>
			<tr>
				<td>createdate</td>
				<td><%=one.getCreatedate() %></td>
			</tr>
		
		</table>
			<button type="submit">수정</button>
	</form>
</body>
</html>