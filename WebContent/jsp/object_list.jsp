<%@ page language="java" import="java.util.*,com.sina.cloudstorage.services.scs.model.*,com.sina.cloudstorage.services.scs.*,java.net.* ,java.text.*, org.evil.scsforsae.util.*"
contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- <link rel="icon" href="../../favicon.ico"> -->

    <title>Dashboard</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css">

    <style type="text/css">
        /*
         * Base structure
         */

        /* Move down content because we have a fixed navbar that is 50px tall */
        body {
          padding-top: 50px;
        }

        /*
         * Global add-ons
         */

        .sub-header {
          padding-bottom: 10px;
          border-bottom: 1px solid #eee;
        }

        /*
         * Top navigation
         * Hide default border to remove 1px line.
         */
        .navbar-fixed-top {
          border: 0;
        }

        /*
         * Sidebar
         */

        /* Hide for mobile, show later */
        .sidebar {
          display: none;
        }
        @media (min-width: 768px) {
          .sidebar {
            position: fixed;
            top: 51px;
            bottom: 0;
            left: 0;
            z-index: 1000;
            display: block;
            padding: 20px;
            overflow-x: hidden;
            overflow-y: auto; /* Scrollable contents if viewport is shorter than content. */
            background-color: #f5f5f5;
            border-right: 1px solid #eee;
          }
        }

        /* Sidebar navigation */
        .nav-sidebar {
          margin-right: -21px; /* 20px padding + 1px border */
          margin-bottom: 20px;
          margin-left: -20px;
        }
        .nav-sidebar > li > a {
          padding-right: 20px;
          padding-left: 20px;
        }
        .nav-sidebar > .active > a,
        .nav-sidebar > .active > a:hover,
        .nav-sidebar > .active > a:focus {
          color: #fff;
          background-color: #428bca;
        }


        /*
         * Main content
         */

        .main {
          padding: 20px;
        }
        @media (min-width: 768px) {
          .main {
            padding-right: 40px;
            padding-left: 40px;
          }
        }
        .main .page-header {
          margin-top: 0;
        }


        /*
         * Placeholder dashboard ideas
         */

        .placeholders {
          margin-bottom: 30px;
          text-align: center;
        }
        .placeholders h4 {
          margin-bottom: 0;
        }
        .placeholder {
          margin-bottom: 20px;
        }
        .placeholder img {
          display: inline-block;
          border-radius: 50%;
        }

        /*
         * file upload
         */
        .btn-file {
          position: relative;
          overflow: hidden;
        }
        .btn-file input[type=file] {
          position: absolute;
          top: 0;
          right: 0;
          min-width: 100%;
          min-height: 100%;
          font-size: 100px;
          text-align: right;
          filter: alpha(opacity=0);
          opacity: 0;
          outline: none;
          background: white;
          cursor: inherit;
          display: block;
        }

        .bar {
            height: 18px;
            background: blue;
        }

    </style>

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
    <!--<script src="../../assets/js/ie-emulation-modes-warning.js"></script>-->

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="http://cdn.bootcss.com/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="http://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">SCS SDK for SAE demo</a>
        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li class="active"><a href="loginservlet">Overview</a></li>
          </ul>
          <ul class="nav nav-sidebar" style="margin-top:20px">
            <li><a href="http://open.sinastorage.com/?c=doc&a=sdk&k=java&t=sdk" target="_blank">SCS-Java for SAE SDK 文档</a></li>
            <li><a href="http://open.sinastorage.com/?c=doc&a=sdk&k=java&t=sdk" target="_blank">SCS-Java SDK 文档</a></li>
            <li><a href="http://open.sinastorage.com/?c=doc&a=api" target="_blank">SCS Api 文档</a></li>
            <li><a href="http://open.sinastorage.com/" target="_blank">SCS 官网</a></li>
          </ul>
        </div>

        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">Dashboard</h1>

          <%
              ObjectListing objectListing = (ObjectListing)request.getAttribute("objectListing");
              String currentPath = objectListing.getBucketName()+"/"+(objectListing.getPrefix()==null?"":(objectListing.getPrefix()));
              String[] pathArray = currentPath.trim().split("/");
          %>
          <input type="hidden" id="currentPath" value="<%=currentPath%>">
          <ol class="breadcrumb">
            <li><a href="loginservlet">全部</a></li>
          <%
              int idx = 0;
              StringBuffer urlsb = new StringBuffer();
              for (String subPath : pathArray){
                idx++;
                if(idx==pathArray.length){
          %>
            <li class="active"><%=subPath%></li>
          <%
                }else{
                  urlsb.append(subPath+"/");
          %>
            <li><a href="list_object?path=<%=java.net.URLEncoder.encode(urlsb.toString(),"UTF-8")%>"><%=subPath%></a></li>
          <%
              }
            }
          %>
          </ol>

          <div class="row">
            <div class="col-sm-11 col-md-11 col-xs-11">
              <div class="btn-group">
                <button type="button" id="upload_btn" class="btn btn-primary" data-toggle="modal" data-target=".upload_file-modal"><span class="glyphicon glyphicon-plus-sign"></span> 上传</button>
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target=".create_folder-modal"><span class="glyphicon glyphicon-plus"></span> 创建前缀</button>
              </div>
              <button type="button" id="set_acl_btn" style="margin-left:10px" class="btn btn-info" disabled="disabled" data-toggle="modal" data-target=".acl_detail-modal">
                <span class="glyphicon glyphicon-wrench"></span> 设置ACL
              </button>
              <button type="button" id="del_btn" style="margin-left:10px" class="btn btn-danger" disabled="disabled" data-toggle="modal" data-target=".del_obj-modal"><span class="glyphicon glyphicon-trash"></span> 删除</button>
            </div>
          </div>

          <div class="table-responsive">
            <table class="table table-striped table-hover">
              <thead>
                <tr>
                  <th><input type="checkbox" id="select_all_chk"></th>
                  <th>名称</th>
                  <th>大小</th>
                  <th>类型</th>
                  <th>创建时间</th>
                </tr>
              </thead>
              <tbody>
                <%
                    List<Map<String,String>> commonPrefixes = objectListing.getCommonPrefixes();
                    for(Map<String,String> cp : commonPrefixes){
                        String commonPrefix = objectListing.getPrefix()!=null?cp.get("Prefix").replaceFirst(objectListing.getPrefix(),""):cp.get("Prefix");
                        String url = java.net.URLEncoder.encode(objectListing.getBucketName()+"/"+cp.get("Prefix"),"UTF-8");
                %>
                <tr>
                  <td><input type="checkbox" name="chk" value="<%=url%>"></td>
                  <td><a href="list_object?path=<%=url%>"><%=commonPrefix%></a></td>
                  <td>-</td>
                  <td>前缀</td>
                  <td>-</td>
                </tr>
                <%
                    }
                    List<S3ObjectSummary> objectSummaries = objectListing.getObjectSummaries();

                    String accessKey = (String)session.getAttribute("accessKey");
                    String secretKey = (String)session.getAttribute("secretKey");                    
                    SCSClient client = new SCSClient(new com.sina.cloudstorage.auth.BasicAWSCredentials(accessKey, secretKey));
                    client.setEndpoint("http://cdn.sinacloud.net");
                    for(S3ObjectSummary objectSummary : objectSummaries){
                        if(objectSummary.getKey().equals(objectListing.getPrefix()))
                            continue;

                        String objectKey = objectListing.getPrefix()!=null?
                            objectSummary.getKey().substring(objectListing.getPrefix().length(),objectSummary.getKey().length())
                            :objectSummary.getKey();

                        Date expiration = new Date();
                        long epochMillis = expiration.getTime();
                        epochMillis += 60*60*1000;
                        expiration = new Date(epochMillis);
                        GeneratePresignedUrlRequest generatePresignedUrlRequest = new GeneratePresignedUrlRequest(objectListing.getBucketName(), objectSummary.getKey());
                        URL url = client.generatePresignedUrl(generatePresignedUrlRequest);

                        String keyPath = java.net.URLEncoder.encode(objectListing.getBucketName()+"/"+objectSummary.getKey(),"UTF-8");
                %>
                <tr>
                  <td><input type="checkbox" name="chk" value="<%=keyPath%>"></td>
                  <td><a target="_blank" href="<%=url.toString()%>"><%=objectKey%></a></td>
                  <td><%=objectSummary.getSize()>0?Utils.formatSize(objectSummary.getSize()):"-"%></td>
                  <td>文件</td>
                  <%
                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    String cd = df.format(objectSummary.getLastModified());
                  %>
                  <td><%=cd%></td>
                </tr>
                <%
                    }
                %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- acl详情 -->
    <div class="modal fade acl_detail-modal" id="acl_detail_modal" tabindex="-1" role="dialog" aria-labelledby="acl detail" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <h4 class="modal-title" id="acl_detail_title_div">访问控制</h4>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-sm-2">
                <p>路径:</p>
              </div>
              <div class="col-sm-10">
                <p id="acl_detail_key"></p>
                <input type="hidden" id="acl_detail_current_path_hidden" value=""/> 
              </div>
            </div>
            <!-- 组 -->
            <h4>权限</h4>
            <table class="table table-striped table-hover" id="acl_detail_group_tbl">
              <thead>
                <tr>
                  <th>组</th>
                  <th>读</th>          
                  <th>写</th>
                  <th>读ACL</th>
                  <th>写ACL</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>asdfsdf</td>
                  <td><input type="checkbox" name="acl_detail_group_read_chk" value=""></td>
                  <td><input type="checkbox" name="acl_detail_group_write_chk" value=""></td>
                  <td><input type="checkbox" name="acl_detail_group_readacl_chk" value=""></td>
                  <td><input type="checkbox" name="acl_detail_group_writeacl_chk" value=""></td>
                </tr>
              </tbody>
            </table>
            <!-- 用户 -->
            <table class="table table-striped table-hover" id="acl_detail_user_tbl">
              <thead>
                <tr>
                  <th>UserId</th>
                  <th>读</th>          
                  <th>写</th>
                  <th>读ACL</th>
                  <th>写ACL</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>asdfsdf</td>
                  <td><input type="checkbox" name="acl_detail_group_read_chk" value=""></td>
                  <td><input type="checkbox" name="acl_detail_group_write_chk" value=""></td>
                  <td><input type="checkbox" name="acl_detail_group_readacl_chk" value=""></td>
                  <td><input type="checkbox" name="acl_detail_group_writeacl_chk" value=""></td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary" id="acl_detail_save_btn" value="">Save changes</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 删除确认 -->
    <div class="modal fade del_obj-modal" id="del_obj_modal" tabindex="-1" role="dialog" aria-labelledby="del object" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <h4 class="modal-title" id="del_obj_title_div">删除操作</h4>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-sm-12" id="del_result_div">
                <p>确认删除当前所选文件吗？</p>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-danger" id="del_confirm_btn" value="">确认删除</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 创建前缀 -->
    <div class="modal fade create_folder-modal" id="create_folder_modal" tabindex="-1" role="dialog" aria-labelledby="create folder" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <h4 class="modal-title" id="create_folder_title_div">创建前缀</h4>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="form-horizontal" role="form">
                <div class="form-group">
                  <label class="control-label col-sm-2" for="folder_name">前缀名</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" id="folder_name" placeholder="前缀名">
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary" id="create_folder_confirm_btn" value="">创建</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 上传文件 -->
    <div class="modal fade upload_file-modal" id="upload_file_modal" tabindex="-1" role="dialog" aria-labelledby="upload file" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <h4 class="modal-title" id="upload_file_title_div">上传文件</h4>
          </div>
          <div id="upload_modal_body" class="modal-body">
            <div class="row">
              <div class="col-sm-6">
                <span id="file_upload_btn" class="btn btn-success btn-file">
                  Browse <input id="fileupload" type="file" name="files" multiple="" ><!-- data-url="http://sinastorage.net" -->
                </span>
                
              </div>
            </div>

            <!-- <div class="row" style="margin-top:20px">
              <div class="col-sm-6">
                <div class="alert alert-success" role="alert">
                  <span>213213123</span>
                  <div id="progress" style="height:1px;margin-top:10px">
                    <div class="bar" style="width: 0%;height:1px"></div>
                  </div>
                </div>
              </div>
            </div> -->

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <!--     <button type="button" class="btn btn-primary" id="upload_file_confirm_btn" value="">创建</button> -->
          </div>
        </div>
      </div>
    </div>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="http://cdn.bootcss.com/jquery/1.11.1/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="http://cdn.bootcss.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
    <!-- file upload js -->
    <script src="js/vendor/jquery.ui.widget.js"></script>
    <script src="js/jquery.iframe-transport.js"></script>
    <script src="js/jquery.fileupload.js"></script>

    <script type="text/javascript">
        $(document).ready(function(){
          $("#del_btn").prop("disabled",true);
          $("#set_acl_btn").prop("disabled",true);
          $("input[name='chk']").each(function(){
            $(this).prop("checked",false);
          });
        });

        //全选
        $("#select_all_chk").on( "click", function( event ) {
            var state = $(this).prop("checked");
            $("input[name='chk']").each(function(){
              $(this).prop("checked",state);
            });

            if (state == true){
              $("#del_btn").prop("disabled",false);
            }else{
              $("#del_btn").prop("disabled",true);
            }

            $("#set_acl_btn").prop("disabled",true);
        });

        //每行的checkbox
        $("input[name='chk']").on("click", function(){
            var ischecked = false; 
            var checkedAmount = 0;
            $("input[name='chk']").each(function(){
              ischecked = ischecked || $(this).prop("checked");
              if ($(this).prop("checked") == true){ checkedAmount+=1;}
            });

            $("#del_btn").prop("disabled",!ischecked);

            if (checkedAmount==1){
              $("#set_acl_btn").prop("disabled",false);
            }else{
              $("#set_acl_btn").prop("disabled",true);
            }
        });

        //设置acl
        $("#set_acl_btn").on("click", function(){
            var keyPath = get_checked_key_fn()[0];
            $("#acl_detail_key").html(decodeURIComponent(keyPath));
            $("#acl_detail_current_path_hidden").val(keyPath);
            $.ajax({
              // the URL for the request
              url: "get_acl?oper=getacl&key="+keyPath,
              // the data to send (will be converted to a query string)
              // data: {
              // "key": keyPath
              // },
              // whether this is a POST or GET request
              type: "GET",
              // the type of data we expect back
              dataType : "json",
              // code to run if the request succeeds;
              // the response is passed to the function
              success: function( json ) {
                // {"grants":
                //   [{"grantee":{"accessKeyId":"GRPS000000ANONYMOUSE"},"permissions":[]},
                //   {"grantee":{"accessKeyId":"SINA0000001001NHT3M3"},"permissions":["Write","WriteAcp"]},
                //   {"grantee":{"accessKeyId":"GRPS0000000CANONICAL"},"permissions":[]},
                //   {"grantee":{"accessKeyId":"SINA0000001001NHT3M7"},"permissions":["Write","WriteAcp","Read","ReadAcp"]}]
                // } 
                $('#acl_detail_user_tbl > tbody').empty();
                $('#acl_detail_group_tbl > tbody').empty();
                for (var i=0;i<json["grants"].length;i++){

                  var grantee = json["grants"][i]["grantee"]["accessKeyId"];
                  var tableId;
                  if (grantee.match("^GRPS000000")){
                    tableId = "acl_detail_group_tbl";
                  }else{
                    tableId = "acl_detail_user_tbl";
                  }

                  var accessKeyId = json["grants"][i]["grantee"]["accessKeyId"];
                  $('#'+tableId+' > tbody:last').append('<tr id='+accessKeyId+'>\
                      <td>'+accessKeyId+'</td>\
                      <td><input type="checkbox" '+ ($.inArray("Read", json["grants"][i]["permissions"]) > -1?'checked':'')+
                        ' name="acl_detail_group_read_chk" id="'+accessKeyId+'_read"></td>\
                      <td><input type="checkbox" '+ ($.inArray("Write", json["grants"][i]["permissions"]) > -1?'checked':'')+
                        ' name="acl_detail_group_write_chk" id="'+accessKeyId+'_write"></td>\
                      <td><input type="checkbox" '+ ($.inArray("ReadAcp", json["grants"][i]["permissions"]) > -1?'checked':'')+
                        ' name="acl_detail_group_readacl_chk" id="'+accessKeyId+'_readacp"></td>\
                      <td><input type="checkbox" '+ ($.inArray("WriteAcp", json["grants"][i]["permissions"]) > -1?'checked':'')+
                        ' name="acl_detail_group_writeacl_chk" id="'+accessKeyId+'_writeacp"></td>\
                    </tr>');
                }

                $("#acl_detail_modal").modal('show');
              },
              // code to run if the request fails; the raw request and
              // status codes are passed to the function
              error: function( xhr, status, errorThrown ) {
                alert( "Sorry, there was a problem!" );
                console.log( "Error: " + errorThrown );
                console.log( "Status: " + status );
                console.dir( xhr );
              },
              // code to run regardless of success or failure
              complete: function( xhr, status ) {
              // alert( "The request is complete!" );
              }
            });
        });

        //获取选中的key数组
        var get_checked_key_fn = function(){
            var keys = new Array();
            $("input[name='chk']").each(function(){
              if ($(this).prop("checked")){
                keys.push($(this).val());
              }
            });
            return keys;
        };

        $("#acl_detail_save_btn").on("click", function(){
          var keyPath = $("#acl_detail_current_path_hidden").val();
          var jsonResult = {};
          var acl = {};
          jsonResult["ACL"] = acl;
          //用户组
          $("#acl_detail_user_tbl > tbody").find("tr").each(function(){
            var accessKeyId = $(this).prop("id");
            var permissions = [];
            if ($("#"+accessKeyId+"_read").prop("checked")==true){
              permissions.push("Read");
            }
            if ($("#"+accessKeyId+"_write").prop("checked")==true){
              permissions.push("Write");
            }
            if ($("#"+accessKeyId+"_readacp").prop("checked")==true){
              permissions.push("Read_Acp");
            }
            if ($("#"+accessKeyId+"_writeacp").prop("checked")==true){
              permissions.push("Write_Acp");
            }
            acl[accessKeyId]=permissions;
          });
          //组
          $("#acl_detail_group_tbl > tbody").find("tr").each(function(){
            var accessKeyId = $(this).prop("id");
            var permissions = [];
            if ($("#"+accessKeyId+"_read").prop("checked")==true){
              permissions.push("Read");
            }
            if ($("#"+accessKeyId+"_write").prop("checked")==true){
              permissions.push("Write");
            }
            if ($("#"+accessKeyId+"_readacp").prop("checked")==true){
              permissions.push("Read_Acp");
            }
            if ($("#"+accessKeyId+"_writeacp").prop("checked")==true){
              permissions.push("Write_Acp");
            }
            acl[accessKeyId]=permissions;
          });
          // alert(JSON.stringify(jsonResult, null, 2));
          $.ajax({
              // the URL for the request
              url: "get_acl?oper=setacl&key="+keyPath,
              // the data to send (will be converted to a query string)
              data: JSON.stringify(jsonResult, null, 2),
              // whether this is a POST or GET request
              type: "POST",
              // the type of data we expect back
              // dataType : "json",
              // code to run if the request succeeds;
              // the response is passed to the function
              success: function() {
                $("#acl_detail_modal").modal('hide');
              },
              // code to run if the request fails; the raw request and
              // status codes are passed to the function
              error: function( xhr, status, errorThrown ) {
                alert( "Sorry, there was a problem!" );
                console.log( "Error: " + errorThrown );
                console.log( "Status: " + status );
                console.dir( xhr );
              },
              // code to run regardless of success or failure
              complete: function( xhr, status ) {
              // alert( "The request is complete!" );
              }
            });
        });

        $("#del_btn").on("click", function(){
          $("#del_confirm_btn").prop("disabled",false);
          $("#del_result_div").empty();
          $("#del_result_div").append('<p>确认删除当前所选文件吗？</p>')
        });

        $("#del_confirm_btn").on("click", function(){
          $("#del_confirm_btn").prop("disabled",true);
          $("#del_result_div").empty();

          var selected_item_array = get_checked_key_fn();
          jQuery.each(selected_item_array, function(index, item) {
            $.ajax({
              // the URL for the request
              url: "del_object?path="+item,
              // the data to send (will be converted to a query string)
              // data: JSON.stringify(jsonResult, null, 2),
              // whether this is a POST or GET request
              type: "GET",
              // the type of data we expect back
              dataType : "json",
              // code to run if the request succeeds;
              // the response is passed to the function
              success: function(json) {
                var row;
                if ("ok" == json["state"]){
                  // alert(json["bucketName"]+"   "+json["prefix"]);
                  row = '<div class="alert alert-success" role="alert">'+decodeURIComponent(json["prefix"])+' 删除成功。</div>'
                }else if ("dir" == json["state"]){
                  // alert("不能删除包含文件的目录");
                  row = '<div class="alert alert-danger" role="alert">'+decodeURIComponent(json["prefix"])+' 删除失败，不能删除包含文件的目录。</div>'
                }else{
                  alert(json["reason"]);
                  row = '<div class="alert alert-danger" role="alert">'+decodeURIComponent(json["prefix"])+' 删除失败，请稍后再试。</div>'
                }

                $("#del_result_div").append(row);
              },
              // code to run if the request fails; the raw request and
              // status codes are passed to the function
              error: function( xhr, status, errorThrown ) {
                alert( "Sorry, there was a problem!" );
                console.log( "Error: " + errorThrown );
                console.log( "Status: " + status );
              },
              // code to run regardless of success or failure
              complete: function( xhr, status ) {
              // alert( "The request is complete!" );
              }
            });
          });
        });

        $('#del_obj_modal').on('hidden.bs.modal', function (e) {
          if ($("#del_confirm_btn").prop("disabled")==true){
            location.reload();  
          }
        });

        $("#create_folder_modal").on('hidden.bs.modal', function (e) {
          $("#folder_name").val('');
          if ($("#create_folder_confirm_btn").prop("disabled")==true){
            location.reload();  
          }
        });

        $("#create_folder_confirm_btn").on("click", function(){
          $("#create_folder_confirm_btn").prop("disabled", true);
          var folder_name = $("#folder_name").val();
          var path = $("#currentPath").val()+folder_name;
          $.ajax({
              // the URL for the request
              url: "create_folder?path="+encodeURIComponent(path),
              // the data to send (will be converted to a query string)
              // data: JSON.stringify(jsonResult, null, 2),
              // whether this is a POST or GET request
              type: "GET",
              // the type of data we expect back
              dataType : "json",
              // code to run if the request succeeds;
              // the response is passed to the function
              success: function(json) {
                if ('success' == json["state"]){
                  $("#create_folder_modal").modal('hide');
                }else{
                  alert(json["state"]);
                }
              },
              // code to run if the request fails; the raw request and
              // status codes are passed to the function
              error: function( xhr, status, errorThrown ) {
                alert( "Sorry, there was a problem!" );
                console.log( "Error: " + errorThrown );
                console.log( "Status: " + status );
              },
              // code to run regardless of success or failure
              complete: function( xhr, status ) {
              // alert( "The request is complete!" );
              }
            });
        });

        $(function () {
          $('#fileupload').bind('fileuploadchange', function (e, data) {

            // $("#fileupload").prop("disabled", true)
            // $('#fileupload').fileupload('disable');

            var file_name;// = $(this).val();
            var path = $("#currentPath").val();
            $.each(data.files, function (index, file) {
              file_name = file.name;
              return false;//每次只传一个文件
            });

            $("#upload_modal_body").append('\
            <div class=\"row\" style=\"margin-top:20px\">\
              <div class=\"col-sm-6\">\
                <div class=\"alert alert-success\" role=\"alert\">\
                  <span>'+file_name+'</span>\
                  <div id=\"progress\" style=\"height:1px;margin-top:10px\">\
                    <div class=\"bar\" style=\"width: 0%;height:1px\"></div>\
                  </div>\
                </div>\
              </div>\
            </div>');


            if(file_name.length<=0) {alert("请选择待上传文件！");return;}
            path += file_name;
            $.ajax({
              async: false,
              // the URL for the request
              url: "genurl?path="+encodeURIComponent(path),
              // the data to send (will be converted to a query string)
              // data: JSON.stringify(jsonResult, null, 2),
              // whether this is a POST or GET request
              type: "GET",
              // the type of data we expect back
              dataType : "json",
              // code to run if the request succeeds;
              // the response is passed to the function
              success: function(json) {
                if ('success' == json["state"]){
                  var destUrl = json["url"];
                  $('#fileupload').fileupload('add', {files: data.files, url: destUrl, contentType:'application/zip'});
                  // var jqXHR = $('#fileupload').fileupload('send', {url:url,files: data.files,contentType:'application/zip'})
                  //           .success(function (result, textStatus, jqXHR) {alert("upload success");})
                  //           .error(function (jqXHR, textStatus, errorThrown) {alert("upload error"+textStatus);})
                  //           .complete(function (result, textStatus, jqXHR) {});// .complete(function (result, textStatus, jqXHR) {alert("upload complete");}
                }else{
                  alert(json["reason"]);
                  return;
                }
              },
              // code to run if the request fails; the raw request and
              // status codes are passed to the function
              error: function( xhr, status, errorThrown ) {
                alert( "Sorry, there was a problem!" );
                console.log( "Error: " + errorThrown );
                console.log( "Status: " + status );
              },
              // code to run regardless of success or failure
              complete: function( xhr, status ) {
              // alert( "The request is complete!" );
              }
            });
          });

          $('#fileupload').fileupload({method: 'PUT',
              progressall: function (e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
                $('#progress .bar').css(
                    'width',
                    progress + '%'
                );
              },success: function (result, textStatus, jqXHR) {alert("上传成功");location.reload();}
              ,error: function (jqXHR, textStatus, errorThrown) {
                console.log($(this)[0].url);
                console.log(errorThrown);
                if ($(this)[0].url.indexOf("http://sinacloud.net") == 0){
                  alert("上传失败,请重试.");
                }
              }
            });
        });

    </script>

  </body>
</html>
