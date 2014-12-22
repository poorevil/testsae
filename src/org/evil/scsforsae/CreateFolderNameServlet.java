package org.evil.scsforsae;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sina.cloudstorage.auth.BasicAWSCredentials;
import com.sina.cloudstorage.services.scs.SCS;
import com.sina.cloudstorage.services.scs.SCSClient;
import com.sina.cloudstorage.util.StringInputStream;

public class CreateFolderNameServlet  extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		// reading the user input
		String path = null;
		if("scstestjava".equals(System.getenv("appname")))
			path = URLDecoder.decode(request.getParameter("path"), "UTF-8");
		else
			path = new String(request.getParameter("path").getBytes("ISO-8859-1"), "utf-8");
		//TODO:校验path
		String bucketName = path.contains("/")?path.substring(0, path.indexOf("/")):path;
		String prefix = null;
		if (path.contains("/")){
			prefix = path.substring(path.indexOf(bucketName)+bucketName.length()+1, path.length());
		}
		
		String accessKey = (String)request.getSession().getAttribute("accessKey");
		String secretKey = (String)request.getSession().getAttribute("secretKey");
		
		SCS client = new SCSClient(new BasicAWSCredentials(accessKey, secretKey));
		try {
			InputStream input = new StringInputStream("");
			client.putObject(bucketName, prefix.endsWith("/")?prefix:(prefix+"/"), input, null);
			response.getWriter().println("{\"state\":\"success\"}");
		} catch (Exception e1) {
			response.getWriter().println("{\"state\":\""+e1.getLocalizedMessage()+"\"}");
		}
	}

}
