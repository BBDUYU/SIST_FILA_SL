<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
        $(document).ready(function(){
            if(typeof Swiper !== 'undefined') {
                new Swiper('.goods__slider', {
                    slidesPerView: 4,
                    spaceBetween: 10,
                    freeMode: true,
                    scrollbar: {
                        el: '.goods-slider-scrollbar',
                        draggable: true,
                    },
                });
            }
        });
</script>   