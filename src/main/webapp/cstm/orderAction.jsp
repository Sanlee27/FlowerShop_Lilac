<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%
	// 인코딩 설정
	request.setCharacterEncoding("utf-8");

	// 요청값 유효성 검사
	if(request.getParameter("productNo") == null
	|| request.getParameter("id") == null
	|| request.getParameter("orderCnt") == null
	|| request.getParameter("address") == null
	|| request.getParameter("toAddPoint") == null
	|| request.getParameter("toSpendPoint") == null
	|| request.getParameter("isDefaultAddr") == null
	|| request.getParameter("productNo").equals("")
	|| request.getParameter("id").equals("")
	|| request.getParameter("orderCnt").equals("")
	|| request.getParameter("address").equals("")
	|| request.getParameter("toAddPoint").equals("")
	|| request.getParameter("toSpendPoint").equals("")
	|| request.getParameter("isDefaultAddr").equals("")){
		return;
	}
	// 요청값 저장
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	String id = request.getParameter("id");
	int orderCnt = Integer.parseInt(request.getParameter("orderCnt"));
	int totalPrice = Integer.parseInt(request.getParameter("totalPrice"));
	String address = request.getParameter("address");
	int toAddPoint = Integer.parseInt(request.getParameter("toAddPoint"));
	int toSpendPoint = Integer.parseInt(request.getParameter("toSpendPoint"));
	boolean isDefaultAddr = Boolean.parseBoolean(request.getParameter("isDefaultAddr"));
	
	// Order객체에 order데이터 추가
	Order order = new Order();
	order.setProductNo(productNo);
	order.setId(id);
	order.setOrderCnt(orderCnt);
	order.setOrderPrice(totalPrice);
	
	// OrderDao 객체 선언
	OrderDao orderDao = new OrderDao();
	
	// order데이터 추가 후 orderNo받아오기
	int orderNo = orderDao.insertOrder(order);
	
	// 기본주소지가 아닐때만
	if(!isDefaultAddr){
		// Address객체에 address데이터 추가
		Address addr = new Address();
		addr.setId(id);
		addr.setAddress(address);
		
		// AddressDao 객체 선언
		AddressDao addressDao = new AddressDao();
		
		// address정보 업데이트
		int addressRow = addressDao.updateAddress(addr);
	}
	
	// PointDao객체 선언
	PointDao pointDao = new PointDao();
	
	// 사용포인트 있으면 업데이트
	if(toSpendPoint != 0){
		// point 데이터 담아줄 객체생성
		Point spendPoint = new Point();
		spendPoint.setOrderNo(orderNo);
		spendPoint.setPointPm("-");
		spendPoint.setPoint(toSpendPoint);
		
		// 사용 포인트 업데이트
		int spendPointRow = pointDao.updatePoint(spendPoint, id);
	}
	
	// 적립 포인트 업데이트
	// point 데이터 담아줄 객체 생성
	Point addPoint = new Point();
	addPoint.setOrderNo(orderNo);
	addPoint.setPointPm("+");
	addPoint.setPoint(toAddPoint);
	
	// 적립 포인트 업데이트
	int addPointRow = pointDao.updatePoint(addPoint, id);
	
	// CartDao 객체선언
	CartDao cartDao = new CartDao();
	
	// db에서 id에 해당하는 cart데이터 가져옴
	Cart cart = cartDao.selectCart(id);
	
	// cart가 없으면 return
	if(cart == null){
		return;
	}
	
	// cart에 있는 productNo랑 넘어온 productNo가 같으면 장바구니 삭제
	if(cart.getProductNo() == productNo){
		int deleteCartRow = cartDao.deleteCart(cart.getCartNo());
		System.out.println("삭제완료");
	}
	return;
%>