<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="자격증"/>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="flex flex-col min-h-screen bg-gray-50">
  <main class="flex-grow w-full py-40 px-4">
    <div class="bg-white shadow rounded-lg p-6 h-[calc(100vh-200px)] flex">
      <!-- 사이드 메뉴 -->
      <aside class="w-56 bg-gray-100 text-black p-4 rounded-lg shadow-inner overflow-y-auto">
        <h2 class="text-lg font-semibold mb-4">자격증 목록</h2>
        <div id="buttonContainer" class="space-y-2">
          <button onclick="load('경비지도사', this)" class="cert-btn block w-full text-left py-2 px-3 bg-gray-100 hover:bg-gray-200 rounded">
            경비지도사
          </button>
          <button onclick="load('신변보호사', this)" class="cert-btn block w-full text-left py-2 px-3 bg-gray-100 hover:bg-gray-200 rounded">
            신변보호사
          </button>
          <button onclick="load('소방안전관리자', this)" class="cert-btn block w-full text-left py-2 px-3 bg-gray-100 hover:bg-gray-200 rounded">
            소방안전관리자
          </button>
          <button onclick="load('위험물기능사', this)" class="cert-btn block w-full text-left py-2 px-3 bg-gray-100 hover:bg-gray-200 rounded">
            위험물기능사
          </button>
          <button onclick="load('산업보안관리사', this)" class="cert-btn block w-full text-left py-2 px-3 bg-gray-100 hover:bg-gray-200 rounded">
            산업보안관리사
          </button>
          <button onclick="load('TOEIC', this)" class="cert-btn block w-full text-left py-2 px-3 bg-gray-100 hover:bg-gray-200 rounded">
            TOEIC
          </button>
        </div>
      </aside>

      <!-- 상세 정보 -->
      <section id="detail" class="flex-1 pl-6 overflow-y-auto">
        <h3 id="title" class="text-2xl font-bold mb-4">자격증 정보</h3>
        <p class="mb-2"><strong>발급기관:</strong> <span id="issuingAgency"></span></p>
        <p class="mb-2"><strong>주관기관:</strong> <span id="organizingAgency"></span></p>
        <p class="mb-2"><strong>급수:</strong> <span id="grade"></span></p>
        <p class="mb-2"><strong>자격증 종류:</strong> <span id="type"></span></p>
        <p class="mb-4">
          <a id="applyUrl" href="#" target="_blank" class="text-blue-600 underline">
            접수 사이트 이동
          </a>
        </p>
        <div id="extraContent" class="prose prose-sm text-gray-700"></div>
      </section>
    </div>
  </main>

  <script>
    const data = {
      "경비지도사": {
        issuingAgency: "한국산업인력공단",
        organizingAgency: "경찰청 생활안전과",
        grade: "일반 / 기계",
        type: "국가공인자격",
        url: "https://www.q-net.or.kr/man001.do?gSite=Q&gId=09",
        content: `
          <h4 class="mt-4 font-semibold">응시자격</h4><p>만 18세 이상</p>
          <h4 class="mt-2 font-semibold">시험과목</h4>
          <ul class="list-disc pl-5">
            <li>1차: 법학개론, 민간경비론</li>
            <li>2차: 경비업법, 소방학/범죄학/경호학</li>
          </ul>
          <h4 class="mt-2 font-semibold">시험일정</h4><p>9.22 ~ 9.26 / 11.15 / 12.31</p>
        `
      },
      "신변보호사": {
        issuingAgency: "(사)한국경비협회",
        organizingAgency: "(사)한국경비협회",
        grade: "-",
        type: "국가공인 민간자격",
        url: "https://www.ksan.or.kr/test/offer.do",
        content: `<p>응시자격: 제한 없음</p><p>시험: 상시 시험</p>`
      },
      "소방안전관리자": {
        issuingAgency: "한국소방안전원",
        organizingAgency: "소방청",
        grade: "1급 / 2급 / 3급",
        type: "국가전문자격",
        url: "https://www.kfsi.or.kr/mobile/exam/ExamApplyList.do",
        content: `<p>응시자격: 제한 없음</p><p>시험일정: 기관별 수시 시행</p>`
      },
      "위험물기능사": {
        issuingAgency: "소방청",
        organizingAgency: "소방청",
        grade: "-",
        type: "국가기술자격",
        url: "https://www.q-net.or.kr/rcv001.do?id=rcv00103&gSite=Q",
        content: `<p>응시자격: 제한 없음</p><p>시험일정: 연 4회 시행</p>`
      },
      "산업보안관리사": {
        issuingAgency: "(사)한국산업기술보호협회",
        organizingAgency: "(사)한국산업기술보호협회",
        grade: "-",
        type: "국가공인 자격",
        url: "https://license.kaits.or.kr/web/main.do?screenTp=USER",
        content: `<p>응시자격: 누구나 가능</p><p>시험일정: 연 1회</p>`
      },
      "TOEIC": {
        issuingAgency: "한국TOEIC위원회",
        organizingAgency: "한국TOEIC위원회",
        grade: "-",
        type: "국가공인 민간 자격",
        url: "https://m.exam.toeic.co.kr/receipt/receiptStep1.php",
        content: `<p>시험과목: LC/RC</p><p>시험일정: 매주 일요일</p>`
      }
    };

    function load(name, btn) {
      const item = data[name];
      if (!item) return;
      document.querySelectorAll('.cert-btn').forEach(b => {
        b.classList.replace('bg-gray-300','bg-gray-100');
      });
      btn.classList.replace('bg-gray-100','bg-gray-300');
      document.getElementById('title').textContent = name;
      document.getElementById('issuingAgency').textContent = item.issuingAgency;
      document.getElementById('organizingAgency').textContent = item.organizingAgency;
      document.getElementById('grade').textContent = item.grade;
      document.getElementById('type').textContent = item.type;
      document.getElementById('applyUrl').href = item.url;
      document.getElementById('extraContent').innerHTML = item.content;
    }

    window.onload = () => {
      const btn = document.querySelector('.cert-btn');
      if (btn) btn.click();
    };
  </script>

  <%@ include file="../common/foot.jspf" %>
</body>
</html>
