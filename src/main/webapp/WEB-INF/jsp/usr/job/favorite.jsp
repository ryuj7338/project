<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<!-- 폰트어썸 FREE 아이콘 리스트 : https://fontawesome.com/v5.15/icons?d=gallery&p=2&m=free -->

<!-- 테일윈드 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
<!-- 테일윈드 치트시트 : https://nerdcave.com/tailwind-cheat-sheet -->
<%@ include file="../common/head.jspf" %>

<h1 class="text-2xl font-bold mb-4">내 찜한 채용공고</h1>

<c:choose>
  <c:when test="${empty favoriteJobs}">
    <p class="text-gray-600">찜한 공고가 없습니다.</p>
  </c:when>
  <c:otherwise>
    <table class="table-auto w-full border border-gray-300">
      <thead>
        <tr class="bg-gray-200">
          <th class="px-4 py-2">공고 제목</th>
          <th class="px-4 py-2">기업명</th>
          <th class="px-4 py-2">마감일</th>
          <th class="px-4 py-2">D-Day</th>
          <th class="px-4 py-2">링크</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="job" items="${favoriteJobs}">
          <tr class="border-t text-center">
            <td class="px-4 py-2">${job.title}</td>
            <td class="px-4 py-2">${job.companyName}</td>
            <td class="px-4 py-2">${job.endDate}</td>
            <td class="px-4 py-2">
              <c:choose>
                <c:when test="${job.dday == -1}">
                  상시채용
                </c:when>
                <c:when test="${job.dday == 0}">
                  D-Day
                </c:when>
                <c:when test="${job.dday > 0}">
                  D-${job.dday}
                  </c:when>
                <c:otherwise>
                  마감
                </c:otherwise>
              </c:choose>
            </td>
            <td class="px-4 py-2">
              <a href="${job.originalUrl}" target="_blank" class="text-blue-600 hover:underline">공고 보기</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:otherwise>
</c:choose>

<%@ include file="../common/foot.jspf" %>
