package org.evil.scsforsae;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sina.cloudstorage.auth.BasicAWSCredentials;
import com.sina.cloudstorage.services.scs.SCS;
import com.sina.cloudstorage.services.scs.SCSClient;
import com.sina.cloudstorage.services.scs.model.ListObjectsRequest;
import com.sina.cloudstorage.services.scs.model.ObjectListing;

public class ListObjectServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		// reading the user input
		String path = null;
		if (request.getParameter("path") == null){
			response.sendRedirect("login");
			return;
		}
			
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
		
		SCS client = null;
		try {
			client = new SCSClient(new BasicAWSCredentials(accessKey, secretKey));
		} catch (Exception e) {
			response.sendRedirect("login");
			return;
		}
		try {
			ListObjectsRequest loRequest = new ListObjectsRequest();
			loRequest.setBucketName(bucketName);
			loRequest.setMaxKeys(100);
			loRequest.setDelimiter("/");
			loRequest.setPrefix(prefix);
			ObjectListing objectListing = client.listObjects(loRequest);
			if (objectListing != null){
				//redirect to bucket list page
				request.setAttribute("objectListing", objectListing);
				request.getRequestDispatcher("/jsp/object_list.jsp").forward(request, response);
			}
		} catch (Exception e1) {
			request.setAttribute("errorMsg", "查询失败:"+e1.getMessage());
			request.getRequestDispatcher("/jsp/error_page.jsp").forward(request, response);
		}
	}

}
