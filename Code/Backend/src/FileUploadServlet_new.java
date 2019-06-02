import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * Servlet implementation class FileUploadServlet
 */
@WebServlet("/FileUploadServlet_new")
public class FileUploadServlet_new extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String fid=null;
	private static String extension=null;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileUploadServlet_new() {
		super();
		// TODO Auto-generated constructor stub
	}
	private ServletFileUpload uploader = null;
	@Override
	public void init() throws ServletException{
		DiskFileItemFactory fileFactory = new DiskFileItemFactory();
		File filesDir = (File) getServletContext().getAttribute("FILES_DIR_FILE");
		fileFactory.setRepository(filesDir);
		this.uploader = new ServletFileUpload(fileFactory);
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fileName = request.getParameter("fileName");
		if(fileName == null || fileName.equals("")){
			throw new ServletException("File Name can't be null or empty");
		}

		File file = new File(request.getServletContext().getAttribute("FILES_DIR")+File.separator+fid+"."+extension);
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
		System.out.println("File downloaded at client successfully");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(!ServletFileUpload.isMultipartContent(request)){
			throw new ServletException("Content type is not multipart/form-data");
		}
		HttpSession session = request.getSession();
		if(session.getAttribute("id") == null) { //not logged in
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write("<html><head></head><body>");
		try {
			List<FileItem> fileItemsList = uploader.parseRequest(request);
			Iterator<FileItem> fileItemsIterator = fileItemsList.iterator();
			while(fileItemsIterator.hasNext()){
				FileItem fileItem = fileItemsIterator.next();
				if(!fileItem.getFieldName().equals("upload"))
				{
					continue;
				}
				while(true)
				{
					String CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
					Random ran = new Random();
					fid = "";
					while(fid.length()<15)
					{
						int ind = (int)(ran.nextFloat()*CHARS.length());
						fid = fid + CHARS.charAt(ind);
					}
					String exist = "select * from files where fid = ?";
					List<List<Object>> exi = DbHelper.executeQueryList(exist,
							new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
							new Object[] {fid});
					if(exi.isEmpty())
					{
						break;
					}
				}
				extension="";
				int lastdot = fileItem.getName().lastIndexOf(".");
				if(lastdot!=-1)
				{
					extension=fileItem.getName().substring(lastdot+1);
				}
				if(extension == "") {
					extension = "pdf";
				}
				System.out.println("FieldName="+fileItem.getFieldName());
				System.out.println("FileName="+fileItem.getName());
				System.out.println("ContentType="+fileItem.getContentType());
				System.out.println("Size in bytes="+fileItem.getSize());

				File file = new File(request.getServletContext().getAttribute("FILES_DIR")+File.separator+fid+"."+extension);
				System.out.println("Absolute Path at server="+file.getAbsolutePath());
				fileItem.write(file);
				out.write("File "+fileItem.getName()+ " uploaded successfully.");
				out.write("<br>");
				out.write("<a href=\"FileUploadServlet?fileName="+fileItem.getName()+"\">Download "+fileItem.getName()+"</a>");

				int year=Integer.parseInt(request.getParameter("year"));
				String uploaded_by=session.getAttribute("id").toString();
				String institute=request.getParameter("institute");
				String discipline=request.getParameter("discipline");
				String subject=request.getParameter("subject");
				String tags=request.getParameter("tags");
				String fileName=request.getParameter("file_name");
				String updatecount = "insert into files values (?,?,?,?,0,0,?,?,?,?)";
				String upd = DbHelper.executeUpdateJson(updatecount,
						new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING
				},
						new Object[] {fid,fileName,year,uploaded_by,extension,institute,discipline,subject});
				response.getWriter().printf(upd);
				String tagarr[]=tags.split(",");
				for(int i=0;i<tagarr.length;++i)
				{
					String updatetag = "insert into tags values (?)";
					String tagres = DbHelper.executeUpdateJson(updatetag,
							new DbHelper.ParamType[] {DbHelper.ParamType.STRING
					},
							new Object[] {tagarr[i]});
					response.getWriter().printf(tagres);
					
					String updatefiletags = "insert into file_tags values (?,?)";
					String ftres = DbHelper.executeUpdateJson(updatefiletags,
							new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
									DbHelper.ParamType.STRING
					},
							new Object[] {fid,tagarr[i]});
					response.getWriter().printf(ftres);	
				}

			}
		} catch (FileUploadException e) {
			out.write("Exception in uploading file.");
		} catch (Exception e) {
			out.write("Exception in uploading file.");
		}
		out.write("</body></html>");
	}

}
