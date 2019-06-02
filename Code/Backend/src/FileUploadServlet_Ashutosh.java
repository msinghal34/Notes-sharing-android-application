import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.time.Year;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.plaf.metal.MetalIconFactory.FolderIcon16;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * Servlet implementation class FileUploadServlet
 */
@WebServlet("/FileUploadServlet_Ashutosh")
public class FileUploadServlet_Ashutosh extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String fid=null;
	private static String extension=null;
	private static String folder = null;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileUploadServlet_Ashutosh() {
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

		File file = new File(request.getServletContext().getAttribute("FILES_DIR")+folder+File.separator+fid+"."+extension);
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
		System.out.println("Passed 1");
		if(!ServletFileUpload.isMultipartContent(request)){
			throw new ServletException("Content type is not multipart/form-data");
		}
		HttpSession session = request.getSession();
		System.out.println(session.getAttribute("id"));
		if(session.getAttribute("id") == null) { //not logged in
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}

		response.setContentType("text/html");
		System.out.println("Passed 2");

		PrintWriter out = response.getWriter();
		out.write("<html><head></head><body>");
		try {
			List<FileItem> fileItemsList = uploader.parseRequest(request);
			System.out.println("Passed 3.25");
			Map<String, String> parameters = new HashMap<>();

			Iterator<FileItem> fileItemsIterator = fileItemsList.iterator();
			System.out.println(fileItemsList.size());
			while(fileItemsIterator.hasNext()){  
				FileItem fileItem = fileItemsIterator.next();
				System.out.println(fileItem.getFieldName());
				if(!fileItem.getFieldName().equals("upload"))
				{
					parameters.put(fileItem.getFieldName(), fileItem.getString());
					continue;
				}
				String institute=parameters.get("institute");
				String userid = (String)session.getAttribute("id");

				String query1 = "select institute from institutes where institute = ?";
				List<List<Object>> instjs = DbHelper.executeQueryList(query1,
						new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
						new Object[] {institute});
				String inst = instjs.isEmpty()?null:(String)instjs.get(0).get(0);
				if(inst==null)
				{
					String query = "select reputation from users_info where user_id = ?";
					List<List<Object>> repjs = DbHelper.executeQueryList(query,
							new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
							new Object[] {userid});
					int rep = repjs.isEmpty()?-1:Integer.valueOf(DbHelper.toint(repjs.get(0).get(0)));

					if(rep>=7)
					{
						String add_inst = "insert into institutes values (?)";
						String updjs = DbHelper.executeUpdateJson(add_inst,
								new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
								new Object[] {institute});
					}
					else
					{
						response.getWriter().print
						(DbHelper.errorJson("Not enough reputation to add institute").toString());
						return;
					}
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
				System.out.println("Passed 3.5");

				extension="";
				int lastdot = fileItem.getName().lastIndexOf(".");
				if(lastdot!=-1)
				{
					extension=fileItem.getName().substring(lastdot+1);
				}
				Random ran = new Random();
				int find=(int)(ran.nextFloat()*10);
				String ff = Character.toString((char)(48+find));
				folder = File.separator+ff;

				System.out.println("FieldName="+parameters.get("file_name"));
				System.out.println("FileName="+fileItem.getName());
				System.out.println("ContentType="+fileItem.getContentType());
				System.out.println("Size in bytes="+fileItem.getSize());
				System.out.println("folder = "+folder);
				File file = new File(request.getServletContext().getAttribute("FILES_DIR")+folder+File.separator+fid+"."+extension);
				String yr=parameters.get("year");
				int year=-1;
				if(yr!=null)
					year=Integer.parseInt(yr);
				int fold = find;
				String uploaded_by= (String) session.getAttribute("id");

				String discipline=parameters.get("discipline");
				String subject=parameters.get("subject");
				String tags=parameters.get("tags");
				System.out.println("Passed 4");
				String updatecount = "insert into files values (?,?,?,?,0,0,?,?,?,?,?)";
				String upd = DbHelper.executeUpdateJson(updatecount,
						new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.INT,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.STRING,
								DbHelper.ParamType.INT
				},
						new Object[] {fid,parameters.get("file_name"),year,uploaded_by,extension,institute,discipline,subject,fold});
				response.getWriter().printf(upd);

				if(tags!=null)
				{
					String tagarr[]=tags.split(",");
					for(int i=0;i<tagarr.length;++i)
					{
						String exist = "select * from tags where tag = ?";
						List<List<Object>> exi = DbHelper.executeQueryList(exist,
								new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
								new Object[] {tagarr[i]});
						if(exi.isEmpty())
						{	

							String updatetag = "insert into tags values (?)";
							String tagres = DbHelper.executeUpdateJson(updatetag,
									new DbHelper.ParamType[] {DbHelper.ParamType.STRING
							},
									new Object[] {tagarr[i]});
							response.getWriter().printf(tagres);
						}

						String updatefiletags = "insert into file_tags values (?,?)";
						String ftres = DbHelper.executeUpdateJson(updatefiletags,
								new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
										DbHelper.ParamType.STRING
						},
								new Object[] {fid,tagarr[i]});
						response.getWriter().printf(ftres);	
					}
				}
				System.out.println("Absolute Path at server="+file.getAbsolutePath());
				fileItem.write(file);

			}
		} catch (FileUploadException e) {
			out.write("Exception in uploading file. " + e);
			response.getWriter().print(DbHelper.errorJson("Exception in File Upload").toString());
			System.out.println("error");
			return;
		} catch (Exception e) {
			System.out.println("error");
			response.getWriter().print(DbHelper.errorJson("Exception in File Upload").toString());
			out.write("Exception in uploading. "+e);
			return;
		}
		out.write("</body></html>");  
	}

}
