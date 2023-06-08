<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	//id, pw 변수 저장
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	System.out.println(id );
	System.out.println(pw);
	
	String msg = null;
	if(id == null || pw == null){
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp?id="+id+"&msg="+msg);
		return;
	}
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	Id sleepId = new Id();
	sleepId.setId(id);
	sleepId.setActive("N");
	
	// 재로그인 비밀번호 틀릴 시 메세지 표시
	int login = dao.ckIdPw(id, pw);
	if(login == 0){
		msg = URLEncoder.encode("비밀번호를 확인하세요.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp?id="+id+"&msg="+msg);
		return;
	}
	
	// 휴면계정 재로그인시 active Y로 변경
	int activeY = dao.updActive(sleepId);
	System.out.println(activeY);
	
	// last_login 날짜 로그인한 시점으로 변경
	int addLastLogin = dao.updLastLogin(id);
	session.setAttribute("고객", id);
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
%>