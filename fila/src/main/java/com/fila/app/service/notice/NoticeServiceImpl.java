package com.fila.app.service.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fila.app.domain.notice.NoticeVO;
import com.fila.app.mapper.notice.NoticeMapper;

import lombok.Setter;

@Service
public class NoticeServiceImpl implements NoticeService {

    @Setter(onMethod_ = @Autowired)
    private NoticeMapper noticeMapper;

    @Override
    public List<NoticeVO> getNoticeList(String category, String keyword) {
        // Mapper에게 필터 조건 전달
        return noticeMapper.selectList(category, keyword);
    }

    @Override
    public NoticeVO getNoticeDetail(int noticeId) {
        return noticeMapper.selectOne(noticeId);
    }

    @Override
    public int writeNotice(NoticeVO notice) {
        return noticeMapper.insert(notice);
    }

    @Override
    public int removeNotice(int noticeId) {
        return noticeMapper.delete(noticeId);
    }
}