<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String userID = request.getParameter("userID");
    String result = "available"; // 기본값: 사용 가능

    if (userID == null || userID.trim().equals("")) {
        result = "invalid"; // 아이디가 비어있거나 유효하지 않음
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 데이터베이스 연결
			 String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			 String dbID = "root"; 
			 String dbPassword = "1234";
            


            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

            // 아이디 중복 확인 쿼리
            String sql = "SELECT userID FROM users WHERE userID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                result = "unavailable"; // 아이디가 이미 존재
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) { }
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { }
            if (conn != null) try { conn.close(); } catch (Exception e) { }
        }
    }

    response.setContentType("text/plain");
    response.getWriter().write(result); // 결과 반환
%>