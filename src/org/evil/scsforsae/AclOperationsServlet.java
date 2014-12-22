package org.evil.scsforsae;

import java.io.BufferedReader;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.sina.cloudstorage.auth.BasicAWSCredentials;
import com.sina.cloudstorage.services.scs.SCS;
import com.sina.cloudstorage.services.scs.SCSClient;
import com.sina.cloudstorage.services.scs.model.AccessControlList;

public class AclOperationsServlet  extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		// reading the user input
		BufferedReader br = request.getReader();
		StringBuffer sb = new StringBuffer();
		String line = null;
		while((line = br.readLine())!=null){
			sb.append(line);
		}
		
		String oper = request.getParameter("oper");//操作类型
		System.out.println(oper);
		String path = null;
		if("scstestjava".equals(System.getenv("appname")))
			path = URLDecoder.decode(request.getParameter("key"), "UTF-8");
		else
			path = new String(request.getParameter("key").getBytes("ISO-8859-1"), "utf-8");
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
			if ("setacl".equals(oper)){
				Gson gson = new Gson();
				Map<String, Object> jsonMap = gson.fromJson(sb.toString(), Map.class);
				AccessControlList acl = new AccessControlList(jsonMap);
				System.out.println(acl);
				client.setObjectAcl(bucketName, prefix, acl);
			}
		} catch (Exception e1) {
			e1.printStackTrace();
			response.getWriter().println("{\"error\":\""+e1.getMessage()+"\"}");
		}
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		// reading the user input
		String oper = request.getParameter("oper");//操作类型
		System.out.println(oper);
		String path = null;
		if("scstestjava".equals(System.getenv("appname")))
			path = URLDecoder.decode(request.getParameter("key"), "UTF-8");
		else
			path = new String(request.getParameter("key").getBytes("ISO-8859-1"), "utf-8");
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
			if ("getacl".equals(oper)){
				AccessControlList acl = client.getObjectAcl(bucketName, prefix);
				Gson gson = new Gson();
				String json = gson.toJson(acl, AccessControlList.class);
				
				response.getWriter().println(json);
			}
		} catch (Exception e1) {
			e1.printStackTrace();
			response.getWriter().println("{\"error\":\""+e1.getMessage()+"\"}");
		}
	}
}
