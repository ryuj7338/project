<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<!-- 테일윈드 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">

<html>
<head>
  <title>법령 정보</title>
</head>
<body>
<h1>법령 정보 목록</h1>

<script>
  function validateSearch() {
    const keywordInput = document.getElementById("keyword");
    const keyword = keywordInput.value.trim();

    if (keyword.length === 0) {
      alert("검색어를 입력하세요.");
      keywordInput.focus();
      return false;
    }

    return true;
  }
</script>

<c:if test="${not empty message}">
  <script>
    alert("${message}");
  </script>
</c:if>

<!-- 검색창 및 자동완성 영역 -->
<form method="get" action="/usr/law/list" onsubmit="return validateSearch()" style="position: relative;">
  <input type="hidden" name="boardId" value="${board.id}" />
  <select name="searchType">
    <option value="title" ${searchType == 'title' ? 'selected' : ''}>법령명</option>
  </select>
  <input type="text" name="keyword" id="keyword" value="${keyword}" placeholder="검색어 입력" autocomplete="off" />
  <button type="submit">검색</button>

  <!-- 자동완성 결과 리스트 -->
  <ul id="autocompleteList" style="
    border:1px solid #ccc;
    display:none;
    position:absolute;
    background:#fff;
    max-height:150px;
    overflow-y:auto;
    width: 300px;
    padding: 0;
    margin: 0;
    list-style: none;
    z-index: 1000;
    top: 100%;
    left: 0;
  "></ul>
</form>

<!-- 법령 목록 출력 -->
<table border="1" style="width:100%; margin-top:20px;">
  <thead>
  <tr>
    <th>법령명</th>
    <th>공포번호</th>
    <th>공포일자</th>
    <th>법령구분명</th>
    <th>시행일자</th>
    <th>소관부처명</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="law" items="${lawList}">
    <tr>
      <td><a href="${law["법령상세링크"]}" target="_blank" class="no-underline text-black hover:text-blue-400 transition-colors duration-150">${law["법령명"]}</a></td>
      <td>${law["공포번호"]}</td>
      <td>${law["공포일자"]}</td>
      <td>${law["법령구분명"]}</td>
      <td>${law["시행일자"]}</td>
      <td>${law["소관부처명"]}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<!-- 페이징 처리 -->
<div style="margin-top: 20px;">
  <c:if test="${pageNo > 1}">
    <a href="?keyword=${keyword}&page=${pageNo - 1}&numOfRows=${numOfRows}">이전</a>
  </c:if>

  <c:forEach begin="1" end="${pagesCount}" var="i">
    <a href="?keyword=${keyword}&page=${i}&numOfRows=${numOfRows}"
       style="${i == pageNo ? 'font-weight: bold;' : ''}">${i}</a>
  </c:forEach>

  <c:if test="${pageNo < pagesCount}">
    <a href="?keyword=${keyword}&page=${pageNo + 1}&numOfRows=${numOfRows}">다음</a>
  </c:if>
</div>

<script>
  $(function() {
    const $input = $('#keyword');
    const $list = $('#autocompleteList');

    let timer;

    $input.on('input', function() {
      clearTimeout(timer);
      const keyword = $(this).val().trim();

      if (keyword.length === 0) {
        $list.hide().empty();
        return;
      }

      timer = setTimeout(() => {
        $.ajax({
          url: '/usr/autocomplete/law',  // 서버 자동완성 API 경로에 맞게 수정하세요
          method: 'GET',
          data: { keyword: keyword },
          dataType: 'json',
          success: function(data) {
            $list.empty();

            if(data.length === 0) {
              $list.hide();
              return;
            }

            data.forEach(item => {
              const $li = $('<li>').text(item).css({
                cursor: 'pointer',
                padding: '4px 8px',
                borderBottom: '1px solid #eee'
              });
              $li.on('click', function() {
                $input.val(item);
                $list.hide().empty();
              });
              $list.append($li);
            });

            $list.show();
          },
          error: function() {
            $list.hide().empty();
          }
        });
      }, 300);
    });

    $(document).on('click', function(e) {
      if(!$(e.target).closest('#keyword, #autocompleteList').length) {
        $list.hide().empty();
      }
    });
  });
</script>
<script>
  const $keyword = document.getElementById('keyword');
  const $list = document.getElementById('autocompleteList');

  $keyword.addEventListener('input', function () {
    const query = this.value.trim();
    if (query.length < 1) {
      $list.style.display = 'none';
      $list.innerHTML = '';
      return;
    }

    fetch(`/usr/autocomplete/law?keyword=${query}`)
            .then(res => res.json())
            .then(data => {
              if (data.length === 0) {
                $list.style.display = 'none';
                $list.innerHTML = '';
                return;
              }

              $list.innerHTML = data.map(item => `<li style="padding: 5px; cursor: pointer;">${item}</li>`).join('');
              $list.style.display = 'block';
            });
  });

  $list.addEventListener('click', function (e) {
    if (e.target.tagName === 'LI') {
      $keyword.value = e.target.textContent;
      $list.style.display = 'none';
      $list.innerHTML = '';
    }
  });

  document.addEventListener('click', function (e) {
    if (!e.target.closest('#autocompleteList') && e.target !== $keyword) {
      $list.style.display = 'none';
    }
  });
</script>


</body>
</html>
