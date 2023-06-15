<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	//세션 유효성 검사
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;
	}
	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// 입력받은 비밀번호가 저장된 값과 같은지
	Id ckIdPw = new Id();
	ckIdPw.setId(id);
	ckIdPw.setLastPw(pw);
	
	int ckPw = dao.ckPw(ckIdPw);
	if(ckPw !=1){
%>
		<script>
			function ckPwErr(){
				alert("비밀번호가 일치하지 않습니다. \n"); // 경고창
				history.back(); // 이전 페이지로 돌아가기
			}
		</script>
		<body onload = "ckPwErr()">
		</body>
<%	
		return;
	}
	
	// customer테이블에서 정보 삭제
	int deleteCstm = dao.deleteCustomer(ckIdPw);
	
	session.invalidate(); // 세션 초기화
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>