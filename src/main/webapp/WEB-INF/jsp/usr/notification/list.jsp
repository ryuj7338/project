<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>전체 알림</title>
    <link rel="stylesheet" href="/resource/common.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
</head>
<body>
<h1>전체 알림</h1>

<table class="min-w-full border">
    <thead>
    <tr class="bg-gray-200">
        <th class="border px-4 py-2">알림 제목</th>
        <th class="border px-4 py-2">발생 시간</th>
        <th class="border px-4 py-2">읽음 여부</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="notification" items="${notifications}">
        <tr class="cursor-pointer hover:bg-gray-100" onclick="location.href='${notification.link}&notificationId=${notification.id}'">
            <td class="border px-4 py-2">${notification.title}</td>
            <td class="border px-4 py-2">
                <fmt:formatDate value="${notification.regDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
            </td>
            <td class="border px-4 py-2">
                <c:choose>
                    <c:when test="${notification.read}">
                        읽음
                    </c:when>
                    <c:otherwise>
                        안읽음
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty notifications}">
        <tr>
            <td colspan="3" class="text-center p-4">알림이 없습니다.</td>
        </tr>
    </c:if>
    </tbody>
</table>
</body>
</html>
