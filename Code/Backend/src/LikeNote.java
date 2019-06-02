import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LikeNote")
public class LikeNote extends HttpServlet {
	private static final long serialVersionUID = 1L;
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LikeNote() {
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
		String userid = request.getParameter("user_id");
		String fid = request.getParameter("fid");

		//part 1 - insert into likes table
		String query_1 = "insert into likes values (? ?)";
		String json_1 = DbHelper.executeUpdateJson(query_1, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING,  DbHelper.ParamType.STRING},
				new String[] {userid, fid});
		response.getWriter().printf(json_1);

		//part 2 - update value in files table
		String query_2 = "update files set likes = likes + 1 where fid = ?";
		String json_2 = DbHelper.executeQueryJson(query_2,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
				new Object[] {fid});
		response.getWriter().printf(json_2);
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}