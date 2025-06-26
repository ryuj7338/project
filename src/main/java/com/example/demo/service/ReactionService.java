package com.example.demo.service;


import com.example.demo.repository.MemberRepository;
import com.example.demo.repository.PostRepository;
import com.example.demo.repository.ReactionRepository;
import com.example.demo.vo.Post;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReactionService {

    @Autowired
    private ReactionRepository reactionRepository;
    @Autowired
    private PostService postService;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private NotificationService notificationService;

    // 댓글/게시글 좋아요 수 조회
    public int getReactionPoint(int memberId, String relTypeCode, int relId) {
        return reactionRepository.getSumReaction(memberId, relTypeCode, relId);
    }

    public int getReactionPoint(String relTypeCode, int relId) {
        return reactionRepository.getSumReactionTotal(relTypeCode, relId);
    }


    public boolean isAlreadyAddLikeRp(int memberId, int relId, String relTypeCode) {
        return reactionRepository.getSumReaction(memberId, relTypeCode, relId) > 0;
    }

    public ResultData usersReaction(int loginedMemberId, String relTypeCode, int relId) {
        if (loginedMemberId == 0) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        int sum = reactionRepository.getSumReaction(loginedMemberId, relTypeCode, relId);
        if (sum != 0) {
            return ResultData.from("F-1", "이미 좋아요 함", "sumReactionByMemberId", sum);
        }

        return ResultData.from("S-1", "좋아요 가능", "sumReactionByMemberId", sum);
    }

    public ResultData addLikeReaction(int loginedMemberId, String relTypeCode, int relId) {
        int affectedRow = reactionRepository.addLikeReaction(loginedMemberId, relTypeCode, relId);

        if (affectedRow == -1) {
            return ResultData.from("F-1", "좋아요 실패");
        }

        if ("post".equals(relTypeCode)) {
            postService.increaseLikeReaction(relId);
        }

        return ResultData.from("S-1", "좋아요 성공");
    }

    public ResultData deleteLikeReaction(int loginedMemberId, String relTypeCode, int relId) {
        reactionRepository.deleteLikeReaction(loginedMemberId, relTypeCode, relId);

        if ("post".equals(relTypeCode)) {
            postService.decreaseLikeReaction(relId);
        }

        return ResultData.from("S-1", "좋아요 취소");
    }


    public ResultData<?> toggleReaction(int memberId, String relTypeCode, int relId) {
        boolean isReacted = reactionRepository.existsByMemberIdAndRelTypeCodeAndRelId(memberId, relTypeCode, relId);

        if (isReacted) {
            reactionRepository.delete(memberId, relTypeCode, relId);
            return ResultData.from("S-2", "좋아요 취소");
        }

        reactionRepository.insert(memberId, relTypeCode, relId);

        // ✅ 알림 처리
        if (relTypeCode.equals("post")) {
            Post post = postRepository.getPostById(relId);
            if (post != null && post.getMemberId() != memberId) {
                String nickname = memberRepository.getNicknameById(memberId);
                String message = "❤️ " + nickname + "님이 회원님의 글에 좋아요를 눌렀습니다.";
                String link = "/usr/post/detail?id=" + relId;

                notificationService.notifyMember(post.getMemberId(), message, link);
            }
        }

        return ResultData.from("S-1", "좋아요 성공");
    }

}
