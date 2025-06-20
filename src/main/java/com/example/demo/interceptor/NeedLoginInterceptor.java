package com.example.demo.interceptor;

import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class NeedLoginInterceptor implements HandlerInterceptor {

    @Autowired
    private Rq rq;

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {

        Rq rq = (Rq) req.getAttribute("rq");

        if (!rq.isLogined()) {
            String acceptHeader = req.getHeader("accept");
            boolean isAjax = acceptHeader != null && acceptHeader.contains("application/json");

            if (isAjax) {
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write("{\"resultCode\":\"F-L\", \"msg\":\"로그인이 필요합니다.\"}");
            } else {
                rq.printHistoryBack("로그인이 필요합니다.");
            }

            return false;
        }

        return HandlerInterceptor.super.preHandle(req, resp, handler);
    }
}
