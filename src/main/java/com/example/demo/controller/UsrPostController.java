package com.example.demo.controller;

import com.example.demo.interceptor.BeforeActionInterceptor;
import com.example.demo.service.*;
import com.example.demo.vo.*;
import jakarta.servlet.http.HttpServletRequest;
import com.example.demo.util.Ut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class UsrPostController {

    @Autowired
    private final BeforeActionInterceptor beforeActionInterceptor;

    @Autowired
    private BoardService boardService;

    @Autowired
    private PostService postService;

    @Autowired
    private ReactionService reactionService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private NewsService newsService;

    @Autowired
    private LawService lawService;

    @Autowired
    private JobPostingService jobPostingService;

    @Autowired
    private Rq rq;

    UsrPostController(BeforeActionInterceptor beforeActionInterceptor) {
        this.beforeActionInterceptor = beforeActionInterceptor;
    }

    @RequestMapping("/usr/post/modify")
    public String showModify(HttpServletRequest req, Model model, int id){

        Rq rq = (Rq) req.getAttribute("rq");

        Post post = postService.getForPrintPost(rq.getLoginedMemberId(), id);

        if(post == null){
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        model.addAttribute("post", post);

        return "/usr/post/modify";
    }

    @RequestMapping("/usr/post/doModify")
    @ResponseBody
    public String doModify(HttpServletRequest req, int id, String title, String body) {

        Rq rq = (Rq) req.getAttribute("rq");

        Post post = postService.getPostById(id);

        if (post == null) {
            return Ut.jsReplace("F-1", Ut.f("%d번 게시글은 없습니다.", id), "../post/list");
        }

        ResultData userCanModifyRd = postService.userCanModify(rq.getLoginedMemberId(), post);

        if(userCanModifyRd.isFail()){
            return Ut.jsHistoryBack(userCanModifyRd.getResultCode(), userCanModifyRd.getMsg());
        }
        if(userCanModifyRd.isSuccess()){
            postService.modifyPost(id, title, body);
        }

        post = postService.getPostById(id);

        return Ut.jsReplace(userCanModifyRd.getResultCode(), userCanModifyRd.getMsg(), "../post/detail?id=" + id);
    }

    @RequestMapping("/usr/post/doDelete")
    @ResponseBody
    public String doDelete(HttpServletRequest req, int id) {

        Rq rq = (Rq) req.getAttribute("rq");

        Post post = postService.getPostById(id);

        if (post == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        ResultData userCanDeleteRd = postService.userCanDelete(rq.getLoginedMemberId(), post);

        if(userCanDeleteRd.isFail()){
            return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());
        }

        if(userCanDeleteRd.isSuccess()){
            postService.deletePost(id);
        }

        postService.deletePost(id);

        return Ut.jsReplace(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg(), "../post/list");
    }

    @RequestMapping("/usr/post/write")
    public String showWrite(){
        return "/usr/post/write";
    }

    @RequestMapping("/usr/post/doWrite")
    @ResponseBody
    public String doWrite(HttpServletRequest req, String title, String body) {

        Rq rq = (Rq) req.getAttribute("rq");

        if (Ut.isEmptyOrNull(title)) {
            return Ut.jsHistoryBack("F-1", "제목을 입력하세요");
        }

        if (Ut.isEmptyOrNull(body)) {
            return Ut.jsHistoryBack("F-2", "내용을 입력하세요");
        }

        ResultData doWriteRd = postService.writePost(rq.getLoginedMemberId(), title, body);

        int id = (int) doWriteRd.getData1();

        Post post = postService.getPostById(id);

        return Ut.jsReplace(doWriteRd.getResultCode(), doWriteRd.getMsg(), "../post/list");
    }


    @RequestMapping("/usr/post/detail")
    public String showDetail(HttpServletRequest req, Model model, int id) {

        Rq rq = (Rq) req.getAttribute("rq");

        Post post = postService.getForPrintPost(rq.getLoginedMemberId(), id);

        ResultData usersReactionRd = reactionService.usersReaction(rq.getLoginedMemberId(), "post", id);

        if(usersReactionRd.isSuccess()){
            model.addAttribute("userCanMakeReaction", usersReactionRd.isSuccess());
        }

        List<Comment> comments = commentService.getForPrintComments(rq.getLoginedMemberId(),"post", id);

        int commentsCount = comments.size();

        model.addAttribute("comments", comments);
        model.addAttribute("commentsCount", commentsCount);
        model.addAttribute("post", post);
        model.addAttribute("usersReaction", usersReactionRd.getData1());
        model.addAttribute("isAlreadyAddLikeRp", reactionService.isAlreadyAddLikeRp(rq.getLoginedMemberId(), id, "post"));

        return "/usr/post/detail";
    }

    @RequestMapping("/usr/post/doIncreaseHitCountRd")
    @ResponseBody
    public ResultData doIncreaseHitCount(int id){

        ResultData increaseHitCountRd = postService.increaseHitCount(id);

        if(increaseHitCountRd.isFail()){
            return increaseHitCountRd;
        }
        return ResultData.newData(increaseHitCountRd, "hitCount", postService.getPostHitCount(id));
    }



    @RequestMapping("/usr/post/list")
    public String showList(HttpServletRequest req, Model model,@RequestParam(required = false) String keyword, @RequestParam(defaultValue = "0") int boardId, @RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "") String searchKeyword, @RequestParam(defaultValue = "title") String searchType) {

        Rq rq = (Rq) req.getAttribute("rq");

        Board board = boardService.getBoardById(boardId);

        if(board == null){
            return rq.historyBackOnView("존재하지 않는 게시판입니다.");
        }

        // 채용공고
        if (boardId == 7) {
            try {
                jobPostingService.saveFromExcel("src/main/resources/jobkorea_requirements.xlsx");
            } catch (Exception e) {
                e.printStackTrace();
            }

            List<JobPosting> allJobs = jobPostingService.getAll();
            List<JobPosting> filteredJobs = new ArrayList<>();

            // 메시지 전달
            String message = null;

            String keywordParam = req.getParameter("keyword"); // 실제 요청에 포함됐는지 확인

            if (keywordParam != null) { // 사용자가 검색을 시도한 경우
                if (keyword != null && !keyword.trim().isBlank()) {
                    String trimmedKeyword = keyword.trim();

                    if ("title".equals(searchType)) {
                        filteredJobs = allJobs.stream()
                                .filter(job -> job.getTitle().contains(trimmedKeyword))
                                .collect(Collectors.toList());
                    } else if ("companyName".equals(searchType)) {
                        filteredJobs = allJobs.stream()
                                .filter(job -> job.getCompanyName().contains(trimmedKeyword))
                                .collect(Collectors.toList());
                    }

                    if (filteredJobs.isEmpty()) {
                        message = "검색 결과가 없습니다.";
                    }
                } else {
                    // 검색창에 아무것도 안 쓰고 검색 버튼만 눌렀을 때
                    message = "검색어를 입력하세요.";
                    filteredJobs = allJobs;
                }
            } else {
                // 검색을 시도하지 않은 경우 (페이지 넘기기 등)
                filteredJobs = allJobs;
            }
            // 페이징 처리
            int itemsPerPage = 10;
            int totalItems = filteredJobs.size();
            int pagesCount = (int) Math.ceil((double) totalItems / itemsPerPage);
            int fromIndex = Math.min((page - 1) * itemsPerPage, totalItems);
            int toIndex = Math.min(fromIndex + itemsPerPage, totalItems);
            List<JobPosting> pagedJobs = filteredJobs.subList(fromIndex, toIndex);

            //  페이지 블록 처리 추가
            int pageBlockSize = 10;
            int currentBlock = (int) Math.ceil((double) page / pageBlockSize);
            int startPage = (currentBlock - 1) * pageBlockSize + 1;
            int endPage = Math.min(startPage + pageBlockSize - 1, pagesCount);

            boolean hasPrev = startPage > 1;
            boolean hasNext = endPage < pagesCount;
            int prevPage = startPage - 1;
            int nextPage = endPage + 1;

            // 모델 전달
            model.addAttribute("jobPostings", pagedJobs);
            model.addAttribute("board", board);
            model.addAttribute("page", page);
            model.addAttribute("pagesCount", pagesCount);
            model.addAttribute("keyword", keyword);        // 검색창 유지용
            model.addAttribute("searchType", searchType);   // 검색타입 유지용
            model.addAttribute("message", message);     // 알림 메시지

            // 페이지 블록 관련 변수 추가
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);
            model.addAttribute("hasPrev", hasPrev);
            model.addAttribute("hasNext", hasNext);
            model.addAttribute("prevPage", prevPage);
            model.addAttribute("nextPage", nextPage);

            return "/usr/post/joblist";

        }

        //  뉴스
        if (boardId == 8) {
            try {
                List<News> allNews = newsService.crawlNews("경호", 5); // 전체 뉴스 가져오기

                int itemsInAPage = 5; // 한 페이지당 몇 개씩 보여줄지
                int totalNewsCount = allNews.size();
                int pagesCount = (int) Math.ceil((double) totalNewsCount / itemsInAPage);

                int fromIndex = (page - 1) * itemsInAPage;
                int toIndex = Math.min(fromIndex + itemsInAPage, totalNewsCount);

                // 실제 보여줄 뉴스 리스트
                List<News> pagedNews = allNews.subList(fromIndex, toIndex);

                // JSP에 넘길 값들
                model.addAttribute("newsList", pagedNews);
                model.addAttribute("pagesCount", pagesCount);
                model.addAttribute("page", page);
                model.addAttribute("board", board);
                model.addAttribute("boardId", boardId);

                return "/usr/post/newslist";

            } catch (InterruptedException e) {
                Thread.currentThread().interrupt(); // 스레드 인터럽트 상태 복구
                return rq.historyBackOnView("뉴스 데이터를 불러오는데 실패했습니다.");
            }
        }

        // 법률 게시판 처리
        if (boardId == 9) {
            List<String> queries = List.of(
                    "경비업법",
                    "청원경찰법", "국가공무원법", "군인사법",
                    "헌법", "민법", "형법", "형사소송법", "행정법",
                    "소방기본법", "소방시설공사업법", "위험물안전관리법"
            );

            List<Map<String, String>> allLaws = new ArrayList<>();

            for (String query : queries) {
                List<Map<String, String>> result = lawService.getLawInfoList(query);
                for (Map<String, String> item : result) {
                    if (item.get("법령명") == null) continue;

                    String lawName = item.get("법령명");
                    if (keyword == null || keyword.isBlank()){
                        allLaws.add(item);
                    }
                    else if (lawName.contains(keyword)){
                        allLaws.add(item);
                    }

                }
            }

            // 페이징 처리
            int numOfRows = 10;
            int totalCount = allLaws.size();
            int pagesCount = (int) Math.ceil((double) totalCount / numOfRows);
            int fromIndex = Math.min((page - 1) * numOfRows, totalCount);
            int toIndex = Math.min(fromIndex + numOfRows, totalCount);
            List<Map<String, String>> pagedLaws = allLaws.subList(fromIndex, toIndex);

            // 모델에 전달
            model.addAttribute("lawList", pagedLaws);
            model.addAttribute("pageNo", page);
            model.addAttribute("pagesCount", pagesCount);
            model.addAttribute("numOfRows", numOfRows);
            model.addAttribute("keyword", searchKeyword);
            model.addAttribute("board", board);

            return "/usr/post/lawlist"; // JSP 파일명
        }


        int postsCount = postService.getPostCount(boardId, searchKeyword, searchType);
        int itemsInAPage = 10;

        int pagesCount = (int) Math.ceil(postsCount / (double) itemsInAPage);

        List<Post> posts = postService.getForPosts(boardId, itemsInAPage, page, searchKeyword, searchType);

        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchType", searchType);
        model.addAttribute("pagesCount", pagesCount);
        model.addAttribute("postsCount", postsCount);
        model.addAttribute("posts", posts);
        model.addAttribute("boardId", boardId);
        model.addAttribute("board", board);
        model.addAttribute("page", page);

        return "/usr/post/list";
    }
}