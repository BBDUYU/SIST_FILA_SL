<%@ page contentType="text/html; charset=UTF-8" %>

<div class="inner" style="background:#fff; width:90%; max-width:680px; height:520px; position:relative; border-radius:8px; padding:10px;">
  <button type="button" class="close__btn" style="position:absolute; right:10px; top:10px;">닫기</button>
  <div id="daumWrap" style="width:100%; height:100%; min-height:480px;"></div>
</div>

<script>
(function(){
  function ensureDaum(cb){
    if (window.daum && daum.Postcode) return cb();
    var s = document.createElement('script');
    s.src = 'https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js';
    s.onload = cb;
    document.head.appendChild(s);
  }

  function closeMap(){
    var overlay = document.getElementById('MapModalOverlay');
    var content = document.getElementById('MapModalContent');
    if(overlay) overlay.style.display = 'none';
    if(content) content.innerHTML = '';
  }

  document.addEventListener('click', function(e){
    if(e.target && e.target.classList.contains('close__btn')) closeMap();
  });

  ensureDaum(function(){
    new daum.Postcode({
      oncomplete: function(data){
        var zipcode = data.zonecode;
        var address = data.address;
        var jibun = data.jibunAddress || data.autoJibunAddress || data.address;

        // ⭐ 현재 열려있는 add/edit 모달 안의 폼을 찾아서 채움
        var edit = document.getElementById('EditaddressModalOverlay');
        var add  = document.getElementById('AddaddressModalOverlay');
        var scope = (edit && edit.style.display !== 'none') ? edit : add;

        if(scope){
          scope.querySelector('input[name=zipcode]').value = zipcode;
          scope.querySelector('input[name=addr3]').value   = address;
          var addr1 = scope.querySelector('input[name=addr1]');
          if(addr1) addr1.value = jibun;
          scope.querySelector('input[name=addr2]').focus();
        }

        closeMap();
      }
    }).embed(document.getElementById('daumWrap'));
  });
})();
</script>