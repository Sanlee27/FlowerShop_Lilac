<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	System.out.println(id);
	System.out.println(pw);

    CustomerDao dao = new CustomerDao();

	Id cstmId = new Id();
	cstmId.setId(id);
	cstmId.setLastPw(pw);
	
	int ckModifyPw = dao.ckPw(cstmId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 확인</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script type="text/javascript">
    	// 비밀번호를 확인해서 로그인된 아이디의 비밀번호가 틀리다면
	    function closeAndClear() {
	        var openerWindow = window.opener;
	        if (openerWindow) {
	        	// 창이 열렸을떄 pw값
	            var inputElement = openerWindow.document.getElementsByName("pw")[0];
	            if (inputElement) {
	            	// 공백 = 지움 처리
	                inputElement.value = '';
	            }
	        }
	        // 창닫음
	        window.close();
	    }
    	
	 // 비밀번호를 확인해서 로그인된 아이디의 비밀번호가 일치하면
	    function closeAndUse() {
            var openerWindow = window.opener;
            if (openerWindow) {
            	// 창이 닫히고나서 버튼 비활성화
                var inputElement = openerWindow.document.getElementsByName("ckPw")[0];
                if (inputElement) {
                    inputElement.disabled = true;
                }
            }
            window.close();
        }
	</script>
</head>
<body>
	<% 
		if (ckModifyPw != 1) { 
	%>
		<div style="text-align: center;">
	        <br/><br/>
	        <h4>비밀번호가 틀립니다.</h4>
	        <button type="button" onclick="closeAndClear()">닫기</button>
	    </div>
	<% 
		} else { 
	%>
	    <div style="text-align: center;">
	        <br/><br/>
	        <h4>비밀번호가 일치합니다.</h4>
	        <button type="button" onclick="closeAndUse()">닫기</button>
	    </div>
	<% 
		} 
	%>
</body>
</html>
