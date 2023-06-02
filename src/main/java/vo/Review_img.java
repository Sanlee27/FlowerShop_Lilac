package vo;

public class Review_img {
	private int orderNo;
	private String reviewORiFilename;
	private String reviewSaveFilename;
	private String reviewFiletype;
	private String createdate;
	private String updatedate;
	
	public int getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}
	public String getReviewORiFilename() {
		return reviewORiFilename;
	}
	public void setReviewORiFilename(String reviewORiFilename) {
		this.reviewORiFilename = reviewORiFilename;
	}
	public String getReviewSaveFilename() {
		return reviewSaveFilename;
	}
	public void setReviewSaveFilename(String reviewSaveFilename) {
		this.reviewSaveFilename = reviewSaveFilename;
	}
	public String getReviewFiletype() {
		return reviewFiletype;
	}
	public void setReviewFiletype(String reviewFiletype) {
		this.reviewFiletype = reviewFiletype;
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
