// ✅ select 기본값 처리 (그대로 유지)
$('select[data-value]').each(function (index, el) {
    const $el = $(el);
    const defaultValue = $el.attr('data-value')?.trim();
    if (defaultValue?.length > 0) {
        $el.val(defaultValue);
    }
});


// $(document).on('click', '.notification-item', function () {
//     const $li = $(this);
//     const notificationId = $li.data('id');
//     const link = $li.data('link');
//
//     console.log("🟢 클릭된 알림 ID:", notificationId);
//     console.log("🟢 클릭된 알림 링크:", link);
//
//     if (!notificationId || isNaN(notificationId)) {
//         console.warn("⚠ 잘못된 알림 ID:", notificationId);
//         return;
//     }
//
//     fetch('/usr/notifications/markAsRead', {
//         method: 'POST',
//         headers: {
//             'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: `notificationId=${notificationId}`
//     })
//         .then(res => res.json())
//         .then(data => {
//             if (data.success) {
//                 $li.addClass('read');
//                 if (link) {
//                     // ✅ 알림을 새 창에서 열기
//                     window.open(link, '_blank');
//                 }
//             }
//         });
// });


