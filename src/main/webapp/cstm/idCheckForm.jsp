<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.CustomerDao"%>

<%
	System.out.println(request.getParameter("id"));
    String idValue = request.getParameter("id");
    CustomerDao dao = new CustomerDao();
    int ckRow = dao.checkId(idValue);
    if(ckRow == 1){
    	response.setStatus(400);
		return;
    }
    response.setStatus(200);
    return;
%>