<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	// 들어온 값 유효성검사
	System.out.println(request.getParameter("id"));
	System.out.println(request.getParameter("pw"));
	System.out.println(request.getParameter("rePw"));
	System.out.println(request.getParameter("names"));
	System.out.println(request.getParameter("gender"));
	System.out.println(request.getParameter("birth"));
	System.out.println(request.getParameter("address1"));
	System.out.println(request.getParameter("address2"));
	System.out.println(request.getParameter("phone1"));
	System.out.println(request.getParameter("phone2"));
	System.out.println(request.getParameter("phone3"));
	System.out.println(request.getParameter("email1"));
	System.out.println(request.getParameter("email2"));
	System.out.println(request.getParameter("agree"));
		// 유효성검사_오류 발생시 메세지 표시
	String msg = null;
	
	if(!request.getParameter("pw").equals(request.getParameter("rePw"))) {
		msg = URLEncoder.encode("비밀번호가 일치하지않습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	}
	
	// 변수에 저장
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String name = request.getParameter("names");
	String gender = request.getParameter("gender");
	String birth = request.getParameter("birth");
	String address = request.getParameter("address1") + " " + request.getParameter("address2");
	String phone = request.getParameter("phone1") + request.getParameter("phone2") + request.getParameter("phone3");
	String email = request.getParameter("email1") + "@" + request.getParameter("email2"); 
	String agree = request.getParameter("agree");
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// id_list에 아이디 비밀번호 먼저 입력
	// 중복 아이디 존재시 오류메세지와 함께 리다이렉트
	int checkId = dao.checkId(id);
	if(checkId == 1){
		msg = URLEncoder.encode("아이디가 존재합니다.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else {
		// 중복아닐 경우 idList와 pwHistory에 입력
		Id joinId = new Id();
		joinId.setId(id);
		joinId.setLastPw(pw);
		int insertId = dao.insertId(joinId);
	}
	
	// 그 다음 customer에 값 입력
	Customer joinCstm = new Customer();
	joinCstm.setId(id);
	joinCstm.setCstmName(name);
	joinCstm.setCstmAddress(address);
	joinCstm.setCstmEmail(email);
	joinCstm.setCstmBirth(birth);
	joinCstm.setCstmGender(gender);
	joinCstm.setCstmPhone(phone);
	joinCstm.setCstmAgree(agree);
	
	int addCstm = dao.insertCstm(joinCstm);
	
	// 제대로 다 입력되면 로그인 폼으로 다시 보냄
	response.resetBuffer();
	response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
%>