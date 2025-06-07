package org.example.demo.controller;

import org.example.demo.service.MemberService;
import org.example.demo.util.Ut;
import org.example.demo.vo.Member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UsrMemberController {

    @Autowired
    private MemberService memberService;

    @RequestMapping("usr/member/doJoin")
    @ResponseBody
    public Object doJoin(String loginId, String loginPw, String name, String nickname, String email, String cellphone) {

        if(Ut.isEmptyOrNull(loginId)) {
            return "아이디를 입력하세요";
        }
        if(Ut.isEmptyOrNull(loginPw)) {
            return "비밀번호를 입력하세요";
        }
        if(Ut.isEmptyOrNull(name)) {
            return "이름을 입력하세요";
        }
        if(Ut.isEmptyOrNull(nickname)) {
            return "닉네임을 입력하세요";
        }
        if(Ut.isEmptyOrNull(email)) {
            return "이메일을 입력하세요";
        }

        int id = memberService.dojoin(loginId,loginPw, name, nickname, email, cellphone);

//      아이디 중복 확인
        if(id == -1) {
            return "이미 사용중인 ID입니다.";
        }
        if(id == -2) {
            return "이미 사용중인 닉네임과 이메일입니다";
        }

        Member member = memberService.getMemberById(id);

        return member;
    }
}
