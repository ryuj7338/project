<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../common/head.jspf" %>

<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="bg-gray-50 min-h-screen flex flex-col">

<!-- 💡 숨겨진 카테고리 전달용 -->
<span id="category-data" style="display:none;"><c:out value="${category}"/></span>

<div class="flex flex-1 max-w-7xl w-full mx-auto py-16 px-8">
    <!-- 사이드 메뉴 -->
    <aside class="w-64 flex-shrink-0 bg-white rounded-xl shadow-md p-8 mr-8 min-h-[640px] h-fit">
        <nav class="space-y-2 mt-12">
            <a href="${ctx}/usr/gpt/interview"
               class="block px-4 py-3 rounded-lg font-semibold text-lg transition
               ${category == '면접' ? 'bg-blue-500 text-white' : 'hover:bg-blue-100 text-gray-900'}">
                면접 GPT
            </a>
            <a href="${ctx}/usr/gpt/resume"
               class="block px-4 py-3 rounded-lg font-semibold text-lg transition
               ${category == '자기소개서' ? 'bg-blue-500 text-white' : 'hover:bg-blue-100 text-gray-900'}">
                자기소개서 GPT
            </a>
            <a href="${ctx}/usr/gpt/history"
               class="block px-4 py-3 rounded-lg font-semibold text-lg transition
               ${category == '대화 기록' ? 'bg-blue-500 text-white' : 'hover:bg-blue-100 text-gray-900'}">
                대화 기록
            </a>
        </nav>
    </aside>

    <!-- 메인 영역 -->
    <main class="flex-1 bg-white rounded-xl shadow-md p-12 min-h-[640px] flex flex-col">
        <h2 class="text-3xl font-bold mb-7 text-gray-900">
            <c:out value="${category}"/> GPT
        </h2>

        <c:if test="${category eq '면접'}">
            <div class="mb-8 text-base text-gray-800 bg-blue-50 border border-blue-300 p-5 rounded-xl">
                🎤 <span class="font-bold">면접 GPT 안내</span><br>
                이 기능은 경호 분야의 실전 면접을 대비하기 위한 GPT 면접 코칭 도구입니다.<br>
                자주 나오는 질문에 답해보고, <b>논리성, 직무 적합성, 개선점</b>을 피드백 받으세요.
            </div>
        </c:if>
        <c:if test="${category eq '자기소개서'}">
            <div class="mb-8 text-base text-gray-800 bg-yellow-50 border border-yellow-300 p-5 rounded-xl">
                📝 <span class="font-bold">자기소개서 GPT 안내</span><br>
                경호 직무에 지원하는 자기소개서를 <b>자연스럽고 논리적으로 다듬고</b>, <b>부족한 부분을 개선</b>할 수 있도록 도와줍니다.
            </div>
        </c:if>

        <!-- 결과창 -->
        <div id="response-box"
             class="min-h-[320px] bg-gray-100 rounded-xl p-6 text-base text-black border border-red-400 whitespace-pre-wrap overflow-y-auto mb-8">
            GPT와의 대화 결과가 여기에 표시됩니다.
        </div>
        <div id="loading" class="text-sm text-gray-600 mt-2 hidden">🤖 GPT 응답을 생성 중입니다...</div>
        <p class="text-xs text-gray-500 mb-2 ml-2">💬 Enter 입력 시 전송됩니다</p>
        <div class="flex items-center justify-between">
            <button onclick="document.getElementById('response-box').innerHTML='';"
                    class="text-xs text-gray-600 hover:text-red-600 underline">
                🗑️ 대화 지우기
            </button>
        </div>

        <!-- 입력창 -->
        <div class="flex items-center bg-gray-200 rounded-full px-6 py-4 mt-5">
            <textarea id="user-input" placeholder="메시지를 입력하세요" rows="1"
                      class="flex-1 bg-transparent focus:outline-none text-base px-4 py-2 resize-none overflow-hidden"></textarea>
            <button id="send-btn"
                    class="ml-4 w-12 h-12 rounded-full bg-black text-white flex items-center justify-center hover:bg-gray-800 text-xl">
                ▶
            </button>
        </div>
    </main>
</div>

<!-- JS 스크립트 -->
<script>
    document.addEventListener("DOMContentLoaded", async () => {
        const userInput = document.getElementById("user-input");
        const sendBtn = document.getElementById("send-btn");
        const responseBox = document.getElementById("response-box");
        const category = document.getElementById("category-data").textContent.trim();

        // 자동 높이
        userInput.addEventListener("input", function () {
            this.style.height = "auto";
            this.style.height = this.scrollHeight + "px";
        });

        // Enter 키
        userInput.addEventListener("keydown", function (event) {
            if (event.key === "Enter" && !event.shiftKey) {
                event.preventDefault();
                sendBtn.click();
            }
        });

        // 응답 출력
        function appendMessage(question, answer, id) {
            const userDiv = document.createElement("div");
            userDiv.style.cssText = "color:black; background:#fffbe6; padding:8px; margin-bottom:6px;";
            userDiv.textContent = "👤 " + question;

            const gptDiv = document.createElement("div");
            gptDiv.style.cssText = "color:#006400; background:#f0fff4; padding:8px; margin-bottom:8px;";
            gptDiv.innerHTML = "🤖 " + answer.replace(/\n/g, "<br>");

            const feedbackBtn = document.createElement("button");
            feedbackBtn.textContent = "[피드백 보기]";
            feedbackBtn.style = "font-size:12px; color:blue; margin-left:8px;";
            feedbackBtn.addEventListener("click", () => getFeedback(id, answer));

            const feedbackBox = document.createElement("div");
            feedbackBox.id = `${id}-feedback`;
            feedbackBox.style = "display:none; margin-top:4px;";

            gptDiv.appendChild(feedbackBtn);
            gptDiv.appendChild(feedbackBox);

            responseBox.appendChild(userDiv);
            responseBox.appendChild(gptDiv);
        }

        // 피드백 처리
        async function getFeedback(id, answer) {
            const box = document.getElementById(`${id}-feedback`);
            if (!box) return;

            if (box.style.display === "block") {
                box.style.display = "none";
                return;
            }

            box.style.display = "block";
            box.innerHTML = "🤔 피드백 생성 중...";

            try {
                const res = await fetch("/usr/gpt/feedback", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({answer})
                });

                const result = await res.json();
                if (result.resultCode === "S-1") {
                    box.innerHTML = "💡 피드백: " + result.data1.feedback.replace(/\n/g, "<br>");
                } else {
                    box.innerHTML = "❌ 피드백 실패: " + result.msg;
                }
            } catch (e) {
                box.innerHTML = "⚠️ 오류 발생: " + e.message;
            }
        }

        // GPT 요청
        sendBtn.addEventListener("click", async () => {
            const input = userInput.value.trim();
            if (!input) {
                alert("메시지를 입력하세요");
                return;
            }

            const id = "ans-" + Date.now();
            document.getElementById("loading").classList.remove("hidden");

            let answer = "[GPT 응답 실패]";
            try {
                const res = await fetch("/usr/gpt/ask", {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({message: input, category})
                });

                const result = await res.json();
                if (result.resultCode === "S-1") {
                    answer = result.data1.answer;
                }
            } catch (e) {
                console.error("GPT 응답 오류:", e);
            }

            appendMessage(input, answer, id);

            await fetch("/usr/gpt/save", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({question: input, answer, category})
            });

            document.getElementById("loading").classList.add("hidden");
            userInput.value = "";
            userInput.style.height = "auto";
            responseBox.scrollTop = responseBox.scrollHeight;
        });
    });
</script>

<%@ include file="../common/foot.jspf" %>
</body>
</html>
