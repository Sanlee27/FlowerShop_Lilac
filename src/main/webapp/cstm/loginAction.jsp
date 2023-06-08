<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;
	}
	// 요청값 유효성 검사
	// id, pw 변수 저장
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	String msg = null;
	if(id == null || pw == null){
		msg = URLEncoder.encode("아이디 또는 비밀번호를 확인하십시오.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp?msg="+msg);
		return;
	}
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// 1) id, pw 맞는지 확인
	int login = dao.ckIdPw(id, pw);
	if(login == 0){
		msg = URLEncoder.encode("아이디 또는 비밀번호를 확인하세요","UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp?msg="+msg);
		return;
	}
	// 2) 관리자 / 고객 / 탈퇴회원별 페이지 이동
	// 로그인 세션정보 저장 추가++++
	String ckId = dao.ckId(id);
	System.out.println("로그인된 아이디는 : " + ckId + "입니다");
	if(ckId.equals("관리자1")){
		session.setAttribute("관리자1", id);
		response.sendRedirect(request.getContextPath()+"/employees.jsp");
		return;
	} else if(ckId.equals("관리자2")){
		session.setAttribute("관리자2", id);
		response.sendRedirect(request.getContextPath()+"/employees.jsp");
		return;
	} else if(ckId.equals("없는 회원")){
		msg = URLEncoder.encode("탈퇴한 회원입니다","UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp?msg="+msg);
		return;
	} else if(ckId.equals("고객")){
		// 마지막 로그인 일자 확인하여 3개월이 지났으면 활성화여부 N으로 변경
		int activeN = dao.ckSleepId(id);
		// 활성화 여부 확인
		String active = dao.ckActive(id);
		System.out.println("로그인한 아이디의 활동여부는 " + active + "입니다");
		
		// 활성화 여부가 Y = 활동계정이면
		if(active.equals("Y")){
			// last_login 날짜 로그인한 시점으로 변경
			int addLastLogin = dao.updLastLogin(id);
			session.setAttribute("고객", id);
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			return;
		// 활성화 여부가 N = 휴면계정이면
		} else {
			msg = URLEncoder.encode("휴면계정입니다. 다시 로그인해주세요.","UTF-8");
			response.sendRedirect(request.getContextPath()+"/cstm/login.jsp?id="+id+"&msg="+msg);
			return;
		}
	}
%>
