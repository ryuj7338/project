<<<<<<< HEAD
//package com.example.demo.vo;
//
//import lombok.Getter;
//import lombok.Value;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.http.HttpHeaders;
//import org.springframework.stereotype.Component;
//import org.springframework.util.LinkedMultiValueMap;
//import org.springframework.util.MultiValueMap;
//
//
//@Slf4j
//@Getter
//@Component(value = "naverApi")
//public class NaverApi {
//
////    @Value("${naver.client_id}")
////    private String naverClientId;
////    @Value("${naver.redirect_uri}")
////    private String redirect_uri;
////    @Value("${naver.client_secret}")
////    private String client_secret;
//
//    public String getAccessToken(String code, String state) {
//
//        String reqUrl = "http://nid.naver.com/oauth2.0/token";
//
//        HttpHeaders headers = new HttpHeaders();
//
//        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
//        params.add("grant_type", "authorization_code");
//        params.add("code", code);
//        params.add("redirect_uri", redirect_uri);
//        params.add("client_id", naverClientId);
//        params.add("client_secret", client_secret);
//        params.add("state", state);
//    }
//}
=======
package com.example.demo.vo;

import lombok.Getter;
import lombok.Value;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;


@Slf4j
@Getter
@Component(value = "naverApi")
public class NaverApi {

    @Value("${naver.client_id}")
    private String naverClientId;
    @Value("${naver.redirect_uri}")
    private String redirect_uri;
    @Value("${naver.client_secret}")
    private String client_secret;

    public String getAccessToken(String code, String state) {

        String reqUrl = "http://nid.naver.com/oauth2.0/token";

        HttpHeaders headers = new HttpHeaders();

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("code", code);
        params.add("redirect_uri", redirect_uri);
        params.add("client_id", naverClientId);
        params.add("client_secret", client_secret);
        params.add("state", state);
    }
}
>>>>>>> 641ab7f613c18b59f6d9be0463f8d567b37cfb87
