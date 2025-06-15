<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>실시간 채용공고</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        .job-box {
            border: 1px solid #ccc;
            padding: 16px;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        .job-box h2 {
            margin: 0 0 10px 0;
        }
        .job-box p {
            margin: 4px 0;
        }
    </style>
</head>
<body>
<h1>실시간 JobKorea 채용공고</h1>

<c:if test="${empty jobPostings}">
    <p style="color: red;">채용공고가 없습니다. 😢</p>
</c:if>

<c:forEach var="job" items="${jobPostings}">
    <div class="job-box">
        <h2>공고번호: ${job.gno}</h2>
        <p><strong>직무 코드:</strong> ${job.duty}</p>
        <p><strong>카테고리:</strong> ${job.dutyCtgr}</p>
        <p><strong>시작일:</strong> ${job.startDate}</p>
        <p><strong>마감일:</strong> ${job.deadline}</p>
        <p><strong>우대 자격증:</strong>
            <c:choose>
                <c:when test="${not empty job.certificates}">
                    <c:forEach var="cert" items="${job.certificates}">
                        ${cert}<c:if test="${!cert.equals(job.certificates[job.certificates.size() - 1])}">, </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>없음</c:otherwise>
            </c:choose>
        </p>
        <p><a href="${job.link}" target="_blank">공고 보러가기 🔗</a></p>
    </div>
</c:forEach>

</body>
</html>
