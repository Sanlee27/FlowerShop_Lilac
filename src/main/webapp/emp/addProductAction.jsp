<%@ page language = "java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*"%>
<%@ page import = "com.oreilly.servlet.MultipartRequest"%>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");

	//변수
	String msg = "";
	String dir = request.getServletContext().getRealPath("/product");
		System.out.println(dir);
	
	int max = 10 * 1024 * 1024; // 10mb
	// request객체를 MultipartRequest의 API를 사용할 수 있도록 랩핑
 	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8");	
	
	// 
	System.out.println(mRequest.getContentType("productImg"));
	
	//유효성검사
			if(mRequest.getParameter("productName") == null
				||mRequest.getParameter("productInfo") == null
				||mRequest.getParameter("productPrice") == null
				||mRequest.getParameter("productStock") == null
				||mRequest.getParameter("productName").equals("")
				||mRequest.getParameter("productInfo").equals("")
				||mRequest.getParameter("productPrice").equals("")
				||mRequest.getParameter("productStock").equals("")){
			
					System.out.println(mRequest.getParameter("productName"));
					System.out.println(mRequest.getParameter("productInfo"));
					System.out.println(mRequest.getParameter("productPrice"));
					System.out.println(mRequest.getParameter("productStock"));
					System.out.println("productName, productInfo, productPrice, productStock 값 필요");
				msg = URLEncoder.encode("모든 내용을 입력해주세요.","utf-8"); 
				response.sendRedirect(request.getContextPath() + "/emp/addProduct.jsp?msg=" + msg);
				return;
			}
	
	//업로드 된 컨텐츠파일이 PNG, JPG, JEPG파일이 아니면 돌아가도록
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
		msg = URLEncoder.encode("PNG, JPG, JEPG파일로 업로드해주세요.","utf-8"); 
		response.sendRedirect(request.getContextPath()+"/emp/addProduct.jsp?msg=" + msg); //주소입력해야함
		return;
	}
	
	//DAO 받아오기
	ProductDao productdao = new ProductDao();

	//변수
	String productName = mRequest.getParameter("productName");
	int productCnt = productdao.productCnt(productName);
	
	//상품명 중복확인 0일때만 가능
	if(productCnt != 0){
		System.out.println("상품명 변경 필요");
		msg = URLEncoder.encode("해당 상품명은 이미 존재합니다.","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/addProduct.jsp?msg=" + msg);
		return;
	}
	
	//1) input type = "text" 값변환 API --> product테이블에 저장
	//변수
	String categoryName = mRequest.getParameter("categoryName");
	int productPrice = Integer.parseInt(mRequest.getParameter("productPrice"));
	String productStatus = mRequest.getParameter("productStatus");
	String productInfo = mRequest.getParameter("productInfo");
	int productStock = Integer.parseInt(mRequest.getParameter("productStock"));
	
	HashMap<String, Object> map = new HashMap<>();
		Product product = new Product();
		product.setCategoryName(categoryName);
		product.setProductName(productName);
		product.setProductPrice(productPrice);
		product.setProductStatus(productStatus);
		product.setProductInfo(productInfo);
		product.setProductStock(productStock);
			System.out.println(categoryName + "<-categoryName");
			System.out.println(productName + "<-productName");
			System.out.println(productPrice + "<-productPrice");
			System.out.println(productStatus + "<-productStatus");
			System.out.println(productInfo + "<-productInfo");
			System.out.println(productStock + "<-productStock");
		map.put("product", product);
	
	//2) input type="file" 값(파일 정보) 반환 API(원본파일이름, 저장된파일이름, 컨텐츠타입) ->product_img테이블 저장
	//변수
	String oriFilename = mRequest.getOriginalFileName("productImg");
	String saveFilename = mRequest.getOriginalFileName("productImg");
	String type = mRequest.getContentType("productImg");
	
		ProductImg productimg = new ProductImg();
		productimg.setProductOriFilename(oriFilename);
		productimg.setProductSaveFilename(saveFilename);
		productimg.setProductFiletype(type);
			System.out.println(oriFilename + "<-oriFilename");
			System.out.println(oriFilename + "<-saveFilename");
			System.out.println(oriFilename + "<-type");
		map.put("productImg", productimg);
	
	//row에 값 넣기
	int row = productdao.insertProduct(map);
	
	if(row == 1) {
		System.out.println("성공");
		msg = URLEncoder.encode("상품이 추가되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath() + "/emp/productList.jsp?msg=" + msg);
	} else {
		response.sendRedirect(request.getContextPath() + "/emp/addProduct.jsp");
		System.out.println("실패");
		return;
	}
	
%>