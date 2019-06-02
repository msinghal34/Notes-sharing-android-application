

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class AddToFavourites
 */
@WebServlet("/SwitchFavouritesServlet")
public class SwitchFavouritesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SwitchFavouritesServlet() {
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
		String fid = request.getParameter("fid");

		String exist = "select * from favourites where user_id = ? and fid = ?";
		List<List<Object>> exi = DbHelper.executeQueryList(exist,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING},
				new Object[] {userid,fid});
		String whoUploaded = "select uploaded_by from files where fid = ?";
		List<List<Object>> owjs = DbHelper.executeQueryList(whoUploaded,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
				new Object[] {fid});
		String owner = owjs.isEmpty()?null:(String)owjs.get(0).get(0);

		if(!exi.isEmpty())
		{
			String rem = "delete from favourites where user_id = ? and fid = ?";
			String js = DbHelper.executeUpdateJson(rem,
					new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
							DbHelper.ParamType.STRING},
					new Object[] {userid,fid});
			response.getWriter().printf(js);
			if(!userid.equals(owner))
			{
				String updrep = "update users_info set reputation = reputation - 1 where user_id =?";
				String updjs = DbHelper.executeUpdateJson(updrep,
						new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
						new Object[] {owner});
//				response.getWriter().printf(updjs);
			}
			return;
		}

		String query = "insert into favourites "
				+ " values (?,?)";
		String js = DbHelper.executeUpdateJson(query,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING},
				new Object[] {userid,fid});
		response.getWriter().printf(js);

		if(!userid.equals(owner))
		{
			String updrep = "update users_info set reputation = reputation + 1 where user_id =?";
			String updjs = DbHelper.executeUpdateJson(updrep,
					new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
					new Object[] {owner});
//			response.getWriter().printf(updjs);
		}

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
