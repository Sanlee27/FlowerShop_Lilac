<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 _ 로그인전이면 로그인폼으로 돌아가게
	if(session.getAttribute("loginId") == null){ 
		response.sendRedirect(request.getContextPath()+"/cstm/login.jsp");
		return;		
	}
	
	/*
	System.out.println(request.getParameter("id"));
	System.out.println(request.getParameter("pw"));
	System.out.println(request.getParameter("newPw"));
	System.out.println(request.getParameter("newPw2"));
	*/
	
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String newPw = request.getParameter("newPw");
	String newPw2 = request.getParameter("newPw2");
	
	// 클래스 객체 생성
	CustomerDao dao = new CustomerDao();
	
	// 현재 비밀번호가 맞는지
	Id curPw = new Id();
	curPw.setId(id);
	curPw.setLastPw(pw);
	
	int ckPw = dao.ckPw(curPw);
	if(ckPw != 1){
%>
		<script>
			function ckPwErr(){
				alert("현재 비밀번호가 일치하지 않습니다. \n"); // 경고창
				history.back(); // 이전 페이지로 돌아가기
			}
		</script>
		<body onload = "ckPwErr()">
		</body>
<%	
		return;
	}
	// 비밀번호 이력에서 새로운 비밀번호가 현재 포함 최근 비밀번호 3개와 다른지
	int ckPwHistory = dao.checkPwHistory(curPw, newPw);
	// System.out.println(ckPwHistory);
	// 같은게 있다면 경고 띄우고 리다이렉트
	if(ckPwHistory > 0){
%>
		<script>
			function ckPwHtryErr(){
				alert("새 비밀번호가 이전 비밀번호 3개와 동일합니다. \n새로운 비밀번호를 입력해주세요"); // 경고창
				history.back(); // 이전 페이지로 돌아가기
			}
		</script>
		<body onload = "ckPwHtryErr()">
		</body>
<%
		return;
	}
	// 위에 2개 다 통과하면 비밀번호 업데이트
	int uptPw = dao.updatePw(curPw, newPw);
	if(uptPw < 4){
		String msg = null;
		msg = URLEncoder.encode("비밀번호가 변경되었습니다","UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/cstmInfo.jsp?id="+id+"&msg="+msg);
	}
%>