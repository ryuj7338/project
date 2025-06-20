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
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
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
    private JobFavoriteService jobFavoriteService;

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
    public String showWrite(@RequestParam int boardId, HttpServletRequest req, Model model) {

        Rq rq = (Rq) req.getAttribute("rq");

        if (boardId == 5 && !rq.getIsAdmin()){
            return rq.historyBackOnView("관리자 권한이 필요합니다.");
        }

        model.addAttribute("boardId", boardId);
        return "/usr/post/write";
    }

    @RequestMapping("/usr/post/doWrite")
    @ResponseBody
    public String doWrite(HttpServletRequest req,
                          @RequestParam(required = false) String title,
                          @RequestParam(required = false) String body,
                          @RequestParam(defaultValue = "1") int boardId,
                          @RequestParam(name = "files", required = false) List<MultipartFile> files) {

        Rq rq = (Rq) req.getAttribute("rq");

        // 관리자 전용 게시판
        if (boardId == 5 && !rq.getIsAdmin()) {
            return Ut.jsHistoryBack("F-3", "관리자만 작성할 수 있습니다.");
        }

        // 일반 사용자 게시판 제한
        if (!rq.getIsAdmin() && !(boardId == 1 || boardId == 2 || boardId == 3 || boardId == 4)) {
            return Ut.jsHistoryBack("F-4", "작성 권한이 없습니다.");
        }

        if (Ut.isEmptyOrNull(title)) return Ut.jsHistoryBack("F-1", "제목을 입력하세요");
        if (Ut.isEmptyOrNull(body)) return Ut.jsHistoryBack("F-2", "내용을 입력하세요");

        StringBuilder finalBody = new StringBuilder(body);

        // 허용 확장자 목록
        List<String> allowedExtensions = List.of("pdf", "pptx", "hwp", "docx", "xlsx", "jpg", "jpeg", "png", "zip");

        if (files != null && !files.isEmpty()) {
            for (MultipartFile file : files) {
                if (!file.isEmpty()) {
                    try {
                        String originalFilename = file.getOriginalFilename();

                        // 확장자 추출
                        String ext = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();

                        // 확장자 제한
                        if (!allowedExtensions.contains(ext)) {
                            return Ut.jsHistoryBack("F-6", "허용되지 않은 파일 형식입니다: " + ext);
                        }

                        // 파일명 정제 (보안 위험 문자 제거)
                        String safeFilename = originalFilename.replaceAll("[^a-zA-Z0-9가-힣._-]", "_");

                        // 중복 방지용 저장 파일명 (UUID)
                        String uuid = java.util.UUID.randomUUID().toString();
                        String savedFileName = uuid + "_" + safeFilename;

                        // 저장 경로
                        String uploadDirPath = "src/main/resources/static/uploadFiles";
                        File uploadDir = new File(uploadDirPath);
                        if (!uploadDir.exists()) uploadDir.mkdirs();

                        File destFile = new File(uploadDir, savedFileName);
                        file.transferTo(destFile);

                        // 게시글에 파일 링크 추가
                        finalBody.append("<br><a href='/uploadFiles/")
                                .append(savedFileName)
                                .append("' target='_blank'>[파일: ")
                                .append(safeFilename)
                                .append("]</a>");

                    } catch (Exception e) {
                        return Ut.jsHistoryBack("F-5", "파일 업로드 중 오류 발생: " + e.getMessage());
                    }
                }
            }
        }

        System.out.println(">> 글 작성 시도: boardId=" + boardId + ", title=" + title);
        // 게시글 작성
        ResultData doWriteRd = postService.writePost(
                rq.getLoginedMemberId(),
                boardId,
                title,
                finalBody.toString()
        );

        System.out.println(">> 결과: " + doWriteRd);
        return Ut.jsReplace(doWriteRd.getResultCode(), doWriteRd.getMsg(), "../post/list?boardId=" + boardId);
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

        List<FileInfo> fileInfos = postService.extractFileInfos(post.getBody());
        model.addAttribute("fileInfos", fileInfos);

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
        int hitcount = (int) postService.getPostHitCount(id);
        return ResultData.newData(increaseHitCountRd, "hitCount", hitcount);
    }



    @RequestMapping("/usr/post/list")
    public String showList(HttpServletRequest req, Model model, @RequestParam(defaultValue = "0") int boardId, @RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "") String searchKeyword, @RequestParam(defaultValue = "title") String searchType) {

        Rq rq = (Rq) req.getAttribute("rq");

        Board board = boardService.getBoardById(boardId);

        if(board == null){
            return rq.historyBackOnView("존재하지 않는 게시판입니다.");
        }



        int postsCount = postService.getPostCount(boardId, searchKeyword, searchType);
        int itemsInAPage = 10;

        int pagesCount = (int) Math.ceil(postsCount / (double) itemsInAPage);

        List<Post> posts = postService.getForPosts(boardId, itemsInAPage, page, searchKeyword, searchType);
        posts = postService.getPostsByBoardId(boardId);

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

    @RequestMapping("/usr/news/list")
    public String newsList(HttpServletRequest req, Model model, @RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "7") int boardId) {

        Rq rq = (Rq) req.getAttribute("rq");

        Board board = boardService.getBoardById(boardId);

        try {
            List<News> allNews = newsService.crawlNews("경호", 5);

            int itemsInAPage = 5;
            int totalNewsCount = allNews.size();
            int pagesCount = (int) Math.ceil((double) totalNewsCount / itemsInAPage);

            int fromIndex = (page - 1) * itemsInAPage;
            int toIndex = Math.min(fromIndex + itemsInAPage, totalNewsCount);
            List<News> pagedNews = allNews.subList(fromIndex, toIndex);

            model.addAttribute("newsList", pagedNews);
            model.addAttribute("pagesCount", pagesCount);
            model.addAttribute("page", page);
            model.addAttribute("board", board);
            model.addAttribute("boardId", boardId);

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return rq.historyBackOnView("뉴스 데이터를 불러오는데 실패했습니다.");
        }

        return "/usr/news/newslist";
    }




    @RequestMapping("/usr/law/list")
    public String showLawList(Model model, @RequestParam(defaultValue = "9") int boardId, @RequestParam(defaultValue = "1") int page, @RequestParam(required = false) String keyword) {

        Board board = boardService.getBoardById(boardId);

        model.addAttribute("board", board);

        // 제외 법률 정보
        List<String> queries = List.of(
                "경비업법", "청원경찰법", "국가공무원법", "군인사법",
                "헌법", "민법", "형법", "형사소송법", "행정법",
                "소방기본법", "소방시설공사업법", "위험물안전관리법"
        );

        List<Map<String, String>> allLaws = new ArrayList<>();

        if (keyword != null && !keyword.trim().isBlank()) {
            String trimmedKeyword = keyword.trim();

            for (String query : queries) {
                List<Map<String, String>> result = lawService.getLawInfoList(query);
                for (Map<String, String> item : result) {
                    if (item.get("법령명") != null && item.get("법령명").contains(trimmedKeyword)) {
                        allLaws.add(item);
                    }
                }
            }

            if (allLaws.isEmpty()) {
                model.addAttribute("message", "검색 결과가 없습니다.");
            }

        } else {
            for (String query : queries) {
                List<Map<String, String>> result = lawService.getLawInfoList(query);
                for (Map<String, String> item : result) {
                    if (item.get("법령명") != null) {
                        allLaws.add(item);
                    }
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

        model.addAttribute("lawList", pagedLaws);
        model.addAttribute("pageNo", page);
        model.addAttribute("pagesCount", pagesCount);
        model.addAttribute("numOfRows", numOfRows);
        model.addAttribute("keyword", keyword);

        return "/usr/law/lawlist";
    }


    @RequestMapping("/usr/job/favorite/toggle")
    @ResponseBody
    public ResultData<?> toggleFavorite(@RequestParam int jobPostingId, HttpServletRequest req) {

        Rq rq = (Rq) req.getAttribute("rq");
        int memberId = rq.getLoginedMemberId();

        if (rq == null || rq.getLoginedMemberId() == 0) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }


        return jobFavoriteService.toggleFavorite(memberId, jobPostingId);
    }

    @RequestMapping("/usr/job/favorite/list")
    public String showFavoriteJobs(HttpServletRequest req, Model model) {
        Rq rq = (Rq) req.getAttribute("rq");
        int memberId = rq.getLoginedMemberId();

        if (memberId == 0) {
            return "redirect:/usr/member/login?msg=로그인이 필요합니다.";
        }

        // 찜한 공고 불러오기
        List<JobPosting> favoriteJobs = jobFavoriteService.getFavoriteJobPostingsWithDday(memberId);

        // D-day 계산
        favoriteJobs = jobPostingService.getFavoriteJobPostingsWithDday(favoriteJobs);
        model.addAttribute("favoriteJobs", favoriteJobs);

        return "/usr/job/favorite";
    }

    @RequestMapping("/usr/job/list")
    public String jobList(HttpServletRequest req, Model model, @RequestParam(defaultValue = "11") int boardId, @RequestParam(defaultValue = "title") String searchType, @RequestParam(required = false) String keyword, @RequestParam(defaultValue = "1") int page) {

        Rq rq = (Rq) req.getAttribute("rq");
        int memberId = rq.getLoginedMemberId();

        List<JobPosting> favoriteJobs = new ArrayList<>();
        if(memberId != 0) {
            favoriteJobs = jobFavoriteService.getFavoriteJobPostingsWithDday(memberId);
        }

        model.addAttribute("logined", memberId != 0);

        List<Long> favoriteJobId = new ArrayList<>();
        for(JobPosting jobPosting : favoriteJobs) {
            favoriteJobId.add(jobPosting.getId());
        }

        model.addAttribute("favoriteJobs", favoriteJobs);
        model.addAttribute("favoriteId", favoriteJobId);

        Board board = boardService.getBoardById(boardId);

        try {
            jobPostingService.saveFromExcel("src/main/resources/jobkorea_requirements.xlsx");
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<JobPosting> allJobs = jobPostingService.getAll();
        List<JobPosting> filteredJobs = new ArrayList<>();
        String message = null;

        String keywordParam = req.getParameter("keyword");

        if (keywordParam != null && keyword != null && !keyword.trim().isBlank()) {
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
            // 검색 안 했거나, 빈 검색어지만 클라이언트에서 JS로 이미 걸러짐
            filteredJobs = allJobs;
        }

        // 페이징 처리
        int itemsPerPage = 10;
        int totalItems = filteredJobs.size();
        int pagesCount = (int) Math.ceil((double) totalItems / itemsPerPage);
        int fromIndex = Math.min((page - 1) * itemsPerPage, totalItems);
        int toIndex = Math.min(fromIndex + itemsPerPage, totalItems);
        List<JobPosting> pagedJobs = filteredJobs.subList(fromIndex, toIndex);

        // 페이지 블록
        int pageBlockSize = 10;
        int currentBlock = (int) Math.ceil((double) page / pageBlockSize);
        int startPage = (currentBlock - 1) * pageBlockSize + 1;
        int endPage = Math.min(startPage + pageBlockSize - 1, pagesCount);

        boolean hasPrev = startPage > 1;
        boolean hasNext = endPage < pagesCount;
        int prevPage = startPage - 1;
        int nextPage = endPage + 1;

        // 모델
        model.addAttribute("jobPostings", pagedJobs);
        model.addAttribute("board", board);
        model.addAttribute("page", page);
        model.addAttribute("pagesCount", pagesCount);
        model.addAttribute("keyword", keyword);
        model.addAttribute("searchType", searchType);
        model.addAttribute("message", message);

        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("hasPrev", hasPrev);
        model.addAttribute("hasNext", hasNext);
        model.addAttribute("prevPage", prevPage);
        model.addAttribute("nextPage", nextPage);

        return "/usr/job/joblist";
    }
}