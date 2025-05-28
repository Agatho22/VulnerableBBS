package file;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.sql.Connection;

public class FileDAO {

    private Connection conn;

    // 생성자
    public FileDAO() {
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

    // bbsID가 BBS 테이블에 존재하는지 확인하는 메서드
    private boolean isBbsIDExists(int bbsID) {
        String SQL = "SELECT COUNT(*) FROM BBS WHERE bbsID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, bbsID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 파일 업로드
    public int upload(String fileName, String fileRealName, int bbsID) {
        if (!isBbsIDExists(bbsID)) {
            System.out.println("bbsID " + bbsID + " does not exist in BBS table.");
            return -1;
        }
        
        String SQL = "INSERT INTO FileBbsMapping (fileName, fileRealName, bbsID) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, fileName);
            pstmt.setString(2, fileRealName);
            pstmt.setInt(3, bbsID);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int update(String fileName, String fileRealName, int bbsID) {
        String SQL = "UPDATE FILE SET fileName = ?, fileRealName = ? WHERE bbsID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, fileName);
            pstmt.setString(2, fileRealName);
            pstmt.setInt(3, bbsID);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public ArrayList<File> getList(int bbsID) {
        String SQL = "SELECT fileName, fileRealName FROM FILE WHERE bbsID = ?";
        ArrayList<File> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, bbsID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                File file = new File(rs.getString("fileName"), rs.getString("fileRealName"));
                list.add(file);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<String> getFileBbsID(int bbsID) {
        ArrayList<String> fileList = new ArrayList<>();
        String query = "SELECT fileRealName FROM FILE WHERE bbsID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, bbsID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                fileList.add(rs.getString("fileRealName"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fileList;
    }
}