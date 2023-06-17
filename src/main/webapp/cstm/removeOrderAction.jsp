<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	//System.out.println(request.getParameter("id"));
	//System.out.println(request.getParameter("orderNo"));
	//System.out.println(request.getParameter("orderCnt"));
	
	String id = request.getParameter("id");
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int orderCnt = Integer.parseInt(request.getParameter("orderCnt"));
	String orderStatus = "취소";
	
	// 클래스 객체 생성
	OrderDao dao = new OrderDao();
	
	Order cancelOdr = new Order();
	cancelOdr.setOrderNo(orderNo);
	cancelOdr.setOrderCnt(orderCnt);
	cancelOdr.setOrderStatus(orderStatus);
	
	int delOrder = dao.updateOrderStatus(cancelOdr);
	// System.out.println(delOrder);
	if(delOrder > 0){
		PointDao pDao = new PointDao();
		
		Point point = new Point();
		point.setOrderNo(cancelOdr.getOrderNo());
		point.setPointPm(point.getPointPm());
		point.setPoint(point.getPoint());
		System.out.println(point);
		
		int cancel = pDao.cancelPoint(point, id);		
		
		String msg = null;
		msg = URLEncoder.encode("취소가 정상적으로 처리되었습니다.","UTF-8");
		response.sendRedirect(request.getContextPath()+"/cstm/orderList.jsp?id="+id+"&msg="+msg);
	}
	
%>