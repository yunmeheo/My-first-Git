<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=UTF-8">
<title>movielist.jsp</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script>

$(function(){
	
	var $parentObj = $("article");
    if($parentObj.length == 0){
      $parentObj = $("body");
    }
	
	//영화관 선택 클릭시 >> 지점보여주기
	var $a =$(".alllist").find("a");
	$a.click(function(){
		var move_title = $(this).parent().attr('id');
		console.log("영화관선택");
		console.log(move_title);
		$.ajax({
			url:"selectlocation.do",
			method:"post",
			data: {'move_title': move_title},
			success:function(responseData){
				var jsonObj = responseData;
				var listLen = jsonObj.length
				console.log("listLen:"+listLen);
				console.log("jsonObj:"+jsonObj);
				var alllist = $(".alllist");
				var branchlist = $(".branchlist");
				alllist.hide();
				$(".screen").show();
				$(".movie_title").show();
				
				$(".movie_title").html(move_title);
				console.log("move_code"+move_title);
				
				for(var i=0; i<listLen; i++){
					var div = $("<div class='listdetail'>").appendTo(".branchlist");
		            div.html(jsonObj[i].branch_name);
	              }	
	            branchlist.show();	  
	            $(".paging").hide();
			},
			error:function(xhr, status, error){
            console.log("오류메세지:"+xhr.status);
            }
		}); return false;
	}); //click function

	
	//영화지점 뿌리기	
	$("body").on("click", ".listdetail", function(){
		var movie_title = $(".movie_title").html();
		console.log("지역 클릭됨");
		console.log("movie_title :"+movie_title);
		$.ajax({
			url:"selectinfo.do",
			method:"post",
			data :{
				'movie_title' : $(".movie_title").html(),
				'branch_name' : $(this).html()
			},
			success:function(responseData){
				console.log(responseData);
                $("article").empty();
                $("article").html(responseData.trim()); 
                
			}
		});$parentObj.off(); return false; 
	});
	
	//이전이나 다음 눌렀을 때 액션
	//$("body").on("click", "pagingBt", function(){
		$(".paging").find(".pagingBt").click(function(){
		var pageno = $(".pagingBt").attr('id')
		console.log(pageno);
		$.ajax({
			url:'movielist.do',
            method: 'GET', 
            data:{
            	'pageno': $(".pagingBt").attr('id')
			},
            success:function(responseData){
            	
            	$("article").empty();
                $("article").html(responseData.trim()); 
               
                
          }
        }); // end ajax
		$parentObj.off(); return false; 
		
	});
	

	
});	


</script>




<style>
.alllist{display: inline-block;}
.listdetail{margin : 2px}
.alllist table{border: 1px solid;}
.alllist td{border: 1px solid;}
.branchlist{display: none;}
.branchtable{border: 1px solid }
.branchtable td{border: 1px solid }
.branchlist{width: 350px}
.branchlist div.listdetail{border: 1px solid ;  width: 50px; display: inline-block;}
.clicked { background-color: red; } 
.screen{display: none;}
.movie_title{display: none;}
</style>

<body>




<!--지역리스트 -->
<div class="screen">
<h1 >지점선택</h1>
</div>

<br>
<c:set var="movie_code" value="${requestScope.movie_code}"/>

<!--제목 보여주기 -->
<div class="movie_title">${movie_title}</div>


<!-- 지역리스트 json -->
<div class="branchlist">
</div>


<div class="paging">

<h1>전체리스트</h1>
 <!-- 페이징 -->
<%!
	public Integer toInt(String x){
		int a = 0;
		try{
			a = Integer.parseInt(x);
		}catch(Exception e){}
		return a;
	}
%>
<%
	int pageno = toInt(request.getParameter("pageno"));
	if(pageno<1){//현재 페이지
		pageno = 1;
	}
	int total_record = 6;		   //총 레코드 수
	int page_per_record_cnt = 1;  //페이지 당 레코드 수
	int group_per_page_cnt =1;     //페이지 당 보여줄 번호 수[1],[2],[3],[4],[5]
//					  									  [6],[7],[8],[9],[10]											

	int record_end_no = pageno*page_per_record_cnt;				
	int record_start_no = record_end_no-(page_per_record_cnt-1);
	if(record_end_no>total_record){
		record_end_no = total_record;
	}
										   
										   
	int total_page = total_record / page_per_record_cnt + (total_record % page_per_record_cnt>0 ? 1 : 0);
	if(pageno>total_page){
		pageno = total_page;
	}

	

	int group_no = pageno/group_per_page_cnt+( pageno%group_per_page_cnt>0 ? 1:0);
	int page_eno = group_no*group_per_page_cnt;		
	int page_sno = page_eno-(group_per_page_cnt-1);	
	if(page_eno>total_page){
		page_eno=total_page;
	}
	
	int prev_pageno = page_sno-group_per_page_cnt;  // <<  *[이전]* [21],[22],[23]... [30] [다음]  >>
	int next_pageno = page_sno+group_per_page_cnt;	// <<  [이전] [21],[22],[23]... [30] *[다음]*  >>
	if(prev_pageno<1){
		prev_pageno=6;
	}
	if(next_pageno>total_page){
         next_pageno=1;
	}
%>
<!--페이징 -->
<a href=""  id="<%=prev_pageno%>"  class="pagingBt" >◀</a>

<!-- 영화  전체 리스트 -->
<c:set var="list" value="${requestScope.list}"/>

<div class="alllist">
<table>

<tr class="main" >
<td colspan="${fn:length(list)}" >영화코드</td>
</tr>

<tr>
<c:forEach var="movie"  items="${list}">
<td>${movie.movie_code}</td>
</c:forEach>
</tr>

<tr>
<c:forEach var="movie"  items="${list}">
<td id="title">${movie.movie_title}</td>
</c:forEach>
</tr>

<tr>
<c:forEach var="movie"  items="${list}">
<td id="${movie.movie_title}"><a href="">영화관 선택</a></td>
</c:forEach>
</tr>

</table>
</div>

<!--페이징 -->
<a class="pagingBt"  href=""   id="<%=next_pageno%>"  >▶</a>

</div>


</body>
</html>