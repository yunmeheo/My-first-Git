<%@page import="com.my.vo.Product"%>
<%@page import="java.util.List"%>
<% String contextPath=request.getContextPath();%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>


<html>
<head>
<meta charset=UTF-8>
<title>admin.jsp</title>
</head>


  <header>
  <jsp:include page = "admmenu.jsp"></jsp:include>
  </header>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script>

$(function(){
  
  
  var $parentObj = $("article");
    if($parentObj.length == 0){
      $parentObj = $("body");
    }

  //로그아웃
  $(".logout").click(function(){
    $.ajax({
      url:'adminLogout.do',
      method:'POST',
      success:function(responseData){
        
        location.href=responseData.trim();
      }
    }); return false;
  });
  
  
  
  //관리자 수정하기
  $("span.modify").click(function(){
    $(".modadm").show();
  });
  var nowpwd=$(".modadm").find("input[name=nowpwd]");
  var newpwd1=$(".modadm").find("input[name=newpwd1]");
  var newpwd2=$(".modadm").find("input[name=newpwd2]");
  newpwd1.focus(function(){
    $("input[id=modcus]").hide();
  }); 
  newpwd2.focus(function(){
    if(newpwd1.val()==newpwd2.val()){
      $("input[id=modcus]").show();
    }
  }); 
  $("input[id=modcus]").click(function(){
      $.ajax({
        url:'adminmodify.do',
        method:'POST',
        data :{"id": $(".adminInfo").find(".id").html(),
              "nowpwd" :  nowpwd.val(),
              "newpwd1" : newpwd1.val(),
              "newpwd2" : newpwd2.val()
            },
        success:function(responseData){
          var result = responseData.trim();
          if(result==1){
            alert("수정완료");
            location.href="<%=contextPath%>";
          }else{
            alert("정확히 입력해주세요");
          }
        }
            
      }); return false;
  });
  
  
  //관리자 추가창 보여주기
    var $insert = $(".adminInfo").find(".insert");
    $insert.click(function(){
    	console.log("관리자추가클릭");
    	$("div.signup").show();
    });
    
    
  //관리자 총리스트 뽑아오기
   var $alllist = $(".adminInfo").find(".alllist");
   $alllist.click(function(){
	    $.ajax({
	      url:"adminselectAll.do",
	      method:"post",
	      success:function(responseData){
	        var result = responseData.trim();
	        $parentObj.empty();
	        $("article").html(responseData.trim());
	      }
	    }); return false;
	  });
   
    
  
 
  //상품추가하기 창 띄우기
  var $proinsert = $(".product").find(".insert");
  $proinsert.click(function(){
    console.log("상품추가 눌렸어요.");
    $(".productmodify").show();
    
  });
  

  
    //상품추가하기
  var no =$("input[id=no]");
  var name =$("input[id=name]");
  var price=$("input[id=price]");
  var $submit = $(".productmodify").find("input[id=submit]")
  $submit.click(function(){
    console.log("no"+no.val()+"name"+name.val()+"price"+price.val());
    $.ajax({
      url:'insertProduct.do',
      data:{'no' : no.val(),
          'name':name.val(),
          'price':price.val()
      },
      method:'POST',
      success:function(responseData){
        
        var result = responseData.trim();
        if(result=='1'){
          alert("추가되었습니다.");
          location.href="admin.jsp";
        }else{
          alert("입력불가합니다.");
        }
      }
    }); return false;
  });
  
  
  //전체고객 불러오기
  var $customer = $(".customer").find(".allCustomer");
  $customer.click(function(){
    $.ajax({
      url:"selectAll.do",
      method:'GET',
      success:function(responseData){
        var result = responseData.trim();
        $parentObj.empty();
        
        $("article").html(responseData.trim());
      }
    }); return false;
  });
  
  
  
  
  //상품리스트 가져오기
    var $product =$(".product").find(".prodall");
    $product.click(function(){
      $.ajax({url: "productlist.do",
          method: 'GET', 
          success:function(responseData){
            $("article").empty();
            $("article").html(responseData.trim()); 
          }
      }); // end ajax
      return false;
    });   //end click
  
    
    
    
    //취소버튼 액션
    $("input[id=cancle]").click(function(){
      $("input[id=cancle]").closest("div").hide();
    });
    
    
   //첫 통계보내기 (고객별)
    var $stat = $(".statistics").find("span");
    $stat.click(function(){
        var stat = $(this).attr("class");
    console.log(stat);      
      $.ajax({
        url:"statistics.do",
        method:"post",
        data :{"stat":stat  
          },
        success:function(reseponseDate){
          $parentObj.empty();
          $parentObj.html(reseponseDate);
          
        }
      }); return false;  
    }); // end clickfunction
    
 
  
});




</script>

<style>

div.admin div{
border:1px solid;
border-color : #4682B4;
background-color: #F0F8FF;
height:300px;
width:300px;
font-family: sans-serif;
font-size: 12px;
text-align:center;
display: inline-block; 
padding: 1px;
margin: 5px;
display: inline-block;
float: left; 
}

.productmodify{
position: absolute; 
top:200px; 
left: 100px;
width : 500px;
height : 300px;
background-color: white;
border-color: #6495ED;
border : 1px solid;
padding: 10px;
}

span{
cursor:pointer;
border:1px solid;
border-color : #4682B4;
padding:2px;
display: inline-block;
margin: 5px
}

div.modadm{
height: 200px;
width: 350px;
border: 1px solid;
padding: 30px;
position: absolute; 
top:200px; 
left: 100px;
background-color: white;
}

.productmodify{display: none;}
.modadm{display: none;}
div.signup{display: none;} /* addadminform.jsp */

</style>




<article>
<jsp:include page="addadminform.jsp"></jsp:include>

<!-- 정보수정-->
  <div class="modadm">
  
   <form method="post">
   <h3>${adminLoginInfo.name}님 비밀번호 변경</h3>
      안전한 비밀번호로 내정보를 보호하세요<br>
   
      현재 비밀번호 : <input name="nowpwd" type="text" placeholder="기존 비밀번호를 입력"><br>
      새로운 비밀번호 : <input name="newpwd1" type="text" placeholder="새 비밀번호를 입력"><br>
      새로운 비밀번호 확인 : <input name="newpwd2" type="text" placeholder="새 비밀번호 다시한번 입력"><br>
   <input type="button" value="수정" id="modcus">
   <input type="button" value="취소" id="cancle">
   
  </form>
  </div>


<h4>안녕하세요 ${adminLoginInfo.name}님 반갑습니다.</h4>

<div class="admin"  
style="height: 650px; 
width: 650px ;
box-sizing: border-box;
display: inline-block ;
">

<c:set var="adminLoginInfo" value="${sessionScope.adminLoginInfo}"/>

<c:choose>
<c:when test="${adminLoginInfo != null}">


<div class="adminInfo">
<h1>관리자정보</h1>
  이름 : <span class="name">${adminLoginInfo.name}</span><br>
  아이디 : <span class="id">${adminLoginInfo.id}</span><br>
  <%-- 비밀번호 : <span class="password">${adminLoginInfo.password}</span> --%><br><br>
  <span class="logout" >로그아웃</span>
  &nbsp;&nbsp;
 <span class="modify">내정보수정</span>
  &nbsp;&nbsp;
  <c:if test="${adminLoginInfo.id eq 'admin'}">
  <br><span class="insert">관리자추가</span>
  <span class="alllist">모든 관리자list</span><br>
  </c:if>
</div>

<div class="product">
<h1>상품관리</h1>
<span class="prodall">상품보기</span><br>
<span class="insert">상품추가</span><br>
<!--<span class="modify">상품수정-구현전</span><br>    -->
</div>

<br>
<div class="customer">
<h1>고객관리</h1>
<span class="allCustomer">전체 고객 관리하기</span><br>
</div>



<div class="statistics">
<h1>통계</h1>
<span class="customer">관리 통계 보기</span><br>

</div>



</div>

<!-- 상품추가하기 -->  
<div class="productmodify">
            
  <form class="modifysubmit" method="post">
   상품번호 :<input id="no"  type="text" placeholder ="상품번호 입력"  maxlength="4"><br>
   상품명    :<input id="name"  type="text" placeholder ="상품명 입력" maxlength="20"><br>
   가격       :<input id="price"  type="text" placeholder ="상품 가격 입력"  maxlength="55"><br>
   <input id="submit"  type="submit" value="추가하기">
   <input id="cancle" type="button" value="취소하기">
  </form>
            
</div>



</c:when>
<c:otherwise>

관리자 페이지는 로그인 후 이용할 수 있습니다.
<a href="index.jsp">처음으로 가기</a>
</c:otherwise>
</c:choose>


</article>

<footer></footer>

</html>