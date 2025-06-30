// ✅ select 기본값 처리 (그대로 유지)
$('select[data-value]').each(function (index, el) {
    const $el = $(el);
    const defaultValue = $el.attr('data-value')?.trim();
    if (defaultValue?.length > 0) {
        $el.val(defaultValue);
    }
});

// 공통 컨텍스트 경로
const cp = document.body.getAttribute('data-context-path') || '';

// 알림 뱃지 토글
window.showAlertBadge = () => document.getElementById('alertBadge')?.classList.remove('hidden');
window.hideAlertBadge = () => document.getElementById('alertBadge')?.classList.add('hidden');

// DOMContentLoaded 시 알림 수 체크
document.addEventListener('DOMContentLoaded', () => {
    fetch(`${cp}/usr/notifications/unreadCount`)
        .then(res => res.json())
        .then(json => {
            const cnt = (json.data?.count ?? json.data1) || 0;
            if (json.resultCode === 'S-1' && cnt > 0) {
                showAlertBadge();
            } else {
                hideAlertBadge();
            }
        }).catch(() => hideAlertBadge());
});

// 알림 시간 표시 계산
function calcTimeAgo(ms) {
    const diff = Date.now() - ms;
    const sec = Math.floor(diff / 1000);
    const min = Math.floor(sec / 60);
    const hr = Math.floor(min / 60);
    const day = Math.floor(hr / 24);
    if (day > 0) return `${day}일 전`;
    if (hr > 0) return `${hr}시간 전`;
    if (min > 0) return `${min}분 전`;
    if (sec > 5) return `${sec}초 전`;
    return '방금 전';
}

// 시간 표시 갱신
function updateTimeAgo() {
    $('.time-ago').each(function () {
        const ms = parseInt($(this).data('time'), 10);
        if (!isNaN(ms)) {
            $(this).text(calcTimeAgo(ms));
        }
    });
}

setInterval(updateTimeAgo, 60000);

// 알림 벨 클릭
$(function () {
    $('#alertBtn').on('click', function (e) {
        if (typeof isNotificationPopupAllowed !== 'undefined' && !isNotificationPopupAllowed) {
            console.log("알림 팝업 차단됨 (isNotificationPopupAllowed = false)");
            return;
        }

        e.stopPropagation();
        $('#alertBadge').addClass('hidden');

        const $dd = $('#alertDropdown');
        if ($dd.is(':visible')) return $dd.hide();
        $dd.show();

        $.getJSON(cp + '/usr/notifications/recent', function (data) {
            const $list = $('#alertList').empty();
            if (!data.length) {
                $list.append('<li class="p-2 text-center text-gray-500">새 알림이 없습니다.</li>');
            } else {
                data.forEach(noti => {
                    const isRead = noti.read === true;

                    let iconHtml = '<i class="fa fa-bell text-gray-400"></i>';
                    if (noti.type === 'LIKE_POST') iconHtml = '<i class="fa fa-heart text-red-500"></i>';
                    else if (noti.type === 'LIKE_COMMENT') iconHtml = '<i class="fa fa-heart text-blue-400"></i>';
                    else if (noti.type === 'COMMENT') iconHtml = '<i class="fa fa-comment text-green-500"></i>';
                    else if (noti.type === 'REPLY') iconHtml = '<i class="fa fa-reply text-indigo-500"></i>';

                    const $li = $('<li>')
                        .addClass('notification-item p-2 flex items-start space-x-2')
                        .addClass(isRead ? 'read' : 'unread')
                        .attr({'data-id': noti.id, 'data-link': noti.link});

                    const $icon = $('<span>').addClass('mr-2 mt-1').html(iconHtml);
                    const $content = $('<div>').addClass('flex-1');
                    const $title = $('<div>').addClass('font-semibold text-sm leading-tight').text(noti.title);
                    const $time = $('<div>').addClass('text-xs text-gray-500 time-ago')
                        .attr('data-time', noti.regDateMs)
                        .text(calcTimeAgo(noti.regDateMs));
                    const $delBtn = $('<button>').addClass('delete-btn text-gray-400 hover:text-red-500 ml-2')
                        .attr('title', '삭제').html('&times;');

                    $content.append($title, $time);
                    $li.append($icon, $content, $delBtn);
                    $list.append($li);
                });

                updateTimeAgo();
            }
        }).fail(function (xhr) {
            const $list = $('#alertList').empty();
            if (xhr.status === 401) {
                $list.append(`
                    <li class="flex flex-col items-center justify-center w-full py-4">
                        <div class="text-red-600 text-base mb-2">로그인 후 확인할 수 있습니다.</div>
                        <a href="${cp}/usr/member/login" class="inline-block px-4 py-1 bg-blue-600 text-white rounded hover:bg-blue-800 transition text-sm font-semibold">로그인 하러 가기</a>
                    </li>
                `);
            } else {
                $list.append('<li class="p-2 text-center text-red-500">알림을 불러오는 중 오류가 발생했습니다.</li>');
            }
        });
    });

    // 알림 클릭 → 읽음 처리 + 팝업 열기
    $(document).on('click', '#alertList .notification-item', function (e) {
        if ($(e.target).hasClass('delete-btn')) return;
        e.stopPropagation();
        e.preventDefault();

        const $it = $(this);
        const id = $it.data('id');
        const link = $it.data('link');

        $.post(cp + '/usr/notifications/markAsRead', {notificationId: id}, function (json) {
            if (json.resultCode === 'S-1') {
                $it.removeClass('unread').addClass('read');
            }
        }, 'json').always(function () {
            setTimeout(() => {
                const url = link.startsWith('/') ? link : (cp + '/' + link);
                window.open(url, '알림상세', 'width=700,height=700,scrollbars=yes');
            }, 300);
        });
    });

    // 알림 삭제
    $(document).on('click', '.delete-btn', function (e) {
        e.stopPropagation();
        const $item = $(this).closest('.notification-item');
        const id = $item.data('id');
        if (!confirm('이 알림을 삭제하시겠습니까?')) return;
        $.post(cp + '/usr/notifications/delete', {id: id}, function (json) {
            if (json.resultCode === 'S-1') {
                $item.remove();
                if ($('#alertList .notification-item').length === 0) {
                    $('#alertList').append('<li class="p-2 text-center text-gray-500">새 알림이 없습니다.</li>');
                }
                alert(json.msg || '알림이 삭제되었습니다.');
            } else {
                alert(json.msg || '삭제에 실패했습니다.');
            }
        }, 'json').fail(() => alert('서버 에러로 삭제에 실패했습니다.'));
    });

    // 전체 알림 보기 클릭
    $('#showAllNotifications').on('click', function (e) {
        e.preventDefault();
        window.open(cp + '/usr/notifications/list', '알림함', 'width=500,height=600,resizable=no,scrollbars=yes');
    });

    // 바깥 클릭 시 드롭다운 닫기
    $(document).on('click', () => {
        $('#alertDropdown').hide();
    });
});

// 메뉴
$(document).ready(function () {
    const $mainMenu = $('#mainMenu');
    const $megaMenu = $('#megaMenu');
    let menuTimer;

    $mainMenu.on('mouseenter', function () {
        clearTimeout(menuTimer);
        $megaMenu.stop(true, true).slideDown(150);
    });

    $mainMenu.on('mouseleave', function () {
        menuTimer = setTimeout(() => {
            $megaMenu.stop(true, true).slideUp(150);
        }, 300);
    });

    $megaMenu.on('mouseenter', function () {
        clearTimeout(menuTimer);
    });

    $megaMenu.on('mouseleave', function () {
        $megaMenu.stop(true, true).slideUp(150);
    });
});
