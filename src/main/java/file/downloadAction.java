package file;

import java.io.File;

import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/downloadAction") // 파일 다운로드 처리
public class downloadAction extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("file");
        int bbsID = 0;

        if (request.getParameter("bbsID") != null) {
                bbsID = Integer.parseInt(request.getParameter("bbsID"));
        }

        // 파일 경로 결정
        String directory = getServletContext().getRealPath("/upload/");
        File file = new File(directory + "/" + fileName);

        // MIME 타입 설정
        String mimeType = getServletContext().getMimeType(file.toString());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        
        // 파일 이름 설정
        String downloadName = null;
        if (request.getHeader("user-agent").indexOf("MSIE") == -1) {
        	downloadName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
        } else {
        	downloadName = new String(fileName.getBytes("EUC-KR"), "ISO-8859-1");
        }
        response.setHeader("Content-Disposition", "attachment;filename=\""
        	+ downloadName + "\";");
        
        // 파일 다운로드 시 한글 파일 이름 처리
        String headerValue = "attachment;filename=\"" + java.net.URLEncoder.encode(fileName, "UTF-8") + "\"";
        response.setHeader("Content-Disposition", headerValue);

        byte b[] = new byte[1024];
        int data = 0;
        
        // 파일 전송 작업 
        FileInputStream fileInputStream = new FileInputStream(file);
        ServletOutputStream servletOutputStream = response.getOutputStream();
        while ((data = (fileInputStream.read(b, 0, b.length)))!= -1) {
        	servletOutputStream.write(b, 0, data);
        }
        
        servletOutputStream.flush();
        servletOutputStream.close();
        fileInputStream.close();

    }
}
