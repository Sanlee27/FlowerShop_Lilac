<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	// System.out.println(id);
	// System.out.println(pw);

    CustomerDao dao = new CustomerDao();

	Id cstmId = new Id();
	cstmId.setId(id);
	cstmId.setLastPw(pw);
	
	int ckModifyPw = dao.ckPw(cstmId);
	if(ckModifyPw != 1){
		response.setStatus(400);
		return;
	}
	response.setStatus(200);
	return;
%>