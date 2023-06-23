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
			let pw = $('input[name="pw"]');
			let newPw = $('input[name="newPw"]');
			let newPw2 = $('input[name="newPw2"]');
			let pwMsg0 = $('#pwMsg0');
			let pwMsg = $('#pwMsg');
			let pwMsg2 = $('#pwMsg2');
			
			pw.blur(function(){
				if(pw.val().length<4){
					swal("경고", "비밀번호는 최소 4자를 충족해야합니다.", "warning");
	    			pwMsg0.text('비밀번호는 최소 4자를 충족해야합니다.');
				} else {
					pwMsg0.text('');
				}
			});
			
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
			
		    let submitButton = $('#modifyBtn');
		    
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
		 	
		function pwCkBtn(){
			
			let xhr = new XMLHttpRequest();
			let url = '<%=request.getContextPath()%>/cstm/modifyCstmPwAction.jsp';
			let params = new URLSearchParams();
			params.append('id', '<%=id%>');
			params.append('pw', $('input[name="pw"]').val());
			params.append('newPw', $('input[name="newPw"]').val());
			params.append('newPw2', $('input[name="newPw2"]').val());
			xhr.open('POST', url, true);
			xhr.setRequestHeader('Content-type', 'text/plain'); /* text-plain : 서버는 요청을 텍스트 형식으로 처리 */
			xhr.onreadystatechange = function() {
				  if (xhr.readyState === 4) {
				    if (xhr.status === 200) {
				      swal("성공", "비밀번호가 변경되었습니다.", "success");
				      setTimeout(function() {
				        window.location.href = '<%=request.getContextPath()%>' + '/cstm/cstmInfo.jsp?id=' + '<%=id%>';
				      }, 1000);
				    } else {
				      let responseText = xhr.responseText.trim(); // 응답 텍스트 공백제거
				      console.log(xhr.responseText);
				      if (xhr.status === 400) {
				        if (responseText === "curPwMismatch") {
				          swal("실패", "현재 비밀번호가 일치하지 않습니다.", "error");
				          $('input[name="pw"]').val('');
				        } else if (responseText === "newPwSameAsHistory") {
				          swal("실패", "새 비밀번호가 이전 3개 비밀번호와 동일합니다.", "error");
				          $('input[name="newPw"]').val('');
				          $('input[name="newPw2"]').val('');
				        } else {
				          swal("실패", "오류가 발생했습니다.", "error");
				          $('input[name="pw"]').val('');
				          $('input[name="newPw"]').val('');
				          $('input[name="newPw2"]').val('');
				        }
				      }
				    }
				  }
				};

				xhr.send(params);
		}
	</script>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<h1>비밀번호 변경</h1>
		<div class="font-line"></div>
			<div class="form-list">
				<div>
					<div>현재 비밀번호</div>
					<div>
						<input type = "hidden" name = "id"  value="<%=id%>" readonly="readonly">
						<input type = "password" name = "pw" required="required" placeholder="현재 비밀번호를 입력하세요.">
						<span id="pwMsg0" style="color: red;"></span>
					</div>
				</div>
				<div>
					<div>새로운 비밀번호</div>
					<div>
						<input type = "password" name = "newPw" required="required" placeholder="새로운 비밀번호를 입력하세요.">
						<span id="pwMsg" style="color: red;"></span>
					</div>
				</div>
				<div>
					<div>비밀번호 재입력</div>
					<div>
						<input type = "password" name = "newPw2" disabled="disabled" required="required" placeholder="한번 더 입력하세요.">
						<span id="pwMsg2" style="color: red;"></span>
					</div>
				</div>
			</div>
			<br>
			<button type="button" class="style-btn" id="modifyBtn"onclick="pwCkBtn()">저장</button>
			<button type="button" class="style-btn" onclick="location.href='<%=request.getContextPath()%>/cstm/cstmInfo.jsp?id=<%=id%>'">뒤로가기</button>
	</div>
	<jsp:include page="/cstm/cart.jsp"></jsp:include>
</body>
</html>