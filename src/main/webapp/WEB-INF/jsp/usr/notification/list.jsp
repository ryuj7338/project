<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    .notification-item {
        padding: 1rem;
        margin-bottom: 0.5rem;
        border: 1px solid #ddd;
        border-radius: 8px;
        transition: background-color 0.3s, color 0.3s;
    }

    .notification-item.unread {
        background-color: #ffffff;
        color: #000000;
    }

    .notification-item.read {
        background-color: #f5f5f5;
        color: #888888;
    }

    .notification-item a {
        text-decoration: none;
        display: block;
        width: 100%;
    }
</style>

<h3>📢 알림함</h3>

<div class="notification-list">
    <c:choose>
        <c:when test="${empty notifications}">
            <p>📭 알림이 없습니다.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="noti" items="${notifications}">
                <div class="notification-item ${noti.read ? 'read' : 'unread'}">
                    <a href="${noti.link}" data-id="${noti.id}" class="notification-link">
                            ${noti.title}
                    </a>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<script>
    document.querySelectorAll('.notification-link').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();

            const id = this.dataset.id;
            const targetUrl = this.href;
            const itemDiv = this.closest('.notification-item');

            fetch('/usr/notifications/markAsRead?id=' + id, {
                method: 'POST'
            }).then(() => {
                itemDiv.classList.remove('unread');
                itemDiv.classList.add('read');
                window.location.href = targetUrl;
            });
        });
    });
</script>
