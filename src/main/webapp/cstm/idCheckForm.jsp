<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.CustomerDao"%>

<%
    String id = request.getParameter("id");
    CustomerDao dao = new CustomerDao();
    int ckRow = dao.checkId(id);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <script type="text/javascript">
    	// 아이디 값이 이미 사용중이라면 join.jsp에서 입력된값을 지움
	    function closeAndClear() {
	        var openerWindow = window.opener;
	        if (openerWindow) {
	        	// 창이 열렸을떄 id값
	            var inputElement = openerWindow.document.getElementsByName("id")[0];
	            if (inputElement) {
	            	// 공백 = 지움 처리
	                inputElement.value = '';
	            }
	        }
	        // 창닫음
	        window.close();
	    }
    	
    	// 아이디 값이 사용핳수있다면 그대로 사용
	    function closeAndUse() {
            var openerWindow = window.opener;
            if (openerWindow) {
            	// 창이 열렸을때 버튼 비활성화
                var inputElement = openerWindow.document.getElementsByName("ckId")[0];
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
		if (ckRow == 1) { 
	%>
		<div style="text-align: center;">
	        <br/><br/>
	        <h4>이미 사용 중인 ID입니다.</h4>
	        <button type="button" onclick="closeAndClear()">닫기</button>
	    </div>
	<% 
		} else { 
	%>
	    <div style="text-align: center;">
	        <br/><br/>
	        <h4>입력하신 <%=id%>는 사용 가능합니다.</h4>
	        <button type="button" onclick="closeAndUse()">사용하기</button>
	    </div>
	<% 
		} 
	%>
</body>
</html>
