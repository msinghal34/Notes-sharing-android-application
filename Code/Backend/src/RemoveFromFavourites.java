

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class RemoveFromFavourites
 */
@WebServlet("/RemoveFromFavourites")
public class RemoveFromFavourites extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RemoveFromFavourites() {
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

		String exist = "select * from favourites where user_id = ? and fid = ?";
		List<List<Object>> exi = DbHelper.executeQueryList(exist,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING},
				new Object[] {userid,fid});
		if(exi.isEmpty())
		{
			response.getWriter().
			print(DbHelper.errorJson("This user doesn't have this filein favourites in the first place").toString());
			return;
		}

		String query = "delete from favourites where user_id = ? and fid = ?";
		String res = DbHelper.executeUpdateJson(query,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING},
				new Object[] {userid,fid});
		
		response.getWriter().printf(res);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
