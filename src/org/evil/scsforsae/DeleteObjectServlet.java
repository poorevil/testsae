package org.evil.scsforsae;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.sina.cloudstorage.auth.BasicAWSCredentials;
import com.sina.cloudstorage.services.scs.SCS;
import com.sina.cloudstorage.services.scs.SCSClient;
import com.sina.cloudstorage.services.scs.model.ListObjectsRequest;
import com.sina.cloudstorage.services.scs.model.ObjectListing;
import com.sina.cloudstorage.util.URLEncodedUtils;

public class DeleteObjectServlet  extends HttpServlet {
	
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
		Map<String,String> result = new HashMap<String,String>();
		result.put("bucketName", URLEncoder.encode(bucketName, "UTF-8"));
		result.put("prefix", URLEncoder.encode(prefix, "UTF-8"));
		try {
			
			ListObjectsRequest listObjectsRequest = new ListObjectsRequest(bucketName, prefix, null, null, 3);
			ObjectListing ol = client.listObjects(listObjectsRequest);
			if (ol.getCommonPrefixes().size() >0){
				result.put("state", "dir");
				result.put("reason", "has file");
			}else if (ol.getObjectSummaries().size() >1){
				result.put("state", "dir");
				result.put("reason", "has file");
			}else if (ol.getObjectSummaries().size() == 1 && !prefix.equals(ol.getObjectSummaries().get(0).getKey())){
				result.put("state", "dir");
				result.put("reason", "has file");
			}else{
				client.deleteObject(bucketName, prefix);
				result.put("state", "ok");
			}
		} catch (Exception e1) {
			result.put("state", "error");
			result.put("reason", e1.getLocalizedMessage());
		}
		
		Gson gson = new Gson();
		response.getWriter().println(gson.toJson(result));
	}

}
