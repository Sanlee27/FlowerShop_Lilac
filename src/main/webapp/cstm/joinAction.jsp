<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	// 들어온 값 유효성검사
		// 유효성검사_오류 발생시 메세지 표시
	String msg = null;
	
	if(request.getParameter("id") == null){
		msg = URLEncoder.encode("아이디를 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else if(request.getParameter("pw") == null || request.getParameter("rePw") == null){
		msg = URLEncoder.encode("비밀번호를 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else if(!request.getParameter("pw").equals(request.getParameter("rePw"))) {
		msg = URLEncoder.encode("비밀번호가 일치하지않습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
	} else if(request.getParameter("name") == null){
		msg = URLEncoder.encode("이름을 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else if(request.getParameter("gender") == null){
		msg = URLEncoder.encode("성별을 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else if(request.getParameter("birth") == null){
		msg = URLEncoder.encode("생년월일을 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else if(request.getParameter("address") == null){
		msg = URLEncoder.encode("주소를 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else if(request.getParameter("phone1") == null || request.getParameter("phone2") == null
				|| request.getParameter("phone3") == null){
		msg = URLEncoder.encode("연락처를 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else if(request.getParameter("email1") == null || request.getParameter("email2") == null){
		msg = URLEncoder.encode("이메일을 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	} else if(request.getParameter("agree") == null){
		msg = URLEncoder.encode("약관동의를 확인하세요.", "UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/join.jsp?msg="+msg);
		return;
	}
	// 변수에 저장
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String name = request.getParameter("name");
	String gender = request.getParameter("gender");
	String birth = request.getParameter("birth");
	String address = request.getParameter("address");
	String phone = request.getParameter("phone1") + request.getParameter("phone2") + request.getParameter("phone3");
	String email = request.getParameter("email1") + "@" + request.getParameter("email2"); 
	String agree = request.getParameter("agree");
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// id_list에 아이디 비밀번호 먼저 입력
	
	// 그 다음 customer에 값 입력
	// 제대로 다 입력되면 로그인 폼으로 다시 보냄
%>