package com.codequest.models;

public class LeaderboardEntry {
    private int rank;
    private String username;
    private int playerLevel;
    private int completedMissions;
    private int totalXp;

    public LeaderboardEntry() {
    }

    public LeaderboardEntry(int rank, String username, int playerLevel, int completedMissions, int totalXp) {
        this.rank = rank;
        this.username = username;
        this.playerLevel = playerLevel;
        this.completedMissions = completedMissions;
        this.totalXp = totalXp;
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getPlayerLevel() {
        return playerLevel;
    }

    public void setPlayerLevel(int playerLevel) {
        this.playerLevel = playerLevel;
    }

    public int getCompletedMissions() {
        return completedMissions;
    }

    public void setCompletedMissions(int completedMissions) {
        this.completedMissions = completedMissions;
    }

    public int getTotalXp() {
        return totalXp;
    }

    public void setTotalXp(int totalXp) {
        this.totalXp = totalXp;
    }

    public String getRankTitle() {
        if (playerLevel <= 1) return "Novice Coder";
        if (playerLevel == 2) return "Byte Runner";
        if (playerLevel == 3) return "Syntax Sorcerer";
        if (playerLevel == 4) return "Algorithm Knight";
        return "Cyber Overlord";
    }
}

