package org.evil.scsforsae;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sina.cloudstorage.auth.BasicAWSCredentials;
import com.sina.cloudstorage.services.scs.SCS;
import com.sina.cloudstorage.services.scs.SCSClient;
import com.sina.cloudstorage.services.scs.model.Bucket;

public class LoginServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		// reading the user input
		String accessKey = request.getParameter("accessKey");
		String secretKey = request.getParameter("secretKey");
		
		if (accessKey == null || secretKey == null){
			accessKey = (String) request.getSession().getAttribute("accessKey");
			secretKey = (String) request.getSession().getAttribute("secretKey");
		}
		
		try {
			SCS client = new SCSClient(new BasicAWSCredentials(accessKey, secretKey));
			List<Bucket> buckets = client.listBuckets();
			if (buckets != null){
				request.getSession().setAttribute("accessKey", accessKey);
				request.getSession().setAttribute("secretKey", secretKey);
				//redirect to bucket list page
				request.setAttribute("buckets", buckets);
				request.getRequestDispatcher("/jsp/bucket_list.jsp").forward(request, response);
			}
		} catch (Exception e1) {
			e1.printStackTrace();
			request.setAttribute("errorMsg", "登录失败:"+e1);
			request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
		}
	}
	
}
