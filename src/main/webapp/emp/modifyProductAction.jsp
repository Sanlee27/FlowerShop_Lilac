<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	
	//변수
		String msg = "";
		String dir = request.getServletContext().getRealPath("/product");
			System.out.println(dir);
		int max = 10 * 1024 * 1024; 
		// request객체를 MultipartRequest의 API를 사용할 수 있도록 랩핑
	 	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8");
	
	//productNo 유효성검사
	if(mRequest.getParameter("productNo") == null
		||mRequest.getParameter("productNo").equals("")) {
		
		System.out.println("productNo 값 필요");
		response.sendRedirect(request.getContextPath() + "/emp/productList.jsp");
		return;
	}
	
	//변수
	int productNo = Integer.parseInt(mRequest.getParameter("productNo"));
	
	//그 외 유효성검사
	if(mRequest.getParameter("productName") == null
		||mRequest.getParameter("productInfo") == null
		||mRequest.getParameter("productPrice") == null
		||mRequest.getParameter("productStock") == null
		||mRequest.getParameter("productName").equals("")
		||mRequest.getParameter("productInfo").equals("")
		||mRequest.getParameter("productPrice").equals("")
		||mRequest.getParameter("productStock").equals("")) {
		
		System.out.println("productName, productInfo, productPrice, productStock 값 필요");
		msg = URLEncoder.encode("모든 내용을 입력해주세요","utf-8"); 
		response.sendRedirect(request.getContextPath() + "/emp/modifyProduct.jsp?msg=" + msg + "&productNo=" + productNo);
		return;
	}
	
	//DAO 받아오기
	ProductDao productdao = new ProductDao();

	HashMap<String, Object> map = new HashMap<>();
	ProductImg productImg = (ProductImg)map.get("productImg");
	// 이전 imgFile을 삭제 & 새로운 imgFile 추가 & 수정
	 if(mRequest.getOriginalFileName("productImg") != null) {
		//업로드 된 컨텐츠파일이 PNG, JPG, JEPG파일 아닐때
		if(mRequest.getContentType("productImg").equals("image/png") == false 
				&& mRequest.getContentType("productImg").equals("image/jpg") == false
				&& mRequest.getContentType("productImg").equals("image/jpeg") == false){
				
				//이미 저장된 파일 삭제
				String oriFilename = mRequest.getOriginalFileName("productImg");
					System.out.println("PNG, JPG, JEPG파일이 아닙니다");

				//파일 경로 설정
				File f = new File(dir + "/" + oriFilename);
				if(f.exists()) {
					f.delete();
						System.out.println(dir + "/" + oriFilename + "파일삭제");
				}
				msg = URLEncoder.encode("PNG, JPG, JEPG파일로 업로드해주세요","utf-8"); 
			} else { 
			// PNG, JPG, JEPG파일일때 --> productimg에 저장
				String oriFilename = mRequest.getOriginalFileName("productImg");
				String saveFilename = mRequest.getOriginalFileName("productImg");
				String type = mRequest.getContentType("productImg");
				
					ProductImg productimg = new ProductImg();
					productimg.setProductNo(productNo);
					productimg.setProductOriFilename(oriFilename);
					productimg.setProductSaveFilename(saveFilename);
					productimg.setProductFiletype(type);
						System.out.println(productNo + "<-productNo");
						System.out.println(oriFilename + "<-oriFilename");
						System.out.println(saveFilename + "<-saveFilename");
						System.out.println(type + "<-type");
					map.put("productImg", productimg);
					
			//기존 이미지이름과 새로 들어온 이미지 이름이 다를 경우 기존 이미지 삭제 
				String preOriFilename = mRequest.getParameter("preProductImg");
				System.out.println(preOriFilename + "<--preProductImg");

				if(!preOriFilename.equals(mRequest.getOriginalFileName("saveFilename"))){
					File f = new File(dir + "/" + preOriFilename);
					if(f.exists()) {
						f.delete();
							System.out.println(dir + "/" + preOriFilename + "preOriFilename 파일삭제");
					} 
				}
			}
	 }

	// input type = "text" --> product에 저장
	//변수
	String categoryName = mRequest.getParameter("categoryName");
	String productName = mRequest.getParameter("productName");
	String productInfo = mRequest.getParameter("productInfo");
	int productPrice = Integer.parseInt(mRequest.getParameter("productPrice"));
	String productStatus = mRequest.getParameter("productStatus");
	int productStock = Integer.parseInt(mRequest.getParameter("productStock"));
	
		Product product = new Product();
		product.setCategoryName(categoryName);
		product.setProductName(productName);
		product.setProductPrice(productPrice);
		product.setProductStatus(productStatus);
		product.setProductInfo(productInfo);
		product.setProductStock(productStock);
		product.setProductNo(productNo);
			System.out.println(categoryName + "<-categoryName");
			System.out.println(productName + "<-productName");
			System.out.println(productPrice + "<-productPrice");
			System.out.println(productStatus + "<-productStatus");
			System.out.println(productInfo + "<-productInfo");
			System.out.println(productStock + "<-productStock");
			System.out.println(productNo + "<-productNo");
		map.put("product", product);
	
	//row에 값 넣기
	int row = productdao.updateProduct(map);
		System.out.println(row);
	if(row == 2) {
		response.sendRedirect(request.getContextPath() + "/emp/productList.jsp");
		System.out.println("성공");
	} else {
		response.sendRedirect(request.getContextPath() + "/emp/modifyProduct.jsp?productNo=" + productNo);
		System.out.println("실패");
		return;
	}
%>