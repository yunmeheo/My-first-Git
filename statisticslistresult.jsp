<% String contextPath=request.getContextPath();%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>
<%-- <%@ attribute name="best" required="true" type="java.lang.boolean"%> --%>


<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=UTF-8">
<title>statisticslistresult.jsp</title>
</head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script type="text/javascript">


//통계보내기

  $(function(){
  
    var $parentObj = $("article");
        if($parentObj.length == 0){
          $parentObj = $("body");
        }
        
        
    
    
    
    var $stat = $(".statistics").find("li");
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
    
             
      $("ul.parent").click(function(){
        $(this).find(".child").toggle();
          var best= $(this).attr('id');
              console.log("best :"+best);
      });
  });


</script>

<style>


 
.li_table{ display:block;  width:400px; border:1px solid #4682B4; border-top:none;border-bottom:none; border-right:none;}
.li_table ul{clear:left;  margin:0px; padding:0px;  list-style-type:none; border-top:1px solid #4682B4; }
.li_table ul.subject {font-weight:bold; text-align:center;}
.li_table ul li{width:97px ;text-align:center; float: left; margin:0px; padding: 2px 1px; border-right:1px solid #4682B4; }
.statistics li{text-decoration: underline; cursor:pointer;  font-size: small; }
/* .li_table ul li.col{width:98.5px; list-style-type:none;} */
ul.show{display:block;}
ul.hide{display: none;}
</style>

<body>

<div class = statistics>
<ul>
<li class="customer">고객별 많이 주문한 물품 - 주문건 1개일때 상세클릭 안됨 수정 예정</li>
<li class="product">상품별 많이 주문한 고객들</li>
<li class="daily">일자별 가장 많이 주문된 상품</li>
</ul>
</div>

<div class="li_table">


<c:set var="stat" value="${requestScope.stat}"/>  
    <ul class="subject"> 
    <c:if test="${'daily' eq stat}">
    <li class ="col">주문일자</li> 
    </c:if>
    
    <c:if test="${'customer' eq stat}">
    <li class ="col">주문자ID</li>
    </c:if>
    
    <li class ="col">주문상품번호</li>
    <li>상품이름</li>
   
    <c:if test="${'product' eq stat}">
    <li>주문자ID</li>
    </c:if>
    <li>상품수량</li>
    </ul>
    
    <!-- ★★ 고객별 통계 -->
    <c:if test="${'customer' eq stat}">
    <c:set var="list" value="${requestScope.list}"/>
       
       <c:forEach var="map"  items= "${list}" varStatus="status">   
         <c:choose>
         <c:when test="${empty map['LINE_PROD_NO']}"><!-- 상품번호가 없으면 -->
          <!-- status.index가 0보다 크면-->
         <c:if test="${status.index > 0}">
           </ul>
         </c:if>
         <!-- 총 행수가 1이상이라면 출력 -->
         <ul class="show parent" id='${status.index}'><!-- 하위태그 -->   
         <!-- 가장 아래 총계출력하기 -->
         <li style="<c:if  test="${empty map['ID']}"> color : red;">
         총 판매량</c:if><c:if  test="${!empty map['ID']}">">${map['ID']}</c:if></li>
         <!--만약 아이디의 값이 같을 경우 -->
         <li  style="<c:if  test="${empty map['LINE_PROD_NO']}"> color : red;">
        상세보기</c:if><c:if  test="${!empty map['LINE_PROD_NO']}">">${map['LINE_PROD_NO']}</c:if></li>
         <li > :${map['PROD_NAME']} </li>
         <li> ${map['SUM']} </li>
         </c:when>
         
         <c:otherwise>
         <!-- 하위내용출력하기 -->
         <ul class="hide child">  
         
         <!--총계출력하기 -->
         <li style="<c:if  test="${empty map['ID']}"> color : red;">
         총 판매량</c:if><c:if  test="${!empty map['ID']}">">${map['ID']}</c:if></li>
         <!--만약 아이디의 값이 같을 경우 -->
         
          
         <li style="<c:if  test="${empty map['LINE_PROD_NO']}"> color : red;">
         ${map['ID']}님의 통계</c:if><c:if  test="${!empty map['LINE_PROD_NO']}">">${map['LINE_PROD_NO']}</c:if></li>
         
         
         <c:set var="best" value="${requestScope.best}"/>
         <li>
         <c:choose>
         <c:when test="${status.index}==${status.index}">
         <img src ='best.png'>${map['PROD_NAME']} 
         </c:when>
         <c:otherwise>
         <img src ='best.png'>${map['PROD_NAME']} 
         </c:otherwise>
         </c:choose>
         </li>
         
         <li>${map['SUM']} </li>
          
         
         </ul>
         </c:otherwise>
       </c:choose>             
     </c:forEach> 
    </c:if> 
    
    
    
    <!-- ★★ 상품별 통계 -->
     <c:if test="${'product' eq stat}">
     <c:forEach var="orderInfo"  items= "${list}" varStatus="status"> 
     <c:forEach var="orderLine"  items= "${orderInfo.lines}" > 
        <c:choose>
          <c:when test="${empty orderLine.line_prod_no.prod_name}"><!-- 상품번호가 없으면 -->
           <!-- status.index가 0보다 크면-->
          <c:if test="${status.index > 0}">
            </ul>
          </c:if>
          <%-- lines : ${status.index} --%>
          <!-- 총 행수가 1이상이라면 출력 -->
          <ul class="show parent"><!-- 하위태그 -->   
          <!-- 가장 아래 총계출력하기 -->
          <%-- <li>${orderLine.line_prod_no.prod_no}</li> --%>
          <li style="<c:if  test="${empty orderLine.line_prod_no.prod_no}"> color : red;">
          총 판매량</c:if><c:if  test="${!empty orderLine.line_prod_no.prod_no}">">${orderLine.line_prod_no.prod_no}</c:if></li>
          <!--만약 아이디의 값이 같을 경우 -->
          <!-- 번호가 없을경우    --님의통계-- 출력-->
          <li style="<c:if  test="${empty orderLine.line_prod_no.prod_name}"> color : red;">
          상세클릭</c:if><c:if  test="${!empty orderLine.line_prod_no.prod_name}">">${orderLine.line_prod_no.prod_name}</c:if></li>
          <li> :${orderInfo.info_c.id}</li>
          <li> ${orderLine.line_quantity}</li>
          </c:when>
          <c:otherwise>
         
         <!-- 하위내용출력하기 -->
          <ul class="hide child">  
                        
          <!--총계출력하기 -->
          <li>${orderLine.line_prod_no.prod_no}</li>
           
         <!--만약 아이디의 값이 같을 경우 -->
         <li>${orderLine.line_prod_no.prod_name}</li>
         <li><img src ='best.png'>${orderInfo.info_c.id} </li>
         <li>${orderLine.line_quantity} </li>
         
         </ul>
        </c:otherwise>
       </c:choose>        
      </c:forEach>  
     </c:forEach> 
    </c:if>   
    
   <!-- ★★ 일자별 통계 -->
   <c:if test="${'daily' eq stat}">
   
   <c:forEach var="orderInfo"  items= "${list}" varStatus="status"> 
   <ul class="show parent">
   <li class ="col"><fmt:formatDate value="${orderInfo.info_date}" pattern="yyyy-MM-dd"/> </li>
   <c:choose>
   <c:when test="${fn:length(orderInfo.lines)>1}">  
   
        <li>${orderLine.line_prod_no.prod_no}</li>
        <li> ${orderLine.line_prod_no.prod_name}</li>
        <li> ${orderLine.line_quantity}</li>
        
    <c:forEach var="orderLine"  items= "${orderInfo.lines}" begin="1"  end="${fn:length(orderInfo.lines)}">
         
        <li>${orderLine.line_prod_no.prod_no}</li>
        <li> ${orderLine.line_prod_no.prod_name}</li>
        <li> ${orderLine.line_quantity}</li>
      </c:forEach>    
   </c:when> 
   <c:otherwise>
  	 <c:forEach var="orderLine"  items= "${orderInfo.lines}" begin="0"  end="${fn:length(orderInfo.lines)}"> 
        <li>${orderLine.line_prod_no.prod_no}</li>
        <li> ${orderLine.line_prod_no.prod_name}</li>
        <li> ${orderLine.line_quantity}</li>
     </c:forEach>   
   </c:otherwise>
   </c:choose>  
   </ul> 
   </c:forEach> 
  </c:if> 
  <ul></ul>
</div>   
</body>
</html>