<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>경호 사이트</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="/resource/common.css" />
    <script src="/resource/common.js" defer></script>

    <!-- jQuery -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <!-- FontAwesome -->
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
    />

    <!-- Tailwind CSS -->
    <link
            href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css"
            rel="stylesheet"
    />

    <style>
        /* 상위 요소 overflow visible 중요 */
        header, nav, #alertContainer {
            overflow: visible !important;
        }
    </style>
</head>
<body>
<header>
    <div class="flex h-16 items-center bg-white w-full max-w-full px-6">
        <!-- 로고 -->
        <a href="/" class="flex items-center space-x-2">
            <img
                    class="w-16 h-16"
                    src="https://velog.velcdn.com/images/ryuj7338/post/b891e272-de6f-4c1e-b605-b3b733f58f87/image.png"
                    alt="Logo"
            />
            <span class="font-bold text-xl text-gray-800">경호</span>
        </a>

        <!-- 메뉴바 -->
        <nav class="flex-grow">
            <ul
                    class="flex justify-center space-x-8 text-gray-700 font-semibold h-full items-center"
            >
                <li class="group relative">
                    <a href="#" class="hover:text-indigo-600">자격</a>
                    <ul
                            class="absolute left-0 top-full mt-1 bg-white shadow-lg rounded-md border border-gray-200 opacity-0 group-hover:opacity-100 pointer-events-none group-hover:pointer-events-auto transition-opacity duration-200 min-w-[160px] z-50"
                    >
                        <li><a href="#" class="block px-4 py-2 hover:bg-indigo-50">자격 요건</a></li>
                        <li><a href="#" class="block px-4 py-2 hover:bg-indigo-50">자격증</a></li>
                        <li><a href="#" class="block px-4 py-2 hover:bg-indigo-50">대학</a></li>
                    </ul>
                </li>
                <!-- ... 기타 메뉴 ... -->
            </ul>
        </nav>

        <!-- 우측 아이콘 및 알림 -->
        <div id="alertContainer" class="relative flex items-center space-x-6 ml-8">
            <!-- 알림 버튼 -->
            <button
                    id="alertBtn"
                    class="text-gray-600 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500 relative"
                    type="button"
            >
                <i class="fa-regular fa-bell fa-lg"></i>
                <span
                        id="alertBadge"
                        class="absolute top-0 right-0 inline-flex items-center justify-center px-1 py-0.5 text-xs font-bold leading-none text-white bg-red-600 rounded-full"
                >3</span>
            </button>

            <!-- 사용자 아이콘 -->
            <a href="/usr/member/login" class="text-gray-600 hover:text-gray-900">
                <i class="fa-regular fa-user fa-lg"></i>
            </a>
            <a href="/usr/member/logout" class="text-gray-600 hover:text-gray-900">
                <i class="fa-solid fa-right-from-bracket fa-lg"></i>
            </a>

            <!-- 알림 드롭다운 -->
            <div id="alertDropdown"
                 class="hidden absolute right-0 w-80 bg-white rounded-md shadow-lg overflow-auto max-h-96 z-50 border border-gray-300"
                 style="top: 100%; margin-top: 0.5rem;">
                <ul id="alertList" class="divide-y divide-gray-200 p-0 m-0 list-none">
                    <!-- AJAX로 알림 리스트 채워짐 -->
                </ul>
                <div class="text-center p-2 border-t">
                    <a href="/usr/notifications/list" class="text-blue-600 hover:underline">전체 알림 보기</a>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    $(function () {
        // 알림 버튼 클릭시 드롭다운 토글
        $('#alertBtn').on('click', function (e) {
            e.stopPropagation();
            const $dropdown = $('#alertDropdown');

            if ($dropdown.is(':visible')) {
                $dropdown.hide();
            } else {
                // AJAX로 최근 알림 가져오기
                $.ajax({
                    url: '/usr/notifications/recent',
                    method: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        const $list = $('#alertList');
                        $list.empty();

                        if (data.length === 0) {
                            $list.append(
                                '<li class="p-4 text-center text-gray-500">새 알림이 없습니다.</li>'
                            );
                        } else {
                            data.forEach((alert) => {
                                $list.append(`
                                    <li class="p-4 hover:bg-gray-100 cursor-pointer" onclick="location.href='${alert.link}'">
                                        <div class="font-semibold">${alert.title}</div>
                                        <div class="text-xs text-gray-500">${alert.timeAgo}</div>
                                    </li>
                                `);
                            });
                        }
                        $dropdown.show();
                    },
                    error: function (xhr) {
                        const $list = $('#alertList');
                        $list.empty();

                        if (xhr.status === 401) {
                            $list.append(
                                '<li class="p-4 text-center text-gray-500">로그인 후 확인하세요.</li>'
                            );
                        } else {
                            $list.append(
                                '<li class="p-4 text-center text-red-500">알림을 불러오는 중 오류가 발생했습니다.</li>'
                            );
                        }
                        $dropdown.show();
                    },
                });
            }
        });

        // 외부 클릭시 드롭다운 닫기
        $(document).on('click', function () {
            $('#alertDropdown').hide();
        });
    });
</script>
</body>
</html>
