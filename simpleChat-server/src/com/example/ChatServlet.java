package com.example;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Set;

/**
 * Created by eladlavi on 31/08/2016.
 */
public class ChatServlet extends javax.servlet.http.HttpServlet {

    public static final String FAILURE = "failure";
    public static final String SUCCESS = "success";
    public static final String RESULT = "result";
    //private String message = "empty";
    private HashMap<String, User> users;


    @Override
    public void init() throws ServletException {
        super.init();

        users = new HashMap<>();
    }

    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        StringBuilder stringBuilder = new StringBuilder();
        int actuallyRead;
        InputStream inputStream = request.getInputStream();
        byte[] buffer = new byte[256];
        while((actuallyRead = inputStream.read(buffer)) != -1){
            stringBuilder.append(new String(buffer, 0, actuallyRead));
        }
        JSONObject jsonResponse = new JSONObject();
        try {
            JSONObject jsonRequest = new JSONObject(stringBuilder.toString());
            String action = jsonRequest.getString("action");
            boolean success = false;
            String userName = jsonRequest.getString("userName");
            if(userName.isEmpty())
                jsonResponse.put(RESULT, FAILURE);
            else {
                switch (action) {
                    case "login":
                        success = login(userName, jsonRequest.getString("password"));
                        break;
                    case "signup":
                        success = signUp(userName, jsonRequest.getString("password"));
                        break;
                    case "getMessages":
                        if(login(userName, jsonRequest.getString("password"))) {
                            success = true;
                            jsonResponse.put("messages", getMessages(userName));
                        }
                        break;
                    case "sendMessage":
                        if(login(userName, jsonRequest.getString("password"))) {
                            success = sendMessage(jsonRequest.getString("text"),
                                    jsonRequest.getString("recipient"), userName);
                        }
                        break;
                    case "getUsers":
                        if(login(userName, jsonRequest.getString("password"))) {
                            success = true;
                            jsonResponse.put("users", getUsers());
                        }
                        break;
                }
                jsonResponse.put(RESULT, success ? SUCCESS : FAILURE);
            }
        } catch (JSONException e) {
            try {
                jsonResponse.put(RESULT, FAILURE);
                jsonResponse.put("error", e.getMessage());
            } catch (JSONException e1) {
                e1.printStackTrace();
            }
        }
        OutputStream outputStream = response.getOutputStream();
        byte[] responseBytes = jsonResponse.toString().getBytes();
        BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(outputStream);
        bufferedOutputStream.write(responseBytes);
        bufferedOutputStream.close();
        outputStream.close();
        inputStream.close();

    }

    private JSONArray getMessages(String userName) throws JSONException {
        User u = users.get(userName);
        JSONArray jsonMessages = new JSONArray();
        Message msg;
        while ((msg = u.messages.poll()) != null){
            JSONObject jsonMessage = new JSONObject();
            jsonMessage.put("text", msg.getText());
            jsonMessage.put("sender", msg.getSender());
            jsonMessages.put(jsonMessage);
        }
        return jsonMessages;
    }


    private JSONArray getUsers(){
        JSONArray jsonUsers = new JSONArray();
        Set<String> userNames = users.keySet();
        for(String userName : userNames)
            jsonUsers.put(userName);
        return jsonUsers;
    }

    private boolean login(String userName, String password){
        User u = users.get(userName);
        if(u == null)
            return false;
        if(u.getPassword().equals(password))
            return true;
        return false;
    }

    private boolean signUp(String userName, String password){
        User u = new User(userName, password);
        boolean success = false;
        synchronized (users){
            if(users.containsKey(userName))
                success = false;
            else{
                users.put(userName, u);
                success = true;
            }
        }
        return success;
    }

    private boolean sendMessage(String text, String recipient, String sender){
        User u = users.get(recipient);
        if(u == null)
            return false;
        Message msg = new Message(text, sender);
        u.messages.add(msg);
        return true;
    }

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        /*String q = request.getQueryString();
        if(q.equals("check")){
            response.getWriter().write(message);
        }else{
            message = q;
            response.getWriter().write("thanks");
        }*/

    }
}
