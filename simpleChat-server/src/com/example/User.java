package com.example;

import java.util.LinkedList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.SynchronousQueue;

/**
 * Created by eladlavi on 31/08/2016.
 */
public class User {
    private String userName, password;
    LinkedList<Message> messages;


    public User(String userName, String password) {
        this.userName = userName;
        this.password = password;
        messages = new LinkedList<>();
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
