<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	// id, pw 변수 저장
	String ckId = request.getParameter("id");
	
	String msg = null;
	if(ckId == null){
		msg = URLEncoder.encode("아이디를 입력하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	}
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	int ckIdResult = dao.checkId(ckId);
	if(ckIdResult == 0){
		msg = URLEncoder.encode("사용가능한 아이디입니다.","UTF-8");
		%>
		 <input type="button" value="아이디 사용하기" onclick="result();">
		 <%
		return;
	} else {
		msg = URLEncoder.encode("중복 아이디입니다.","UTF-8");
	}
%>