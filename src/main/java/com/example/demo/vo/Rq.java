package com.example.demo.vo;

import com.example.demo.util.Ut;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.Getter;

import java.io.IOException;


public class Rq {

    @Getter
    private boolean isLogined;

    @Getter
    private int loginedMemberId;

    private HttpServletRequest req;
    private HttpServletResponse resp;
    private HttpSession session;

    public Rq(HttpServletRequest req, HttpServletResponse resp) {

        this.req = req;
        this.resp = resp;
        this.session = req.getSession();

        HttpSession httpSession = req.getSession();


        if (httpSession.getAttribute("loginedMemberId") != null) {
            isLogined = true;
            loginedMemberId = (int) httpSession.getAttribute("loginedMemberId");
        }
    }

    public void printHistoryBack(String msg) throws IOException {

        resp.setContentType("text/html;charset=utf-8");

        println("<script>");

        if(!Ut.isEmpty(msg)){
            println("alert('" + msg + "');");
        }

        println("history.back();");
        println("</script>");
    }

    private void println(String str) throws IOException {

        print(str + "\n");
    }

    private void print(String str) throws IOException {

        resp.getWriter().append(str);
    }

    public void logout(){
        session.removeAttribute("loginedMemberId");
    }

    public void login(Member member){

        session.setAttribute("loginedMemberId", member.getId());
    }
}
