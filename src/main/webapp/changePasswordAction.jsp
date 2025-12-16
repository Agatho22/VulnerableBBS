<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*, user.UserDAO" %>
<%
    // 요청 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    // 로그인된 사용자 확인
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    } else {
        // 로그인되지 않은 경우 로그인 페이지로 리디렉션
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인이 필요합니다.')");
        script.println("location.href = 'login.jsp';");
        script.println("</script>");
        return;
    }

    // 사용자로부터 전달받은 비밀번호 값들
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

/*     // 입력값 유효성 검사
    if (currentPassword == null || newPassword == null || confirmPassword == null ||
        currentPassword.equals("") || newPassword.equals("") || confirmPassword.equals("")) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('모든 항목을 입력하세요.');");
        script.println("history.back();");
        script.println("</script>");
        return;
    } */

    // 새 비밀번호 확인란이 일치하지 않을 경우
    if (!newPassword.equals(confirmPassword)) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('새 비밀번호가 일치하지 않습니다.');");
        script.println("history.back();");
        script.println("</script>");
        return;
    }

    // DAO 인스턴스 생성
    UserDAO userDAO = new UserDAO();

/*     // 현재 비밀번호 검증
    if (!userDAO.validatePassword(userID, currentPassword)) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('현재 비밀번호가 일치하지 않습니다.');");
        script.println("history.back();");
        script.println("</script>");
        return;
    } */

    // 비밀번호 변경 시도
    int result = userDAO.updatePassword(userID, newPassword);
    if (result == 1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요.');");
        script.println("location.href = 'logoutAction.jsp';");
        script.println("</script>");
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('비밀번호 변경에 실패했습니다.');");
        script.println("history.back();");
        script.println("</script>");
    }
%>
