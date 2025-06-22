package com.example.demo.service;


import com.example.demo.repository.MemberRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;
import com.example.demo.vo.ResultData;
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


    public ResultData<Integer> join(String loginId, String loginPw, String name, String nickname, String email, String cellphone) {

        Member existsMember = memberRepository.getMemberByLoginId(loginId);

        if(existsMember != null) {
            return ResultData.from("F-7", Ut.f("이미 사용중인 아이디(%s)입니다.", loginId));
        }

        existsMember = getMemberByNicknameAndEmail(nickname, email);

        if(existsMember != null) {
            return ResultData.from("F-8", Ut.f("이미 사용중인 닉네임(%s)과 이메일(%s)입니다.", nickname, email));
        }

        loginPw = Ut.sha256(loginPw);

        memberRepository.doJoin(loginId, loginPw, name, nickname, email, cellphone);

        int id = memberRepository.getLastInsertId();

        return ResultData.from("S-1", "회원가입을 성공하였습니다.", "가입 성공 id", id);
    }

    public Member getMemberByNameAndEmail(String name, String email) {

        return memberRepository.getMemberByNameAndEmail(name, email);
    }

    public Member getMemberByNicknameAndEmail(String nickname, String email) {

        return memberRepository.getMemberByNicknameAndEmail(nickname, email);
    }

    public Member getMemberByLoginId(String loginId) {

        return memberRepository.getMemberByLoginId(loginId);
    }

    public ResultData modify(int loginedMemberId, String loginPw, String name, String nickname, String cellphone, String email) {

        loginPw = Ut.sha256(loginPw);

        memberRepository.modify(loginedMemberId, loginPw, name, nickname, cellphone, email);

        return ResultData.from("S-1", "회원정보 수정 완료");
    }

    public ResultData modifyWithoutPw(int loginedMemberId, String loginPw, String name, String nickname, String cellphone) {

        memberRepository.modifyWithoutPw(loginedMemberId, loginPw, name, nickname, cellphone);

        return ResultData.from("S-1", "회원정보 수정 완료");
    }
}
