package com.bean;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.util.DBUtil;

public class VoteBean {
    private List<Candidate> candidates;
    
    public VoteBean() {
        loadCandidatesFromDB();
    }
    
    private void loadCandidatesFromDB() {
        candidates = new ArrayList<>();
        List<Map<String, Object>> dbCandidates = DBUtil.getAllCandidatesWithVotes();
        
        for (Map<String, Object> row : dbCandidates) {
            Candidate candidate = new Candidate();
            candidate.setId(((Integer) row.get("id")));
            candidate.setName((String) row.get("name"));
            candidate.setDescription((String) row.get("description"));
            candidate.setVoteCount(((Long) row.get("vote_count")).intValue());
            candidates.add(candidate);
        }
    }
    
    // 内部类：候选人
    public static class Candidate {
        private int id;
        private String name;
        private String description;
        private int voteCount;
        
        // getters and setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public int getVoteCount() { return voteCount; }
        public void setVoteCount(int voteCount) { this.voteCount = voteCount; }
    }
    
    public List<Candidate> getCandidates() {
        return candidates;
    }
    
    public int getTotalVotes() {
        return DBUtil.getTotalVotes();
    }
    
    public double getPercentage(int index) {
        if (index < 0 || index >= candidates.size()) return 0;
        int total = getTotalVotes();
        if (total == 0) return 0;
        return (candidates.get(index).getVoteCount() * 100.0) / total;
    }
    
    // 新增方法：根据候选人ID获取百分比
    public double getPercentageById(int candidateId) {
        for (int i = 0; i < candidates.size(); i++) {
            if (candidates.get(i).getId() == candidateId) {
                return getPercentage(i);
            }
        }
        return 0;
    }

    public boolean voteFor(int candidateId, String sessionId, String ipAddress) {
        return DBUtil.recordVote(candidateId, sessionId, ipAddress);
    }
    
    public boolean hasVoted(String sessionId) {
        return DBUtil.hasVoted(sessionId);
    }
}