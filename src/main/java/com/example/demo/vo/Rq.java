package com.example.demo.vo;

import com.example.demo.service.MemberService;
import com.example.demo.util.Ut;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.Getter;
import lombok.Setter;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
@Getter
@Setter
public class Rq {

    private boolean isLogined = false;

    private int loginedMemberId = 0;

    private final HttpServletRequest req;
    private final HttpServletResponse resp;
    private final HttpSession session;

    @Getter
    private Member loginedMember;

    public Rq(HttpServletRequest req, HttpServletResponse resp, MemberService memberService) {

        this.req = req;
        this.resp = resp;
        this.session = req.getSession();


        if (session.getAttribute("loginedMemberId") != null) {
            isLogined = true;
            loginedMemberId = (int) session.getAttribute("loginedMemberId");
            loginedMember = memberService.getMemberById(loginedMemberId);
        }

        this.req.setAttribute("rq", this);
    }

    public void printHistoryBack(String msg) throws IOException {

        resp.setContentType("text/html;charset=utf-8");

        println("<script>");

        if(!Ut.isEmpty(msg)){
            println("alert('" + msg.replace("'", "\\'") + "');");
        }

        println("history.back();");
        println("</script>");
        resp.getWriter().flush();
        resp.getWriter().close();
    }

    public void initBeforeActionInterceptor(){
        System.err.println("initBeforeActionInterceptor 실행됨");
    }

    public String historyBackOnView(String msg){

        req.setAttribute("msg", msg);
        req.setAttribute("historyBack", true);
        return "/usr/common/js";
    }

    private void println(String str) throws IOException {

        print(str + "\n");
    }

    private void print(String str) throws IOException {

        resp.getWriter().append(str);
    }

    public void logout(){
        session.removeAttribute("loginedMemberId");
        session.removeAttribute("loginedMember");
    }

    public void login(Member member){

        session.setAttribute("loginedMemberId", member.getId());
        session.setAttribute("loginedMember", member);
    }

    public String getcurrentUri(){
        String currentUri = req.getRequestURI();
        String queryString = req.getQueryString();

        System.out.println(currentUri);
        System.out.println(queryString);

        if(currentUri != null && queryString != null){
            currentUri = currentUri + "?" + queryString;
        }

        return currentUri;
    }
}
