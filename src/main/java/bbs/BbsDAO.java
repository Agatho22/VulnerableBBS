package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

//BbsDAO.java - 게시판 데이터베이스 접근 객체

 public class BbsDAO {
 private Connection conn;
 private Statement stmt;
 private ResultSet rs;

 // DB 연결
 public BbsDAO() {
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

 // 게시글 ID로 게시글 정보 조회
 public Bbs getBbs(int bbsID) {
     String SQL = "SELECT * FROM BBS WHERE bbsID = " + bbsID;
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         if (rs.next()) {
             Bbs bbs = new Bbs();
             bbs.setBbsID(rs.getInt("bbsID"));
             bbs.setBbsTitle(rs.getString("bbsTitle"));
             bbs.setUserID(rs.getString("userID"));
             bbs.setBbsDate(rs.getString("bbsDate"));
             bbs.setBbsContent(rs.getString("bbsContent"));
             bbs.setBbsAvailable(rs.getInt("bbsAvailable"));
             bbs.setIsSecret(rs.getString("isSecret"));
             return bbs;
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return null;
 }

 // 게시글 작성 (주의: SQL 인젝션 위험 있음)
 public int write(String bbsTitle, String userID, String bbsContent, String isSecret) {
     int nextID = getNext();
     String SQL = "INSERT INTO BBS (bbsID, bbsTitle, userID, bbsDate, bbsContent, bbsAvailable, isSecret) VALUES (" +
             nextID + ", '" + bbsTitle + "', '" + userID + "', '" + getDate() + "', '" +
             bbsContent + "', 1, '" + isSecret + "')";
     try {
         stmt = conn.createStatement();
         stmt.executeUpdate(SQL);
         return nextID;
     } catch (Exception e) {
         e.printStackTrace();
     }
     return -1;
 }

 // 게시글 삭제 (실제로는 표시 비활성화)
 public int delete(int bbsID) {
     String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = " + bbsID;
     try {
         stmt = conn.createStatement();
         return stmt.executeUpdate(SQL);
     } catch (Exception e) {
         e.printStackTrace();
     }
     return -1;
 }

 // 게시글 수정
 public int update(int bbsID, String bbsTitle, String bbsContent) {
     String SQL = "UPDATE BBS SET bbsTitle = '" + bbsTitle + "', bbsContent = '" + bbsContent +
             "' WHERE bbsID = " + bbsID;
     try {
         stmt = conn.createStatement();
         return stmt.executeUpdate(SQL);
     } catch (Exception e) {
         e.printStackTrace();
     }
     return -1;
 }

 // 해당 게시글에 첨부된 실제 파일명 조회
 public String getRealName(int bbsID) {
     String SQL = "SELECT fileRealName FROM FileBbsMapping WHERE bbsID = " + bbsID;
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         if (rs.next()) {
             return rs.getString("fileRealName");
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return "";
 }

 // 현재 서버 시간 조회
 public String getDate() {
     String SQL = "SELECT NOW()";
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         if (rs.next()) {
             return rs.getString(1);
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return "";
 }

 // 게시글 목록 조회 (페이징 처리)
 public ArrayList<Bbs> getList(int pageNumber) {
     ArrayList<Bbs> list = new ArrayList<>();
     int limit = getNext() - (pageNumber - 1) * 10;
     String SQL = "SELECT * FROM BBS WHERE bbsID < " + limit + " AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         while (rs.next()) {
             Bbs bbs = new Bbs();
             bbs.setBbsID(rs.getInt("bbsID"));
             bbs.setBbsTitle(rs.getString("bbsTitle"));
             bbs.setUserID(rs.getString("userID"));
             bbs.setBbsDate(rs.getString("bbsDate"));
             bbs.setBbsContent(rs.getString("bbsContent"));
             bbs.setBbsAvailable(rs.getInt("bbsAvailable"));
             bbs.setIsSecret(rs.getString("isSecret"));
             list.add(bbs);
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return list;
 }

 // 다음 게시글 번호 반환
 public int getNext() {
     String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         if (rs.next()) {
             return rs.getInt(1) + 1;
         }
         return 1; // 게시글이 하나도 없는 경우 1번부터 시작
     } catch (Exception e) {
         e.printStackTrace();
     }
     return -1;
 }

 // 다음 페이지 존재 여부 확인
 public boolean nextPage(int pageNumber) {
     int limit = getNext() - (pageNumber - 1) * 10;
     String SQL = "SELECT * FROM BBS WHERE bbsID < " + limit + " AND bbsAvailable = 1";
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         return rs.next();
     } catch (Exception e) {
         e.printStackTrace();
     }
     return false;
 }

 // 게시글 ID로 게시글 객체 조회
 public Bbs findBbs(int bbsID) {
     Bbs bbs = null;
     String SQL = "SELECT * FROM BBS WHERE bbsID = " + bbsID;
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         if (rs.next()) {
             bbs = new Bbs();
             bbs.setBbsID(rs.getInt("bbsID"));
             bbs.setBbsTitle(rs.getString("bbsTitle"));
             bbs.setUserID(rs.getString("userID"));
             bbs.setBbsContent(rs.getString("bbsContent"));
             bbs.setBbsAvailable(rs.getInt("bbsAvailable"));
             bbs.setIsSecret(rs.getString("isSecret"));
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return bbs;
 }

 // 특정 사용자 ID로 작성한 게시글 ID 목록 조회
 public ArrayList<Integer> findBbsID(String userID) {
     ArrayList<Integer> list = new ArrayList<>();
     String SQL = "SELECT bbsID FROM BBS WHERE userID = '" + userID + "'";
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         while (rs.next()) {
             list.add(rs.getInt("bbsID"));
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return list;
 }

 // 가장 큰 게시글 ID 반환 (최신 게시글 번호)
 public int getMaxBbsID() {
     int maxBbsID = 0;
     String SQL = "SELECT COALESCE(MAX(bbsID), 0) AS maxBbsID FROM BBS";
     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         if (rs.next()) {
             maxBbsID = rs.getInt("maxBbsID");
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return maxBbsID;
 }

 // 검색어로 게시글 제목 검색 (페이징 포함)
 public ArrayList<Bbs> searchList(String keyword, int pageNumber) {
     ArrayList<Bbs> list = new ArrayList<>();
     int limitStart = getNext() - (pageNumber - 1) * 10;

     // SQL Injection 대응: 작은 따옴표 이스케이프 처리
     //keyword = keyword.replace("'", "''");

     String SQL = "SELECT * FROM BBS WHERE bbsAvailable = 1 AND bbsTitle LIKE '%" + keyword +
                  "%' AND bbsID < " + limitStart + " ORDER BY bbsID DESC LIMIT 10";

     try {
         stmt = conn.createStatement();
         rs = stmt.executeQuery(SQL);
         while (rs.next()) {
             Bbs bbs = new Bbs();
             bbs.setBbsID(rs.getInt("bbsID"));
             bbs.setBbsTitle(rs.getString("bbsTitle"));
             bbs.setUserID(rs.getString("userID"));
             bbs.setBbsDate(rs.getString("bbsDate"));
             bbs.setBbsContent(rs.getString("bbsContent"));
             bbs.setBbsAvailable(rs.getInt("bbsAvailable"));
             bbs.setIsSecret(rs.getString("isSecret"));
             list.add(bbs);
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return list;
 }
}

