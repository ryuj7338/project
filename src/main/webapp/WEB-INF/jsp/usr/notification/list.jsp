<%@ page contentType="text/html; charset=UTF-8" %>
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
            border-bottom: 1px solid #ccc;
            padding: 10px 0;
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
        <c:forEach var="n" items="${notifications}">
            <div class="p-3 border-b">
                <a href="${n.link}">${n.title}</a>
                <div style="font-size: 12px; color: gray;">${n.regDate}</div>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>

<c:forEach var="noti" items="${notifications}">
    <div class="noti">
        <a href="${noti.link}" target="_blank">${noti.title}</a>
        <div style="font-size: 12px; color: gray;">${noti.regDate}</div>
    </div>
</c:forEach>


</body>
</html>
