

import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class SearchServlet
 */
@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SearchServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		if(session.getAttribute("id") == null) { //not logged in
			response.getWriter().print(DbHelper.errorJson("Not logged in").toString());
			return;
		}
 
		String searchstr = request.getParameter("search_string");
		String institute = request.getParameter("institute");
		String discipline = request.getParameter("discipline");
		String tag = request.getParameter("tag");
		String subject = request.getParameter("subject");
		String sort_parameter = request.getParameter("sort_parameter");
		String userid = (String)session.getAttribute("id");
		System.out.println(tag);
		Set<String> sortlist = new HashSet<>();
		sortlist.add("likes");
		sortlist.add("views");
		sortlist.add("year");

		if(searchstr==null)
		{
			searchstr="";
		}
		if(institute==null)
		{
			institute="";
		}
		if(discipline==null)
		{
			discipline="";
		}
		if(tag==null)
		{
			tag="";
		}
		if(subject==null)
		{
			subject="";
		}
		if(sort_parameter==null||!sortlist.contains(sort_parameter));
		{
			sort_parameter="year";
		}
		//searchstr = searchstr.toUpperCase();
		//tag = tag.toUpperCase();
		subject = subject.toUpperCase();
		institute = institute.toUpperCase();
		discipline = discipline.toUpperCase();
		List<DbHelper.ParamType> parr= new ArrayList<DbHelper.ParamType>();
		List<Object> oarr= new ArrayList<Object>();
		if(searchstr.equals(""))
		{
			searchstr = "%" + searchstr + "%";
		}
		parr.add(DbHelper.ParamType.STRING);oarr.add(userid);
		parr.add(DbHelper.ParamType.STRING);oarr.add(userid);
		parr.add(DbHelper.ParamType.STRING);oarr.add(searchstr);
		parr.add(DbHelper.ParamType.STRING);oarr.add("%"+subject+"%");
		parr.add(DbHelper.ParamType.STRING);oarr.add("%"+institute+"%");
		parr.add(DbHelper.ParamType.STRING);oarr.add("%"+discipline+"%");
		String query = "select distinct files.fid,filename,institute,discipline,"
				+ " subject,likes,views,year,uploaded_by, likes.user_id as liked, favourites.user_id as favo"
				+ " from files left join"
				+ " file_tags on files.fid = file_tags.fid left join "
				+ " likes on likes.fid=files.fid and likes.user_id=? "
				+ " left join favourites on favourites.fid = files.fid and favourites.user_id = ?"
				+ " where files.filename ";
		if(searchstr.equals("%%"))
		{
			query = query + " like ";
		}
		else
		{
			query = query + " % ";
		}
		query = query + " ?"
				+ " and UPPER(files.subject) like ?"
				+ " and UPPER(files.institute) like ? and UPPER(files.discipline) like ? and ( ";
		String tagarr[]=tag.split(",");
		int N = tagarr.length;
		if(tagarr[tagarr.length - 1] == "" && tagarr.length != 1) {
			N --;
		}
		for(int i=0;i<N;++i)
		{
			parr.add(DbHelper.ParamType.STRING);
			if(i>0)
			{
				query = query+" or ";
			}
			if(tagarr[i].equals(""))
			{
				oarr.add("%"+tagarr[i]+"%");
				query = query + " file_tags.tag like ? ";
			}
			else
			{
				oarr.add(tagarr[i]);
				query = query + " file_tags.tag % ? ";
			}
		}
		query = query+ ")";

		System.out.println(query);
		for(Object ob: oarr)
		{
			System.out.print(ob + " ");
		}
		System.out.println();
		String res = DbHelper.executeQueryJson(query,parr.toArray(new DbHelper.ParamType[parr.size()]),
				oarr.toArray(new Object[oarr.size()]));

		response.getWriter().printf(res);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
