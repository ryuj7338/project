package com.example.demo;

import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.interceptor.NeedLoginInterceptor;
import com.example.demo.interceptor.NeedLogoutInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
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

        InterceptorRegistration ir;

        ir = registry.addInterceptor(beforeActionInterceptor);
        ir.addPathPatterns("/**");
        ir.addPathPatterns("/favicon.ico");
        ir.addPathPatterns("/resource/**");
        ir.addPathPatterns("/error");

        ir = registry.addInterceptor(needLoginInterceptor);
        ir.addPathPatterns("/usr/post/write");
        ir.addPathPatterns("/usr/post/doWrite");
        ir.addPathPatterns("/usr/post/modify");
        ir.addPathPatterns("/usr/post/doModify");
        ir.addPathPatterns("/usr/post/doDelete");
        ir.addPathPatterns("/usr/member/doLogout");

        ir.addPathPatterns("/usr/reaction/doLike");
        ir.addPathPatterns("/usr/reaction/doDislike");

        ir = registry.addInterceptor(needLogoutInterceptor);
        ir.addPathPatterns("/usr/member/login");
        ir.addPathPatterns("/usr/member/doLogin");
        ir.addPathPatterns("/usr/member/join");
        ir.addPathPatterns("/usr/member/doJoin");
    }
}
