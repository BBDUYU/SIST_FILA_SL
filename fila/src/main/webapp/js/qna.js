(function ($) {

    $(function () {

        // 강제 초기 닫기
        $('#qnaWriteLayer').removeClass('is_open');
        $('body').removeClass('layer_open');

        // 열기
        $(document).on('click', '#btnOpenQna', function () {
            $('#qnaWriteLayer').addClass('is_open');
            $('body').addClass('layer_open');
        });

        // 닫기
        $(document).on('click', '#btnCloseQna, .layer_dim', function () {
            $('#qnaWriteLayer').removeClass('is_open');
            $('body').removeClass('layer_open');
        });

        // ESC
        $(document).on('keydown', function (e) {
            if (e.keyCode === 27) {
                $('#qnaWriteLayer').removeClass('is_open');
                $('body').removeClass('layer_open');
            }
        });

    });

})(jQuery);
