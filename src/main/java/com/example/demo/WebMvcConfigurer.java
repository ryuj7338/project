package com.example.demo;

import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.interceptor.NeedLoginInterceptor;
import com.example.demo.interceptor.NeedLogoutInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;

@Configuration
public class WebMvcConfigurer implements org.springframework.web.servlet.config.annotation.WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {


        registry.addViewController("/usr/post/introduce.jsp")
                .setViewName("usr/post/introduce");
        registry.addViewController("/usr/post/introduce")
                .setViewName("usr/post/introduce");

        registry
                .addViewController("/usr/post/requirements")
                .setViewName("usr/post/requirements");

        registry.addViewController("/usr/post/company")
                .setViewName("usr/post/company");
        // (굳이 .jsp 확장자 붙여 들어오는 경우도 동일하게)
        registry.addViewController("/usr/post/company.jsp")
                .setViewName("usr/post/company");
    }

    //  BeforeActionInterceptor 불러오기(연결)
    @Autowired
    BeforeActionInterceptor beforeActionInterceptor;

    //  NeedLoginInterceptor 불러오기(연결)
    @Autowired
    NeedLoginInterceptor needLoginInterceptor;

    //  NeedLogoutInterceptor 불러오기(연결)
    @Autowired
    NeedLogoutInterceptor needLogoutInterceptor;

    // 인터셉터 등록(적용)
    public void addInterceptors(InterceptorRegistry registry) {

        InterceptorRegistration ir;

        ir = registry.addInterceptor(beforeActionInterceptor);
        ir.addPathPatterns("/**");
        ir.addPathPatterns("/favicon.ico");
        ir.addPathPatterns("/resource/**");
        ir.addPathPatterns("/error");
        ir.addPathPatterns("/static/**");
        ir.addPathPatterns("/upload/**");
        ir.addPathPatterns("/uploadFiles/**");
        ir.addPathPatterns("file:///\" + System.getProperty(\"user.dir\") + \"/uploadFiles/");

        //  로그인 필요
        ir = registry.addInterceptor(needLoginInterceptor);

        //  글 관련
        ir.addPathPatterns("/usr/post/write");
        ir.addPathPatterns("/usr/post/doWrite");
        ir.addPathPatterns("/usr/post/modify");
        ir.addPathPatterns("/usr/post/doModify");
        ir.addPathPatterns("/usr/post/doDelete");

        //  회원 관련
        ir.addPathPatterns("/usr/member/myPage");
        ir.addPathPatterns("/usr/member/checkPw");
        ir.addPathPatterns("/usr/member/doCheckPw");
        ir.addPathPatterns("/usr/member/doLogout");
        ir.addPathPatterns("/usr/member/modify");
        ir.addPathPatterns("/usr/member/doModify");

        //  댓글 관련
        ir.addPathPatterns("/usr/comment/doWrite");

        //  좋아요 관련
        ir.addPathPatterns("/usr/reaction/doLike");

        // 채용공고 관련
        ir.addPathPatterns("/usr/job/favorite/toggle");
        ir.addPathPatterns("/usr/job/favorite/list");
        ir.addPathPatterns("/usr/job/favorite/delete");
        ir.addPathPatterns("/usr/job/favorite/modify");

//      gpt 면접/ 자기소개서
        ir.addPathPatterns("/usr/gpt/interview");
        ir.addPathPatterns("/usr/gpt/selfintro");
        ir.addPathPatterns("/usr/gpt/doAsk");
        ir.addPathPatterns("/usr/gpt/history");

        //  로그아웃 필요
        ir = registry.addInterceptor(needLogoutInterceptor);
        ir.addPathPatterns("/usr/member/login");
        ir.addPathPatterns("/usr/member/doLogin");
        ir.addPathPatterns("/usr/member/join");
        ir.addPathPatterns("/usr/member/doJoin");
        ir.addPathPatterns("/usr/member/findLoginId");
        ir.addPathPatterns("/usr/member/doFindLoginId");
        ir.addPathPatterns("/usr/member/findLoginPw");
        ir.addPathPatterns("/usr/member/doFindLoginPw");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploadFiles/**")
                .addResourceLocations("classpath:/static/uploadFiles/");
    }
}
