

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class DownloadServlet
 */
@WebServlet("/DownloadServlet")
public class DownloadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DownloadServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		if(session.getAttribute("id") == null) { //not logged in
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}
		
		String userid = (String)session.getAttribute("id");
		String fid = (String)request.getParameter("fid");
		
		
		String qfile="select filename,extension,folder from files where fid = ?";
		List<List<Object>> saltjs = DbHelper.executeQueryList(qfile,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
				new Object[] {fid});
		
		String fname = saltjs.isEmpty()?null:(String)saltjs.get(0).get(0);
		String extension = saltjs.isEmpty()?null:(String)saltjs.get(0).get(1);
		int fold = saltjs.isEmpty()?-1:Integer.valueOf(DbHelper.toint(saltjs.get(0).get(2)));
		
		if(fname != null && fold!=-1)
		{
//			response.getWriter().print(DbHelper.okJson().toString());
		}
		else {
			response.getWriter().print(DbHelper.errorJson("File not found").toString());
			return;
		}
		String ff = Character.toString((char)(48+fold));
		String folder = File.separator+ff;
		
		String fileName = fname;
		if(fileName == null || fileName.equals("")){
			throw new ServletException("File Name can't be null or empty");
		}
		File file=null;
		if(extension!=null)
		{
			file = new File(request.getServletContext().getAttribute("FILES_DIR")+folder+File.separator+fid+"."+extension);
		}
		else
		{
			file = new File(request.getServletContext().getAttribute("FILES_DIR")+folder+File.separator+fid);
		}
		System.out.println(file.getAbsolutePath());
		if(!file.exists()){
			throw new ServletException("File doesn't exists on server.");
		}
		System.out.println("File location on server::"+file.getAbsolutePath());
		ServletContext ctx = getServletContext();
		InputStream fis = new FileInputStream(file);
		String mimeType = ctx.getMimeType(file.getAbsolutePath());
		response.setContentType(mimeType != null? mimeType:"application/octet-stream");
		response.setContentLength((int) file.length());
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

		ServletOutputStream os = response.getOutputStream();
		byte[] bufferData = new byte[1024];
		int read=0;
		while((read = fis.read(bufferData))!= -1){
			os.write(bufferData, 0, read);
		}
		os.flush();
		os.close();
		fis.close();
		String history_query = "insert into history values (?,?,CURRENT_TIMESTAMP)";
		System.out.println(userid +" " + fid);
		String res = DbHelper.executeUpdateJson(history_query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING
						}, 
				new Object[] {userid,fid});
		
		String view_query = "update files set views = views + 1 where fid = ?";

		String res2 = DbHelper.executeUpdateJson(view_query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING						
						},
				new Object[] {fid});
		
		System.out.println("File downloaded at client successfully");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
