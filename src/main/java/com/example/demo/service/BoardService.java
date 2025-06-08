package com.example.demo.service;

import com.example.demo.repository.BoardRepository;
import com.example.demo.vo.Board;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardService {

    @Autowired
    private BoardRepository boardRepository;

    public BoardService(BoardRepository boardRepository) {
        this.boardRepository = boardRepository;
    }

    public Board getBoardById(int boardId){
        return boardRepository.getBoardById(boardId);
    }
}
