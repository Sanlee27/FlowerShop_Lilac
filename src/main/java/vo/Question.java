package vo;

public class Question {
	private int qNo;
	private int productNo;
	private String id;
	private String qCategory;
	private String qAnswer;
	private String qTitle;
	private String qContent;
	private String createdate;
	private String updatedate;
	public int getqNo() {
		return qNo;
	}
	public void setqNo(int qNo) {
		this.qNo = qNo;
	}
	public int getProductNo() {
		return productNo;
	}
	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getqCategory() {
		return qCategory;
	}
	public void setqCategory(String qCategory) {
		this.qCategory = qCategory;
	}
	public String getqAnswer() {
		return qAnswer;
	}
	public void setqAnswer(String qAnswer) {
		this.qAnswer = qAnswer;
	}
	public String getqTitle() {
		return qTitle;
	}
	public void setqTitle(String qTitle) {
		this.qTitle = qTitle;
	}
	public String getqContent() {
		return qContent;
	}
	public void setqContent(String qContent) {
		this.qContent = qContent;
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
