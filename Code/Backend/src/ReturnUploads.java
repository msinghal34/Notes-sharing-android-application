

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ReturnUploads
 */
@WebServlet("/ReturnUploads")
public class ReturnUploads extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ReturnUploads() {
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
		String query = "select files.fid,filename,year,uploaded_by,likes,views,extension,institute,"
				+ " discipline,subject,folder, likes.user_id as liked, favourites.user_id as favo"
				+ " from files left join likes on"
				+ " likes.fid = files.fid and likes.user_id = ? "
				+ " left join favourites on favourites.fid = files.fid and favourites.user_id = ?"
				+ " where uploaded_by = ? order by filename";
		String js = DbHelper.executeQueryJson(query,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING},
				new Object[] {userid,userid,userid});
		response.getWriter().printf(js);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
