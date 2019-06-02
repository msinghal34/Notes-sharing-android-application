

import java.io.IOException;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class CreateNewUser
 */
@WebServlet("/CreateNewUser")
public class CreateNewUser extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateNewUser() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/*
		HttpSession session = request.getSession();
		if(session.getAttribute("id") == null) { //not logged in
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}
		*/
		HttpSession session = request.getSession();
		String name = request.getParameter("name");
		String emailid = request.getParameter("email_id");
		int reputation = 0;
		String userid = request.getParameter("user_id");
		String password = request.getParameter("password");
		
		String CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
		Random ran = new Random();
		String salt = "";
		while(salt.length()<20)
		{
			int ind = (int)(ran.nextFloat()*CHARS.length());
			salt = salt + CHARS.charAt(ind);
		}
		String pconcat = password + salt;
		int hash = pconcat.hashCode();
		
		String exist = "select * from users_info where user_id = ?";
		List<List<Object>> exi = DbHelper.executeQueryList(exist,
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING},
				new Object[] {userid});
		if(!exi.isEmpty())
		{
			System.out.println("Userid exists");
			response.getWriter().
			print(DbHelper.errorJson("User ID already exists.").toString());
			return;
		}
		String query = "insert into users_info values (?,?,?,?,?,?)";
		String res = DbHelper.executeUpdateJson(query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING, 
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.INT,
						DbHelper.ParamType.STRING,
						DbHelper.ParamType.INT}, 
				new Object[] {userid,name,emailid,reputation,salt,hash});//initialise reputation to 0
		session.setAttribute("id", userid );
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
