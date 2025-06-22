package com.example.demo.controller;

import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.example.demo.service.MemberService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UsrMemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private Rq rq;

    @RequestMapping("/usr/member/login")
    public String showLogin(HttpServletRequest req) {
        return "/usr/member/login";
    }

    @RequestMapping("/usr/member/doLogin")
    @ResponseBody
    public String doLogin(HttpServletRequest req, String loginId, String loginPw) {

        Rq rq = (Rq) req.getAttribute("rq");

        if(Ut.isEmptyOrNull(loginId)){
            return Ut.jsHistoryBack("F-1", "아이디를 입력하세요");
        }
        if(Ut.isEmptyOrNull(loginPw)){
            return Ut.jsHistoryBack("F-1", "비밀번호를 입력하세요");
        }

        Member member = memberService.getMemberByLoginId(loginId);

        if(member == null) {
            return Ut.jsHistoryBack("F-3", Ut.f("%s는(은) 없는 아이디입니다.", loginId));
        }

        if(member.getLoginPw().equals(Ut.sha256(loginPw)) == false) {
            return Ut.jsHistoryBack("F-4", "비밀번호가 일치하지 않습니다");
        }

        rq.login(member);

        return Ut.jsReplace("S-1", Ut.f("%s님 환영합니다.", member.getNickname()), "/");
    }

    @RequestMapping("/usr/member/doLogout")
    @ResponseBody
    public String doLogout(HttpServletRequest req) {

        Rq rq = (Rq) req.getAttribute("rq");

        rq.logout();

        return Ut.jsReplace("S-1", "로그아웃 되었습니다.", "/");
    }

    @RequestMapping("/usr/memebr/join")
    public String showJoin(){
        return "/usr/member/join";
    }

    @RequestMapping("usr/member/doJoin")
    @ResponseBody
    public String doJoin(HttpServletRequest req, String loginId, String loginPw, String name, String nickname, String email, String cellphone) {


        if(Ut.isEmptyOrNull(loginId)) {
            return Ut.jsHistoryBack("F-1", "아이디를 입력하세요");
        }
        if(Ut.isEmptyOrNull(loginPw)) {
            return Ut.jsHistoryBack("F-1", "비밀번호를 입력하세요");
        }
        if(Ut.isEmptyOrNull(name)) {
            return Ut.jsHistoryBack("F-1", "이름을 입력하세요");
        }
        if(Ut.isEmptyOrNull(nickname)) {
            return Ut.jsHistoryBack("F-1", "닉네임을 입력하세요");
        }
        if(Ut.isEmptyOrNull(email)) {
            return Ut.jsHistoryBack("F-1", "이메일을 입력하세요");
        }

        ResultData joinRd = memberService.join(loginId,loginPw, name, nickname, email, cellphone);

//      아이디 중복 확인
        if(joinRd.isFail()) {
            return Ut.jsHistoryBack(joinRd.getResultCode(), joinRd.getMsg());
        }

        Member member = memberService.getMemberById((int) joinRd.getData1());

        return Ut.jsReplace(joinRd.getResultCode(), joinRd.getMsg(), "../member/login");
    }

    @RequestMapping("/usr/member/myPage")
    public String showMyPage(){
        return "/usr/member/myPage";
    }

    @RequestMapping("/usr/member/checkPw")
    public String showCheckPw(){
        return "/usr/member/checkPw";
    }

    @RequestMapping("/usr/member/doCheckPw")
    @ResponseBody
    public String doCheckPw(String loginPw){

        if(Ut.isEmptyOrNull(loginPw)) {
            return Ut.jsHistoryBack("F-1", "비밀번호를 입력하세요");
        }

        if(rq.getLoginedMember().getLoginPw().equals(Ut.sha256(loginPw)) == false){
            return Ut.jsHistoryBack("F-2", "비밀번호가 틀렸습니다.");
        }

        return Ut.jsReplace("S-1", Ut.f("비밀번호 확인 성공"), "modify");
    }

    @RequestMapping("/usr/member/modify")
    public String showMyModify(){
        return "/usr/member/modify";
    }

    @RequestMapping("/usr/member/doModify")
    @ResponseBody
    public String doModify(HttpServletRequest req, String loginPw, String name, String nickname, String cellphone, String email){

        Rq rq = (Rq) req.getAttribute("rq");

//        비번은 안 바꾸는 거 가능(사용자) 비번 null 체크는 x
        if(Ut.isEmptyOrNull(name)){
            return Ut.jsHistoryBack("F-3", "name 입력 x");
        }
        if(Ut.isEmptyOrNull(nickname)){
            return Ut.jsHistoryBack("F-4", "nickname 입력 x");
        }
        if(Ut.isEmptyOrNull(cellphone)){
            return Ut.jsHistoryBack("F-5", "cellphone 입력 x");
        }
        if(Ut.isEmptyOrNull(email)){
            return Ut.jsHistoryBack("F-6", "email 입력 x");
        }

        ResultData modifyRd;

        if(Ut.isEmptyOrNull(loginPw)) {
            modifyRd = memberService.modifyWithoutPw(rq.getLoginedMemberId(), name, nickname,cellphone, email);
        }else{
            modifyRd = memberService.modify(rq.getLoginedMemberId(), loginPw, name, nickname, cellphone, email);
        }

        return Ut.jsReplace(modifyRd.getResultCode(), modifyRd.getMsg(), "../member/myPage");
    }

    @RequestMapping("/usr/member/findLoginId")
    public String showFindLoginId(){

        return "/usr/member/findLoginId";
    }

    @RequestMapping("/usr/member/doFindLoginId")
    @ResponseBody
    public String doFindLoginId(@RequestParam(defaultValue = "/") String afterFindLoginIdUri, String name, String email){

        Member member = memberService.getMemberByNameAndEmail(name, email);

        if(member == null){
            return Ut.jsHistoryBack("F-1", "존재하지 않는 회원입니다.");
        }

        return Ut.jsReplace("S-1", Ut.f("회원님의 아이디는 [ %s ]입니다.", member.getLoginId()), afterFindLoginIdUri);
    }
}
