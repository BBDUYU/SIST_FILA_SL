package fila.mypage.domain;

public class AddressDTO {
  private int addressId;
  private int userNumber;
  private String addressName;
  private String recipientName;
  private String recipientPhone;
  private String zipcode;
  private String mainAddr;   // addr3 쓸거면 mainAddr에 넣기
  private String detailAddr; // addr2
  private int isDefault;     // 1/0

  // getters/setters
  public int getAddressId() { return addressId; }
  public void setAddressId(int addressId) { this.addressId = addressId; }
  
  public int getUserNumber() { return userNumber; }
  public void setUserNumber(int userNumber) { this.userNumber = userNumber; }
  
  public String getAddressName() { return addressName; }
  public void setAddressName(String addressName) { this.addressName = addressName; }
  
  public String getRecipientName() { return recipientName; }
  public void setRecipientName(String recipientName) { this.recipientName = recipientName; }
  
  public String getRecipientPhone() { return recipientPhone; }
  public void setRecipientPhone(String recipientPhone) { this.recipientPhone = recipientPhone; }
  
  public String getZipcode() { return zipcode; }
  public void setZipcode(String zipcode) { this.zipcode = zipcode; }
  
  public String getMainAddr() { return mainAddr; }
  public void setMainAddr(String mainAddr) { this.mainAddr = mainAddr; }
  
  public String getDetailAddr() { return detailAddr; }
  public void setDetailAddr(String detailAddr) { this.detailAddr = detailAddr; }
  
  public int getIsDefault() { return isDefault; }
  public void setIsDefault(int isDefault) { this.isDefault = isDefault; }
}