package org.example.demo.service;


import org.example.demo.repository.MemberRepository;
import org.example.demo.util.Ut;
import org.example.demo.vo.Member;
import org.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberService {

    @Autowired
    private MemberRepository memberRepository;

    public MemberService(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }


    public Member getMemberById(int id) {

        return memberRepository.getMemberById(id);
    }


    public ResultData dojoin(String loginId, String loginPw, String name, String nickname, String email, String cellphone) {

        Member existsMember = memberRepository.getMemberByLoginId(loginId);

        if(existsMember != null) {
            return ResultData.from("F-7", Ut.f("이미 사용중인 아이디(%s)입니다.", loginId));
        }

        existsMember = getMemberByNicknameAndEmail(nickname, email);

        if(existsMember != null) {
            return ResultData.from("F-8", Ut.f("이미 사용중인 닉네임(%s)과 이메일(%s)입니다.", nickname, email));
        }

        memberRepository.doJoin(loginId, loginPw, name, nickname, email, cellphone);

        int id = memberRepository.getLastInsertId();

        return ResultData.from("S-1", "회원가입을 성공하였습니다.");
    }

    public Member getMemberByNicknameAndEmail(String nickname, String email) {

        return memberRepository.getMemberByNicknameAndEmail(nickname, email);
    }

    public Member getMemberByLoginId(String loginId) {

        return memberRepository.getMemberByLoginId(loginId);
    }
}
