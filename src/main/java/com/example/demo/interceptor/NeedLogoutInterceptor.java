package com.example.demo.interceptor;


import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class NeedLogoutInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {

        Rq rq = (Rq) req.getAttribute("rq");
        boolean isLogined = false;

       if(rq.isLogined()){
           System.err.println("====== 로그아웃이 필요합니다.======");

           rq.printHistoryBack("로그아웃하고 다시 시도하세요");

           return false;
       }

       return HandlerInterceptor.super.preHandle(req, resp, handler);
    }
}
