package dao;

import java.sql.*;
import java.util.*;
import util.DBUtil;
import vo.*;

public class AddressDao {
	//배송지이력 리스트 
	public ArrayList<Address> selectHistoryAddress(String id) throws Exception {
		//유효성검사
		if(id == null) {
			System.out.println("id값 확인");
			return null;
		}
				
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement addressStmt = conn.prepareStatement(
				"SELECT address_no addressNo, id, address_lastdate addressLastdate, address FROM address WHERE id = ? ORDER BY address_lastdate DESC"
		);
		addressStmt.setString(1, id);
		
		ResultSet addressRs= addressStmt.executeQuery();
		
		//ArrayList
		ArrayList<Address> addressList = new ArrayList<>();
		while(addressRs.next()) {
			Address a = new Address();
			a.setAddressNo(addressRs.getInt("addressNo"));
			a.setId(addressRs.getString("id"));
			a.setAddressLastdate(addressRs.getString("addressLastdate"));
			a.setAddress(addressRs.getString("address"));
			addressList.add(a);
		}
		return addressList;
	}
	
	//address_no(주소번호)가 없으면 추가, 번호가 있을때는 adrress_lastdate(마지막일정) 업데이트
	public int updateAddress(Address address) throws Exception {
		//유효성검사
		if(address == null || address.getId() ==null || address.getAddress() == null) {
			System.out.println("address클래스, id, 주소값 확인");
			return 0;
		}
		
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		if(address.getAddressNo() == 0) {
			PreparedStatement addressStmt = conn.prepareStatement(
					"INSERT INTO address(id, address_lastdate, address, createdate, updatedate) VALUES(?, now(), ?, now(), now())"
					);
			addressStmt.setString(1, address.getId());
			addressStmt.setString(2, address.getAddress());
			
			row = addressStmt.executeUpdate();
			
			return row;
		} 
		
		PreparedStatement addressUpStmt = conn.prepareStatement(
				"UPDATE address SET address_lastdate = now() WHERE address_no = ?"
				);
		addressUpStmt.setInt(1, address.getAddressNo());
		row = addressUpStmt.executeUpdate();
		
		return row;
	}
	
	//배송지이력 삭제
	public int deleteAddress(int addressNo) throws Exception {
		int row = 0;
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		PreparedStatement addressdelStmt = conn.prepareStatement(
					"DELETE FROM address WHERE address_no = ?"
			);
		addressdelStmt.setInt(1, addressNo);
			
		row = addressdelStmt.executeUpdate();
		
		return row;
	} 
}
