

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Set;

/**
 * Created by eladlavi on 31/08/2016.
 */
public class MainServlet extends javax.servlet.http.HttpServlet {

    public static final String FAILURE = "failure";
    public static final String SUCCESS = "success";
    public static final String RESULT = "result";
    // private String message = "empty";
    private HashMap<String, User> users;

    //  private LinkedList<Tool> At;
    private int tmp = 0;

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("qusai");
        users = new HashMap<>();

        // At = new LinkedList<>();
    }

    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        System.out.println("ok2");

        StringBuilder stringBuilder = new StringBuilder();
        int actuallyRead;
        InputStream inputStream = request.getInputStream();
        byte[] buffer = new byte[256];
        while ((actuallyRead = inputStream.read(buffer)) != -1) {
            stringBuilder.append(new String(buffer, 0, actuallyRead));
            System.out.println(stringBuilder.toString());

        }
        JSONObject jsonResponse = new JSONObject();
        try {
            JSONObject jsonRequest = new JSONObject(stringBuilder.toString());
            String action = jsonRequest.getString("action");
            System.out.println("hey");

            boolean success = false;
            String userName = jsonRequest.getString("userName");
            if (userName.isEmpty())
                jsonResponse.put(RESULT, FAILURE);
            else {
                switch (action) {
                    case "login":
                        success = login(userName, jsonRequest.getString("password"));
                        break;
                    case "signup":
                        System.out.println("heyRR");
                        success = signUp(userName, jsonRequest.getString("password"), jsonRequest.getString("emil"), jsonRequest.getString("phone"));
                        System.out.println(success);
                         break;
                    case "getMessages":
                        if (login(userName, jsonRequest.getString("password"))) {
                            success = true;
                            jsonResponse.put("messages", getMessages(userName));
                        }
                        break;
                    case "sendMessage":
                        if (login(userName, jsonRequest.getString("password"))) {
                            success = sendMessage(jsonRequest.getString("text"),
                                    jsonRequest.getString("recipient"), userName);
                        }
                        break;
                    case "getTools":

                        if (login(userName, jsonRequest.getString("password"))) {
                            success = true;
                            jsonResponse.put("tools", getTools());
                        }
                    case "getMyTool":
                        if (login(userName, jsonRequest.getString("password"))) {
                            success = true;
                            jsonResponse.put("tool", getMyTool(userName));
                        }
                        break;
                    case "getUsers":
                        if (login(userName, jsonRequest.getString("password"))) {
                            success = true;
                            jsonResponse.put("users", getUsers());
                        }
                        break;
                    case "addTool":
                        if (login(userName, jsonRequest.getString("password"))) {
                            success = addTool(userName, jsonRequest.getString("ToolName"), jsonRequest.getString("Tooltype"), jsonRequest.getString("ToolDec"), jsonRequest.getString("ToolPrice"));

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
        while ((msg = u.messages.poll()) != null) {
            JSONObject jsonMessage = new JSONObject();
            jsonMessage.put("text", msg.getText());
            jsonMessage.put("sender", msg.getSender());
            jsonMessages.put(jsonMessage);
        }
        return jsonMessages;
    }


    private JSONArray getUsers() {
        JSONArray jsonUsers = new JSONArray();
        Set<String> userNames = users.keySet();
        for (String userName : userNames)
            jsonUsers.put(userName);
        return jsonUsers;
    }

    private JSONArray getTools() throws JSONException {
        JSONArray jsonTools = new JSONArray();
        int x = users.size();
        System.out.println("size users "+x);
        Set<String> userTools = users.keySet();
        Tool tol;
        for (String userTool : userTools)

            for (int i = 0; i < users.get(userTool).tools.size(); i++) {

                tol = users.get(userTool).tools.get(i);
                JSONObject jsonMessage = new JSONObject();
                jsonMessage.put("type", tol.getTooltype());
                jsonMessage.put("name", tol.getToolName());
                jsonMessage.put("desc", tol.getToolDec());
                jsonMessage.put("price", tol.getToolPrice());
                jsonMessage.put("phone", users.get(userTool).getPhone());

                jsonTools.put(jsonMessage);
                System.out.println(jsonTools);


               // jsonTools.put(users.get(userTool));

            }
        return jsonTools;
    }


    private JSONArray getMyTool(String username) throws JSONException {
        User u = users.get(username);
        System.out.println("my tool now"+u.tools);
        JSONArray jsonmytool = new JSONArray();
        Tool tol;
        for (int i = 0; i <u.tools.size() ; i++) {


                tol=u.tools.get(i);
            JSONObject jsonMessage = new JSONObject();
            jsonMessage.put("type", tol.getTooltype());
            jsonMessage.put("name", tol.getToolName());
            jsonMessage.put("desc", tol.getToolDec());
            jsonMessage.put("price", tol.getToolPrice());
            jsonMessage.put("phone",u.getPhone());

            jsonmytool.put(jsonMessage);
            System.out.println(jsonmytool);
    }


        return jsonmytool;
    }
    private Boolean addTool(String username,String toolname,String tooltype,String tooldesc,String toolprice) {
        User u = users.get(username);
        if (u == null) {
            return false;
        }
        Tool tol = new Tool(toolname, tooldesc, tooltype, toolprice);
       // At.add(tol);

        u.tools.add(tol);

        return true;
    }


    private boolean login(String userName, String password){
        System.out.println("login now");
        User u = users.get(userName);
        if(u == null)
            return false;
        if(u.getPassword().equals(password))
            return true;
        return false;
    }

    private boolean signUp(String userName, String password,String emil,String phone){
        System.out.println("hey real");
        User u = new User(userName, password, emil, phone );
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
        /*    String q = request.getQueryString();
            if(q.equals("check")){
                response.getWriter().write(message);
            }else{
                message = q;
                response.getWriter().write("thanks");
                System.out.println("ok");
            }
*/
    }
}
