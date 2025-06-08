package com.example.demo.interceptor;


import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class BeforeActionInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {

        Rq rq = new Rq(req, resp);
        req.setAttribute("rq", rq);

        return HandlerInterceptor.super.preHandle(req, resp, handler);
    }
}
