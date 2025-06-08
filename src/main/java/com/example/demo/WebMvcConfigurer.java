package com.example.demo;

import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.interceptor.NeedLoginInterceptor;
import com.example.demo.interceptor.NeedLogoutInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;

@Configuration
public class WebMvcConfigurer implements org.springframework.web.servlet.config.annotation.WebMvcConfigurer {

    @Autowired
    BeforeActionInterceptor beforeActionInterceptor;

    @Autowired
    NeedLoginInterceptor needLoginInterceptor;

    @Autowired
    NeedLogoutInterceptor needLogoutInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(beforeActionInterceptor).addPathPatterns("/**");

        registry.addInterceptor(needLoginInterceptor).addPathPatterns("/usr/post/write")
                .addPathPatterns("/usr/post/doWrite").addPathPatterns("/usr/post/modify")
                .addPathPatterns("/usr/post/doModify").addPathPatterns("/usr/post/doDelete")
                .addPathPatterns("/usr/member/doLogout");

        registry.addInterceptor(needLogoutInterceptor).addPathPatterns("/usr/member/login")
                .addPathPatterns("/usr/member/doLogin").addPathPatterns("/usr/member/join")
                .addPathPatterns("/usr/member/doJoin");
    }
}
