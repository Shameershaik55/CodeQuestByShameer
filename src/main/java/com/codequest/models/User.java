package com.codequest.models;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private int totalXp;
    private int playerLevel;
    private Timestamp createdAt;

    public User() {
    }

    public User(String username, String email, String password) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.totalXp = 0;
        this.playerLevel = 1;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getTotalXp() {
        return totalXp;
    }

    public void setTotalXp(int totalXp) {
        this.totalXp = totalXp;
    }

    public int getPlayerLevel() {
        return playerLevel;
    }

    public void setPlayerLevel(int playerLevel) {
        this.playerLevel = playerLevel;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Helper title badge based on player level
    public String getRankTitle() {
        if (playerLevel <= 1) return "Novice Coder";
        if (playerLevel == 2) return "Byte Runner";
        if (playerLevel == 3) return "Syntax Sorcerer";
        if (playerLevel == 4) return "Algorithm Knight";
        return "Cyber Overlord";
    }

    // Progress percentage to the next level (threshold = 100 XP per level)
    public int getLevelProgressPercent() {
        int currentLevelFloorXp = (playerLevel - 1) * 100;
        int xpInCurrentLevel = totalXp - currentLevelFloorXp;
        if (xpInCurrentLevel < 0) xpInCurrentLevel = 0;
        if (xpInCurrentLevel > 100) xpInCurrentLevel = 100;
        return xpInCurrentLevel;
    }

    public int getXpToNextLevel() {
        int nextLevelThreshold = playerLevel * 100;
        int remaining = nextLevelThreshold - totalXp;
        return (remaining > 0) ? remaining : 0;
    }
}

