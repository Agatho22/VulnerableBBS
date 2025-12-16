package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private Statement st;
	private ResultSet rs;

	// 생성자
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			String dbID = "root"; 
			String dbPassword = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword); 
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 로그인 메소드
	public int login(String userID, String userPassword) {
		String SQL = "SELECT * FROM USER WHERE userID = '" + userID + "' AND userpassword = '" + userPassword + "'";
		//String SQL = "SELECT " + userPassword + " FROM USER WHERE userID = " + userID;
		try {
			st = conn.createStatement();
			//pstmt.setString(1, userID);
			ResultSet rs = st.executeQuery(SQL);
			if (rs.next()) {
				return 1; // 로그인 성공
			} else {
				return 0; // 비밀번호 불일치
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}

	// 회원가입 메소드
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserEmail());
			pstmt.setString(5, user.getAdmin());
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	// 관리자 확인 메소드
	public int adminCheck(String userID) {
		String SQL = "SELECT admin FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if ("admin".equals(rs.getString("admin"))) {
                    return 1; // 관리자
                }
            }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0; // 일반 회원
	}

	// 아이디 중복 확인 메소드
	public int userIdCheck(String userID) {
		String SQL = "SELECT userID FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return -1; // 아이디 존재
			} else {
				return 1; // 아이디 없음
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	// 회원 정보 수정 메소드
	public int userUpdate(User user, String userID) {
		String SQL = "UPDATE USER SET userID = ?, userPassword = ?, userName = ?, userEmail = ?, admin = ? WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserEmail());
			pstmt.setString(5, user.getAdmin());
			pstmt.setString(6, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	// 회원 삭제 메소드
	public boolean deleteUser(String userID) {
		String SQL = "DELETE FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			int result = pstmt.executeUpdate();
			return result > 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// 전체 회원 리스트 반환
	public ArrayList<User> getUserList() {
		ArrayList<User> userList = new ArrayList<>();
		String SQL = "SELECT * FROM USER";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				User user = new User();
				user.setUserID(rs.getString("userID"));
				user.setUserPassword(rs.getString("userPassword"));
				user.setUserName(rs.getString("userName"));
				user.setUserEmail(rs.getString("userEmail"));
				user.setAdmin(rs.getString("admin"));
				userList.add(user);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return userList;
	}

	// 현재 비밀번호가 일치하는지 확인
	public boolean validatePassword(String userID, String password) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString("userPassword").equals(password);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// 비밀번호만 변경하는 메소드
	public int updatePassword(String userID, String newPassword) {
		String SQL = "UPDATE USER SET userPassword = ? WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, newPassword);
			pstmt.setString(2, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}
