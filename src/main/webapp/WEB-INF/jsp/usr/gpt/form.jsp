
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
    <title>${category} GPT 피드백</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">

<!-- 상단 네비게이션 바 -->
<header class="bg-gray-800 text-white flex items-center px-6 h-14">
    <div class="flex items-center space-x-6">
        <a href="/" class="flex items-center space-x-2 hover:opacity-80">
            <img src="/resource/img/logo.png" alt="로고" class="w-8 h-8" />
            <span class="font-semibold text-lg">경호</span>
        </a>
        <nav class="flex space-x-6">
            <a href="/intro" class="hover:underline">경호할래</a>
            <a href="/qualifications" class="hover:underline">자격</a>
            <a href="/guide" class="hover:underline">안내</a>
            <a href="/job" class="hover:underline">취업</a>
            <a href="/info" class="hover:underline">정보</a>
            <a href="/community" class="hover:underline">커뮤니티</a>
            <a href="/resources" class="hover:underline">자료실</a>
        </nav>
    </div>
</header>

<div class="flex flex-1">

    <!-- 좌측 사이드 메뉴 -->
    <aside class="w-40 border-r p-6 bg-white pt-24">
        <h2 class="font-bold mb-6"></h2>
        <ul class="space-y-4 text-gray-700">
            <li><a href="/usr/gpt/history" class="hover:text-gray-900 font-semibold">GPT 대화 기록</a></li>
            <li><a href="/usr/gpt/interview" class="hover:text-gray-900">GPT 면접</a></li>
            <li><a href="/usr/gpt/cover" class="hover:text-gray-900">GPT 자기소개서</a></li>
        </ul>
    </aside>

    <!-- 메인 콘텐츠 영역 -->
    <main class="flex-1 p-10 bg-gray-50 pt-32">
        <div class="max-w-4xl mx-auto bg-white p-8 rounded-2xl shadow-md flex flex-col">

            <h2 class="text-3xl font-semibold mb-8 text-gray-800">${category} GPT</h2>

            <!-- 응답 영역 -->
            <div id="response-box" class="min-h-[400px] bg-gray-200 rounded-xl p-6 text-base text-gray-700 whitespace-pre-wrap overflow-y-auto mb-8">
                GPT와의 대화 결과가 여기에 표시됩니다.
            </div>

            <!-- 입력창 -->
            <div class="flex items-center bg-gray-200 rounded-full px-6 py-3">
                <input id="user-input" type="text" placeholder="메시지를 입력하세요"
                       class="flex-1 bg-transparent focus:outline-none text-base px-4 py-2" />
                <button id="send-btn" class="ml-4 w-10 h-10 rounded-full bg-black text-white flex items-center justify-center hover:bg-gray-800">
                    ▶
                </button>
            </div>

        </div>
    </main>

</div>

<script>
    // 기존 코드 유지

    const category = "${category}";

    async function checkLogin() {
        const res = await fetch("/usr/gpt/checkLogin", {
            headers: { "Accept": "application/json" }
        });
        const result = await res.json();
        if (result.resultCode === "F-L") {
            alert(result.msg || "로그인이 필요합니다.");
            location.href = "/usr/member/login?redirectUrl=" + encodeURIComponent(location.pathname);
            return false;
        }
        return true;
    }

    window.addEventListener("DOMContentLoaded", async () => {
        await checkLogin();

        // 여기서 엔터키 이벤트 추가
        const userInput = document.getElementById("user-input");
        const sendBtn = document.getElementById("send-btn");

        userInput.addEventListener("keydown", function(event) {
            if (event.key === "Enter" && !event.shiftKey) {
                event.preventDefault(); // 줄바꿈 방지
                sendBtn.click();        // 전송 버튼 클릭 이벤트 호출
            }
        });
    });

    // 기존 send-btn 클릭 이벤트 핸들러 유지
    document.getElementById("send-btn").addEventListener("click", async () => {
        const input = document.getElementById("user-input").value.trim();
        if (!input){
            alert("메시지를 입력하세요");
            return;
        }

        const loggedIn = await checkLogin();
        if (!loggedIn) return;

        const responseBox = document.getElementById("response-box");
        responseBox.innerHTML += `\n👤 ${input}`;

        const res = await fetch("/usr/gpt/ask", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify({ message: input, category: category })
        });

        const result = await res.json();

        if (result.resultCode === "F-L") {
            alert(result.msg || "로그인이 필요합니다.");
            location.href = "/usr/member/login?redirectUrl=" + encodeURIComponent(location.pathname);
            return;
        }

        const answer = result.data1.answer;
        const id = "ans-" + Date.now();

        responseBox.innerHTML += `
        <div id="${id}" class="mt-2 mb-4">
            🤖 ${answer}
            <button onclick="getFeedback('${id}', \`${answer}\`, \`${input}\`)"
                    class="ml-2 text-xs text-blue-600 underline hover:text-blue-800">[피드백 보기]</button>
            <div class="text-sm text-green-700 mt-1 hidden" id="${id}-feedback"></div>
        </div>
        `;

        await fetch("/usr/gpt/save", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ question: input, answer: answer, category: category })
        });

        document.getElementById("user-input").value = "";
        responseBox.scrollTop = responseBox.scrollHeight;
    });

    // getFeedback 함수는 그대로 유지
</script>

</body>
</html>
