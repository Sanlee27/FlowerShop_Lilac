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
	
	// 아이디값 저장
	// System.out.println(request.getParameter("id"));
	String id = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Lilac</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<!-- css파일 -->
	<link href="<%=request.getContextPath() %>/style.css" type="text/css" rel="stylesheet">
	<!-- 브라우저 탭에 보여줄 아이콘 -->
	<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.png"/>
	<!-- alert창 디자인 라이브러리 -->
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<script>
		$(document).ready(function() {
			let newPw = $('input[name="newPw"]');
			let newPw2 = $('input[name="newPw2"]');
			let pwMsg = $('#pwMsg');
			let pwMsg2 = $('#pwMsg2');
			
			newPw.blur(function(){
				if(newPw.val().length<4){
					swal("경고", "비밀번호는 최소 4자를 충족해야합니다.", "warning");
	    			pwMsg.text('비밀번호는 최소 4자를 충족해야합니다.');
				} else {
					pwMsg.text('');
					newPw2.prop('disabled',false);
				}
			});
			
			newPw.blur(function() {
			    if (newPw2.val() !== '' && newPw.val() !== newPw2.val()) {
			        swal("경고", "새 비밀번호가 일치하지 않습니다.", "warning");
			        pwMsg2.text('새 비밀번호가 일치하지 않습니다.');
			    } else {
			        pwMsg2.text('');
			    }
			});
			
			newPw2.blur(function(){
				if(newPw.val() !== newPw2.val()){
					swal("경고", "새 비밀번호가 일치하지않습니다.", "warning");
	    			pwMsg2.text('새 비밀번호가 일치하지않습니다.');
				} else {
					pwMsg2.text('');
				}
			});
			
		    let submitButton = $('button[type="submit"]');
		    
		 	// 비밀번호 확인을 안하고 저장을 먼저 눌렀을때.
	 	    submitButton.click(function(){
	 	    	if(pwMsg.text() !== '' || pwMsg2.text() !== ''){
	 	    		event.preventDefault(); // submit막음
	 	    		pwMsg2.text('비밀번호 일치여부를 확인해주세요');
	 	    	} else {
	 	    		pwMsg2.text('');
	 	    	}
	 	    });
		 	
		});
	</script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>비밀번호 변경</h1>
		<form action="<%=request.getContextPath()%>/cstm/modifyCstmPwAction.jsp" method="post">
			<table>
				<tr>
					<th>현재 비밀번호</th>
					<td>
						<input type = "hidden" name = "id"  value="<%=id%>" readonly="readonly">
						<input type = "password" name = "pw" required="required">
					</td>
				</tr>
				<tr>
					<th>새로운 비밀번호</th>
					<td>
						<input type = "password" name = "newPw" required="required">
						<span id="pwMsg" style="color: red;"></span>
					</td>
				</tr>
				<tr>
					<th>비밀번호 재입력</th>
					<td>
						<input type = "password" name = "newPw2" disabled="disabled" required="required">
						<span id="pwMsg2" style="color: red;"></span>
					</td>
				</tr>
			</table>
			<button type="submit">저장</button>
			<button type="button" onclick="location.href='<%=request.getContextPath()%>/cstm/cstmInfo.jsp?id=<%=id%>'">뒤로가기</button>
		</form>
	</div>
</body>
</html>