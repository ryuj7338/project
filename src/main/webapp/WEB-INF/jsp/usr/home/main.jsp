<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value=""></c:set>
<%@ include file="../common/head.jspf" %>

<body class="bg-gray-900 text-gray-50 min-h-screen">

  <!-- 메인 이미지 영역 -->
  <section class="flex justify-center space-x-4 mt-8 max-w-6xl mx-auto">
    <img src="/path/to/image1.jpg" alt="경호 이미지1" class="w-1/2 h-64 object-cover rounded-lg shadow-lg" />
    <img src="/path/to/image2.jpg" alt="경호 이미지2" class="w-1/2 h-64 object-cover rounded-lg shadow-lg" />
  </section>

  <!-- 최신 뉴스 -->
  <section class="max-w-6xl mx-auto mt-12 text-center">
    <h2 class="text-xl font-semibold mb-4">최신 뉴스</h2>
    <div class="bg-gray-700 rounded-lg h-48 animate-pulse"></div>
  </section>

  <!-- 하단 정보 영역 -->
  <section class="max-w-6xl mx-auto mt-10 grid grid-cols-3 gap-6 px-4">

    <!-- 왼쪽 -->
    <div class="space-y-6">
      <div>
        <h3 class="font-semibold mb-2">채용 정보</h3>
        <div class="bg-gray-700 rounded-lg h-32 animate-pulse"></div>
      </div>

      <div>
        <h3 class="font-semibold mb-2">자격증 정보</h3>
        <div class="bg-gray-700 rounded-lg h-32 animate-pulse"></div>
      </div>
    </div>

    <!-- 오른쪽 상단 -->
    <div>
      <h3 class="font-semibold mb-2">커뮤니티</h3>
      <div class="bg-gray-700 rounded-lg h-40 animate-pulse"></div>
    </div>

    <!-- 오른쪽 하단 -->
    <div>
      <h3 class="font-semibold mb-2">자료실</h3>
      <div class="bg-gray-700 rounded-lg h-72 animate-pulse"></div>
    </div>

  </section>

</body>

<%@ include file="../common/foot.jspf" %>
