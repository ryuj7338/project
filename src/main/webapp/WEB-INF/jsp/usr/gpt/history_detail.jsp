<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<!-- 폰트어썸 FREE 아이콘 리스트 : https://fontawesome.com/v5.15/icons?d=gallery&p=2&m=free -->

<!-- 테일윈드 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
<!-- 테일윈드 치트시트 : https://nerdcave.com/tailwind-cheat-sheet -->

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>GPT 대화 상세 보기</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">

<!-- 상단 메뉴바 -->
<nav class="bg-gray-800 text-white p-4 flex items-center">
  <div class="mr-10">
    <img src="/resource/images/logo.png" alt="경호 로고" class="h-8" />
  </div>
  <ul class="flex space-x-6 text-sm">
    <li><a href="/home" class="hover:text-gray-300">경호할래</a></li>
    <li><a href="/qualification" class="hover:text-gray-300">자격</a></li>
    <li><a href="/guide" class="hover:text-gray-300">안내</a></li>
    <li><a href="/job" class="hover:text-gray-300">취업</a></li>
    <li><a href="/info" class="hover:text-gray-300">정보</a></li>
    <li><a href="/community" class="hover:text-gray-300">커뮤니티</a></li>
    <li><a href="/resources" class="hover:text-gray-300">자료실</a></li>
  </ul>
</nav>

<div class="flex min-h-screen">

  <!-- 좌측 메뉴 -->
  <aside class="w-40 border-r p-6 bg-white">
    <h2 class="font-bold mb-6">기록</h2>
    <ul class="space-y-4 text-gray-700">
      <li><a href="/usr/gpt/history" class="hover:text-gray-900 font-semibold">GPT 대화 기록</a></li>
      <li><a href="/usr/gpt/interview" class="hover:text-gray-900">GPT 면접</a></li>
      <li><a href="/usr/gpt/cover" class="hover:text-gray-900">GPT 자기소개서</a></li>
    </ul>
  </aside>

  <!-- 메인 컨텐츠 -->
  <main class="flex-1 p-10 bg-gray-100">

    <div class="bg-white rounded-2xl p-8 shadow-md max-w-5xl mx-auto">
      <h1 class="text-2xl font-bold mb-6">${answer.category} 대화 기록 상세보기</h1>

      <div class="space-y-6">

        <div>
          <h3 class="font-semibold mb-1">질문</h3>
          <div class="p-4 bg-gray-50 rounded-lg whitespace-pre-wrap border border-gray-300">${answer.question}</div>
        </div>

        <div>
          <h3 class="font-semibold mb-1">답변</h3>
          <div class="p-4 bg-gray-50 rounded-lg whitespace-pre-wrap border border-gray-300">${answer.answer}</div>
        </div>

        <div class="text-gray-500 text-sm mt-4">
          <p>번호: ${answer.id}</p>
          <p>날짜: ${fn:substring(answer.regDate, 0, 10)}</p>
          <p>카테고리: ${answer.category}</p>
        </div>

        <div class="mt-6">
          <a href="/usr/gpt/history"
             class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-semibold px-6 py-2 rounded-lg">
            목록으로 돌아가기
          </a>
        </div>

      </div>
    </div>

  </main>
</div>

</body>
</html>
