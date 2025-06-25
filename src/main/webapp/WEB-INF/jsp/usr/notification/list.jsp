<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<div class="max-w-3xl mx-auto mt-10 p-6 bg-white rounded shadow-md">
    <div class="flex justify-between items-center mb-4">
        <h1 class="text-xl font-bold">🔔 알림 목록</h1>
        <form method="post" action="/usr/notifications/markAllAsRead" onsubmit="return confirm('모든 알림을 읽음 처리할까요?')">
            <button type="submit" class="text-sm bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600">
                모두 읽음 처리
            </button>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty notifications}">
            <div class="text-center text-gray-500">📭 알림이 없습니다.</div>
        </c:when>
        <c:otherwise>
            <ul class="space-y-4">
                <c:forEach var="n" items="${notifications}">
                    <li class="p-4 border rounded-md shadow-sm ${n.read ? 'bg-gray-100' : 'bg-white'}">
                        <a href="${n.link}" class="block hover:underline">
                            <div class="font-semibold text-gray-800">${n.title}</div>
                            <div class="text-sm text-gray-500 mt-1">
                                <fmt:formatDate value="${n.regDate}" pattern="yyyy.MM.dd (E) HH:mm" />
                            </div>
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </c:otherwise>
    </c:choose>
</div>

