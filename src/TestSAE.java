import java.io.IOException;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class TestSAE  extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		Map<String,String> envs = System.getenv();
		for (Entry<String, String> entry : envs.entrySet()){
			response.getWriter().println(entry.getKey()+":"+entry.getValue());
		}
	}
	

}
