<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("고객") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;	
	}
	
	String loginMemberId = (String)session.getAttribute("고객");
	// System.out.println(loginMemberId);
	
	// 들어온 값 먼저 검사
	/*
	System.out.println(request.getParameter("id"));
	System.out.println(request.getParameter("names"));
	System.out.println(request.getParameter("gender"));
	System.out.println(request.getParameter("birth"));
	System.out.println(request.getParameter("phone1"));
	System.out.println(request.getParameter("phone2"));
	System.out.println(request.getParameter("phone3"));
	System.out.println(request.getParameter("email1"));
	System.out.println(request.getParameter("email2"));
	System.out.println(request.getParameter("address1"));
	System.out.println(request.getParameter("address2"));
	System.out.println(request.getParameter("agree"));
	System.out.println(request.getParameter("pw"));
	*/
	
	String id = request.getParameter("id");
	String name = request.getParameter("names");
	String gender = request.getParameter("gender");
	String birth = request.getParameter("birth");
	String phone = request.getParameter("phone1") + request.getParameter("phone2") + request.getParameter("phone3");
	String email = request.getParameter("email1") + "@" + request.getParameter("email2");
	String address = request.getParameter("address1") + " " + request.getParameter("address2");
	String agree = request.getParameter("agree");
	String pw = request.getParameter("pw");
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	/*
	// 수정 폼 내 비밀번호 확인 버튼으로 처리
	// 비밀번호 먼저 확인해서 맞는지. 맞다면 그때 업데이트
	Id cstmId = new Id();
	cstmId.setId(id);
	cstmId.setLastPw(pw);
	
	System.out.println(cstmId.getId());
	System.out.println(cstmId.getLastPw());
	
	/*
	int ckModifyPw = dao.ckPw(cstmId);
	if(ckModifyPw != 1){
		System.out.println("수정실패 : 비밀번호 오류");
		response.sendRedirect(request.getContextPath()+"/cstm/modifyCstmInfo.jsp?id="+cstmId.getId());
	}
	*/
	// 고객 수정 객체
	Customer modifyCstm = new Customer();
	modifyCstm.setCstmName(name);
	modifyCstm.setCstmGender(gender);
	modifyCstm.setCstmBirth(birth);
	modifyCstm.setCstmPhone(phone);
	modifyCstm.setCstmEmail(email);
	modifyCstm.setCstmAddress(address);
	modifyCstm.setCstmAgree(agree);
	modifyCstm.setId(id);
	
	int modifyCstmInfo = dao.updateCustomer(modifyCstm);
	response.sendRedirect(request.getContextPath()+"/cstm/cstmInfo.jsp?id="+id);
	
%>