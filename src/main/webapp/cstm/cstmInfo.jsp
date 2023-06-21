<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	String loginMemberId = (String)session.getAttribute("loginId");
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
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script>
		$(document).ready(function() {
			
			if("<%=request.getParameter("msg")%>" != "null"){
		 		swal("완료", "<%=request.getParameter("msg")%>", "success");
		 	}
		});
	</script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>마이페이지</h1>
		<div>
			<div>
				<div>아이디</div>
				<div><%=cstm.getId() %></div>
			</div>
			<div>
				<div>이름</div>
				<div>
					<%=cstm.getCstmName()%>
					<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/modifyCstmPwForm.jsp?id=<%=cstm.getId()%>'">비밀번호 변경</button>
				</div>
			</div>
			<div>
				<div>성별</div>
				<div><%=cstm.getCstmGender()%></div>
			</div>
			<div>
				<div>생년월일</div>
				<div><%=cstm.getCstmBirth().substring(0, 10)%></div>
			</div>
			<div>
				<div>연락처</div>
				<div><%=cstm.getCstmPhone()%></div>
			</div>
			<div>
				<div>이메일</div>
				<div><%=cstm.getCstmEmail()%></div>
			</div>
			<div>
				<div>주소</div>
				<div><%=cstm.getCstmAddress()%></div>
			</div>
			<div>
				<div>약관 동의</div>
				<div><%=cstm.getCstmAgree()%></div>
			</div>
			<div>
				<div>보유 포인트</div>
				<div>
					<%=cstm.getCstmPoint()%>
					<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/pointList.jsp?id=<%=cstm.getId()%>'">나의 포인트</button>
				</div>
			</div>
			<div>
				<div>현재 등급</div>
				<div><%=cstm.getCstmRank()%></div>
			</div>
			<div>
				<div>가입 일자</div>
				<div><%=cstm.getCreatedate().substring(0, 10)%></div>
			</div>
		</div>
		<br>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/modifyCstmInfo.jsp?id=<%=cstm.getId()%>'">수정하기</button>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/removeCstmInfo.jsp?id=<%=cstm.getId()%>'">회원탈퇴</button>
		<br>
		<br>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/orderList.jsp?id=<%=cstm.getId()%>'">나의 주문내역</button>
		<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/cstmQnaList.jsp?id=<%=cstm.getId()%>'">나의 문의내역</button>
	</div>
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>