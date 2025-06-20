<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<head>
  <link rel="stylesheet" href="/resource/common.css" />
  <script src="/resource/common.js" defer="defer"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
</head>

<c:set var="pageTitle" value="${board.code}" />
<%@ include file="../common/head.jspf"%>

<!-- 글쓰기 버튼 -->
<div class="join mt-10">
  <ul class="justify-center">
    <c:if test="${rq.isAdmin and boardId == 5}">
      <li><a class="hover:underline" href="../post/write?boardId=${boardId}">기출문제 등록</a></li>
    </c:if>
    <c:if test="${rq.isLogined and boardId != 5}">
      <li><a class="hover:underline" href="../post/write?boardId=${boardId}">글쓰기</a></li>
    </c:if>
  </ul>
</div>

<!-- 검색 폼 -->
<div class="text-center">
  <form action="../post/list?boardId=${boardId}" method="POST">
    <div class="inline-flex justify-center mx-auto border border-solid border-blue-400 p-3 rounded-lg">
      <select name="searchType" data-value="${param.searchType}">
        <option disabled selected>선택</option>
        <option value="title">제목</option>
        <option value="body">내용</option>
        <option value="nickname">작성자</option>
      </select>
      <div class="flex items-center">
        <input type="text" placeholder="검색어 입력" name="searchKeyword" value="${param.searchKeyword}" />
        <button type="submit">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="h-6 w-6 opacity-70">
            <path fill-rule="evenodd"
                  d="M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z"
                  clip-rule="evenodd" />
          </svg>
        </button>
      </div>
    </div>
  </form>
</div>

<!-- 게시글 목록 -->
<section class="mt-24 text-xl px-4">
  <div class="mx-auto">
    <table border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
      <thead>
        <tr>
          <th style="text-align: center;">ID</th>
          <th style="text-align: center;">제목</th>
          <th style="text-align: center;">작성자</th>
          <th style="text-align: center;">날짜</th>
          <th style="text-align: center;">조회수</th>
          <th style="text-align: center;">좋아요</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="post" items="${posts}">
          <tr>
            <td style="text-align: center;">${post.id}</td>
            <td style="text-align: center;">
              <a class="hover:underline" href="detail?id=${post.id}">${post.title}
                <c:if test="${post.extra__repliesCount > 0}">
                  <span style="color: red;">[${post.extra__repliesCount}]</span>
                </c:if>
              </a>
            </td>
            <td style="text-align: center;">${post.extra__writer}</td>
            <td style="text-align: center;">${post.regDate.substring(0,10)}</td>
            <td style="text-align: center;">${post.hit}</td>
            <td style="text-align: center;">${post.like}</td>
          </tr>
        </c:forEach>

        <c:if test="${empty posts}">
          <tr>
            <td colspan="6" style="text-align: center;">게시글이 없습니다.</td>
          </tr>
        </c:if>
      </tbody>
    </table>
  </div>
</section>

<!-- 페이징 -->
<div class="flex justify-center mt-20">
  <div class="btn-group join">
    <c:set var="paginationLen" value="3" />
    <c:set var="startPage" value="${page - paginationLen >= 1 ? page - paginationLen : 1}" />
    <c:set var="endPage" value="${page + paginationLen <= pagesCount ? page + paginationLen : pagesCount}" />

    <c:if test="${startPage > 1}">
      <a class="join-item btn btn-sm" href="?page=1&boardId=${boardId}">1</a>
    </c:if>

    <c:if test="${startPage > 2}">
      <button class="join-item btn btn-sm btn-disabled">...</button>
    </c:if>
