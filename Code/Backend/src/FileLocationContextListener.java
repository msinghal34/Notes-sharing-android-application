import java.io.File;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * Application Lifecycle Listener implementation class FileLocationContextListener
 *
 */
@WebListener
public class FileLocationContextListener implements ServletContextListener {

	/**
	 * Default constructor. 
	 */
	public FileLocationContextListener() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see ServletContextListener#contextDestroyed(ServletContextEvent)
	 */
	public void contextDestroyed(ServletContextEvent sce)  { 
		// TODO Auto-generated method stub
	}

	/**
	 * @see ServletContextListener#contextInitialized(ServletContextEvent)
	 */
	public void contextInitialized(ServletContextEvent servletContextEvent)  { 
		// TODO Auto-generated method stub
		String rootPath = "/Users/Sriram/eclipse-workspace/Note_sharing/WebContent/";//"user.dir"
//		String rootPath="/home/ashutosh/WebContent/";
		ServletContext ctx = servletContextEvent.getServletContext();
		File file = new File(rootPath);
		char ind='0';
		for(int i=0;i<10;++i) 
		{
			File file1 = new File(rootPath+ind+"/");
			if(!file1.exists()) file1.mkdirs();
			ind++;
		}
		System.out.println("File Directory created to be used for storing files");
		ctx.setAttribute("FILES_DIR_FILE", file);
		ctx.setAttribute("FILES_DIR", rootPath);
	}

}
