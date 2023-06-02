package vo;

public class ProductImg {
	private int productNo;
	private String productOriFilename;
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
	public String getProductOriFilename() {
		return productOriFilename;
	}
	public void setProductOriFilename(String productORiFilename) {
		this.productOriFilename = productORiFilename;
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
