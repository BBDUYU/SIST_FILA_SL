package com.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;  
import java.util.Map;
  
import javax.servlet.http.Cookie;  
import javax.servlet.http.HttpServletRequest;

public class Cookies {
    //         쿠키이름  쿠키객체
   public Map<String, Cookie> cookieMap = new HashMap<>();
   
   // 생성자
   // 모든 쿠키 정보를 얻어와서...
   public Cookies(HttpServletRequest request) {      
      Cookie [] cookieArr = request.getCookies();
      if( cookieArr != null ) {
         for (Cookie c : cookieArr) {
            String cname =  c.getName();
            cookieMap.put(cname, c);
         } // for
      } // if      
   }
   
   public Cookie getCookie(String cookieName ) {
      return cookieMap.get(cookieName);
   }
   
   public String getCookieValue(String cookieName ) throws UnsupportedEncodingException {
      Cookie cookie = cookieMap.get(cookieName);
      if (cookie != null) {
         return URLDecoder.decode( cookie.getValue(), "UTF-8"  );
      }
      return null;
   }
   
   public boolean exists(String cookieName ) {
      return cookieMap.containsKey(cookieName);
   }
   
   // 쿠키 생성
   public static Cookie createCookie(String cookieName, String cookieValue) throws UnsupportedEncodingException {
      Cookie c = new Cookie( cookieName, URLEncoder.encode(cookieValue, "UTF-8"));
      return c;
   }
   
   // 쿠키 생성
   public static Cookie createCookie(String cookieName, String cookieValue, int expiry) throws UnsupportedEncodingException {
      Cookie c = new Cookie( cookieName, URLEncoder.encode(cookieValue, "UTF-8"));
      c.setPath("/");
      c.setMaxAge(expiry);
      return c;
   }
   
   // 쿠키 생성
   public static Cookie createCookie(String cookieName, String cookieValue, String path, int expiry) throws UnsupportedEncodingException {
      Cookie c = new Cookie( cookieName, URLEncoder.encode(cookieValue, "UTF-8"));
      c.setPath(path);
      c.setMaxAge(expiry);
      return c;
   }
   
   // 쿠키 생성  오버로딩( overloading )
   public static Cookie createCookie(String cookieName, String cookieValue, String domain, String path, int expiry) throws UnsupportedEncodingException {
      Cookie c = new Cookie( cookieName, URLEncoder.encode(cookieValue, "UTF-8"));
      c.setDomain(domain);
      c.setPath(path);
      c.setMaxAge(expiry);
      return c;
   }

} // class









