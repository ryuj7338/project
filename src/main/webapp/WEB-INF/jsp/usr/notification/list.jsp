<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>알림함</title>
    <style>
        body {
            font-family: sans-serif;
            padding: 20px;
            font-size: 14px;
        }

        .noti {
            padding: 10px 0;
            border-bottom: 1px solid #ccc;
        }

        .noti.read {
            background-color: #f4f4f4;
            color: gray;
        }

        .noti a {
            text-decoration: none;
            color: #333;
        }

        .noti.read a {
            color: #888;
        }

        .noti-time {
            font-size: 12px;
            color: #888;
        }
    </style>
</head>
<body>

<h3>📢 알림함</h3>

<c:choose>
    <c:when test="${empty notifications}">
        <p>📭 알림이 없습니다.</p>
    </c:when>
    <c:otherwise>
    <c:forEach var="noti" items="${notifications}">
        <div class="noti">
            <c:if test='${noti.read}'> read</c:if>

            <a href="${noti.link}" target="_blank">${noti.title}</a>
            <div class="noti-time">${noti.regDate}</div>
        </div>
    </c:forEach>
    </c:otherwise>
</c:choose>

</body>
</html>
