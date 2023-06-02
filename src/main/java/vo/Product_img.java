package vo;

public class Product_img {
	private int productNo;
	private String productORiFilename;
	private String productSaveFilename;
	private String productFiletype;
	private String createdate;
	private String updatedate;
	
	public int getProductNo() {
		return productNo;
	}
	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}
	public String getProductORiFilename() {
		return productORiFilename;
	}
	public void setProductORiFilename(String productORiFilename) {
		this.productORiFilename = productORiFilename;
	}
	public String getProductSaveFilename() {
		return productSaveFilename;
	}
	public void setProductSaveFilename(String productSaveFilename) {
		this.productSaveFilename = productSaveFilename;
	}
	public String getProductFiletype() {
		return productFiletype;
	}
	public void setProductFiletype(String productFiletype) {
		this.productFiletype = productFiletype;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	public String getUpdatedate() {
		return updatedate;
	}
	public void setUpdatedate(String updatedate) {
		this.updatedate = updatedate;
	}
}
