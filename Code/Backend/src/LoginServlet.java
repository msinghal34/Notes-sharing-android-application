
import java.util.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		//doPost(request, response);
		HttpSession session = request.getSession();
		if(session.getAttribute("id") != null) { // logged in
			response.getWriter().print(DbHelper.okJson().toString());
		}
		else {
			response.getWriter().print(DbHelper.errorJson("Not logged in"));
		}
		return;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String userid = request.getParameter("user_id");
		String password = request.getParameter("password");
		
		String qsalt="select salt, hash from users_info where user_id = ?";
		List<List<Object>> saltjs = DbHelper.executeQueryList(qsalt,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
				new Object[] {userid});
		
		String salt = saltjs.isEmpty()?null:(String)saltjs.get(0).get(0);
		int hash = saltjs.isEmpty()?-1:Integer.valueOf(DbHelper.toint(saltjs.get(0).get(1)));
		String pconcat = password + salt;
		//System.out.println(pconcat.hashCode());
		if(salt != null && pconcat.hashCode()==hash)
		{
			session.setAttribute("id", userid);
			response.getWriter().print(DbHelper.okJson().toString());
		}
		else {
			response.getWriter().print(DbHelper.errorJson("Username/password incorrect").toString());
		}
	}
}
