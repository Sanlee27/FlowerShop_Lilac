<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%
	// 요청값 유효성 검사
	if(request.getParameter("addressNo") == null
	|| request.getParameter("addressNo").equals("")){
		return;
	}
	
	// 요청값 저장
	int addressNo = Integer.parseInt(request.getParameter("addressNo"));
	
	// AddressDao 객체선언
	AddressDao addressDao = new AddressDao();
	int row = addressDao.deleteAddress(addressNo);
	return;
%>