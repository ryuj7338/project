<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MAIN PAGE"></c:set>
<%@ include file="../common/head.jspf"%>

<body class="bg-gray-900 relative">


    <!-- 제이쿼리 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <!-- 폰트어썸 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- 폰트어썸 FREE 아이콘 리스트 : https://fontawesome.com/v5.15/icons?d=gallery&p=2&m=free -->

    <!-- 테일윈드 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
    <!-- 테일윈드 치트시트 : https://nerdcave.com/tailwind-cheat-sheet -->


    <div class="image_box">

    </div>

    <section class=" flex flex-col items-center">
        <div class="h-full news_box flex flex-col items-center">
            <div class="relative mt-20 text-3xl font-bold text-center z-10 py-2 text-gray-50 ">
                뉴스 소식
            </div>
            <div class=" w-full overflow-x-auto overflow-y-hidden whitespace-nowrap border border-solid border-8 border-blue-400 rounded-xl">
                <div class="flex w-max bg-white">
                    <div class="w-96 h-80 bg-red-400 m-4 flex-shrink-0">1111</div>
                    <div class="w-96 h-80 bg-red-400 m-4 flex-shrink-0">2222</div>
                    <div class="w-96 h-80 bg-red-400 m-4 flex-shrink-0">3333</div>
                    <div class="w-96 h-80 bg-red-400 m-4 flex-shrink-0">4444</div>
                    <div class="w-96 h-80 bg-red-400 m-4 flex-shrink-0">5555</div>
                    <div class="w-96 h-80 bg-red-400 m-4 flex-shrink-0">6666</div>
                </div>
            </div>
        </div>
    </section>

    <div>

    </div>

    <div class="bg-white border-black border"></div>



</body>


<%@ include file="../common/foot.jspf"%>