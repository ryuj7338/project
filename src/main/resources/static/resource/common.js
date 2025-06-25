$('select[data-value]').each(function (index, el){
    const $el = $(el);

    defaultValue = $el.attr('data-value').trim();

    if(defaultValue.length > 0) {
        $el.val(defaultValue);
    }
});

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.notification-item').forEach(item => {
        item.addEventListener('click', function () {
            const notificationId = this.dataset.id;

            fetch('/usr/notifications/markAsRead', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `notificationId=${notificationId}`
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        this.classList.add('read'); // 스타일 반영
                    }
                });
        });
    });
});
