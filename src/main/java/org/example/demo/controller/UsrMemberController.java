package org.example.demo.controller;

import org.example.demo.service.MemberService;
import org.example.demo.util.Ut;
import org.example.demo.vo.Member;
import org.example.demo.vo.ResultData;
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
    public ResultData<Integer> doJoin(String loginId, String loginPw, String name, String nickname, String email, String cellphone) {

        if(Ut.isEmptyOrNull(loginId)) {
            return ResultData.from("F-1", "아이디를 입력하세요");
        }
        if(Ut.isEmptyOrNull(loginPw)) {
            return ResultData.from("F-1", "비밀번호를 입력하세요");
        }
        if(Ut.isEmptyOrNull(name)) {
            return ResultData.from("F-1", "이름을 입력하세요");
        }
        if(Ut.isEmptyOrNull(nickname)) {
            return ResultData.from("F-1", "닉네임을 입력하세요");
        }
        if(Ut.isEmptyOrNull(email)) {
            return ResultData.from("F-1", "이메일을 입력하세요");
        }

        ResultData doJoinRd = memberService.dojoin(loginId,loginPw, name, nickname, email, cellphone);

//      아이디 중복 확인
        if(doJoinRd.isFail()) {
            return doJoinRd;
        }

        Member member = memberService.getMemberById((int) doJoinRd.getData1());

        return ResultData.newData(doJoinRd, member);
    }
}
