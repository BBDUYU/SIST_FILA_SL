<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="fila.mypage.persistence.AddressDAO,fila.mypage.domain.AddressDTO" %>
<%@ page import="fila.com.util.ConnectionProvider" %>
<%@ page import="fila.member.MemberDTO" %>

<%
  MemberDTO loginUser = (MemberDTO) session.getAttribute("auth");
  int userNumber = (loginUser == null) ? -1 : loginUser.getUserNumber();

  int addrNo = 0;
  try { addrNo = Integer.parseInt(request.getParameter("addrNo")); } catch(Exception e) { addrNo = 0; }

  AddressDTO a = null;
  if (userNumber != -1 && addrNo > 0) {
    AddressDAO dao = new AddressDAO();
    Connection conn = null;
    try {
      conn = ConnectionProvider.getConnection();
      a = dao.selectOneById(conn, addrNo, userNumber);
    } finally {
      if(conn != null) try { conn.close(); } catch(Exception ignore) {}
    }
  }
%>

<div class="common__layer _addr_add sch-idpw">
  <div class="layer-bg__wrap"></div>

  <div class="inner">
    <div class="head">
      <p class="tit">배송지 수정</p>
      <button type="button" class="close__btn">close</button>
    </div>

    <div class="con">
      <form name="addr" id="addr" method="post">
        <input type="hidden" name="addrNo" value="<%= (a!=null? a.getAddressId() : "") %>">

        <div class="addr-add-box">
          <div>
            <input type="text" placeholder="배송지 이름" name="addressName" maxlength="25"
                   value="<%= (a!=null && a.getAddressName()!=null ? a.getAddressName() : "") %>">
          </div>

          <div>
            <input type="text" placeholder="수령인" name="addrname" maxlength="25"
                   value="<%= (a!=null && a.getRecipientName()!=null ? a.getRecipientName() : "") %>">
          </div>

          <div>
            <input type="text" name="tel2_1" id="addrPhone"
                   placeholder="휴대폰 번호를 '-' 제외하고 숫자만 입력해주세요"
                   maxlength="11"
                   value="<%= (a!=null && a.getRecipientPhone()!=null ? a.getRecipientPhone() : "") %>"
                   onkeyup="this.value=this.value.replace(/[^0-9]/g,'');">
          </div>

          <div class="_addr">
            <div>
              <input type="text" name="zipcode" readonly id="addrZip"
                     value="<%= (a!=null && a.getZipcode()!=null ? a.getZipcode() : "") %>">
              <button type="button" class="zipcode__btn">주소찾기</button>
            </div>

            <div>
              <input type="text" name="addr3" maxlength="200" readonly id="addrNum1"
                     value="<%= (a!=null && a.getMainAddr()!=null ? a.getMainAddr() : "") %>">
            </div>

            <div>
              <input type="text" name="addr2" maxlength="100" id="addrNum3" autocomplete="off"
                     value="<%= (a!=null && a.getDetailAddr()!=null ? a.getDetailAddr() : "") %>">
            </div>
          </div>

          <div class="chk">
            <input type="checkbox" name="addrDefault" value="D" id="addrCheck" class="cb__style1"
                   <%= (a!=null && a.getIsDefault()==1 ? "checked" : "") %>>
            <label for="addrCheck">기본 배송지로 저장</label>
          </div>
        </div>

        <div id="MapModalOverlay"
             class="style-modal-overlay"
             onclick="if(event.target === this) closeQnaModal();"
             style="display:none;">
          <div id="MapModalContent" class="style-modal-wrapper"></div>
        </div>

      </form>
    </div>

    <div class="foot">
      <button type="button" onclick="$('.close__btn').click();">취소</button>
      <button type="button" class="on" id="btnSaveEdit">저장하기</button>
    </div>
  </div>
</div>

<script>
var contextPath = '${pageContext.request.contextPath}';

(function ($) {

  // 주소찾기(기존 그대로)
  $(document).on('click', '.zipcode__btn', function (e) {
    e.preventDefault();

    var $scope = $(this).closest('.style-modal-wrapper, .inner, #AddaddModalContent, #EditaddModalContent');
    var $mapOverlay = $scope.find('#MapModalOverlay');
    var $mapContent = $scope.find('#MapModalContent');

    if ($mapOverlay.length === 0) $mapOverlay = $('#MapModalOverlay');
    if ($mapContent.length === 0) $mapContent = $('#MapModalContent');

    $mapContent.load(contextPath + '/view/mypage/map.jsp', function () {
      $mapOverlay.css('display', 'flex').show();
    });
  });

  $(document).on('click', '#MapModalOverlay, #MapModalOverlay .close__btn', function (e) {
    if (e.target !== this && !$(e.target).hasClass('close__btn')) return;

    var $overlay = $(this).closest('#MapModalOverlay');
    $overlay.hide();
    $overlay.find('#MapModalContent').empty();
  });

})(jQuery);
</script>

<script>
(function($){
  $(document).off('click.addrEdit', '#btnSaveEdit')
             .on('click.addrEdit', '#btnSaveEdit', function(e){
    e.preventDefault();
    e.stopPropagation();

    var $form = $(this).closest('.common__layer').find('form#addr');

    var addrNo = $form.find('input[name=addrNo]').val();
    if(!addrNo){
      alert('addrNo가 없습니다. (수정 대상 주소번호)');
      return;
    }

    $.ajax({
      url: contextPath + '/mypage/address/edit.htm',
      type: 'POST',
      data: $form.serialize(),
      dataType: 'json',
      success: function(res){
        if(res && res.ok){
          if (window.closeQnaModal) closeQnaModal();
          location.reload();
        }else{
          alert('수정 실패');
        }
      },
      error: function(xhr){
        alert('수정 실패 (' + xhr.status + ')');
      }
    });
  });
})(jQuery);
</script>