/**
 * Created by qusaias on 10/24/2016.
 */
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
    private String userName, password,emil,phone;
   LinkedList<Message> messages;
    LinkedList<Tool> tools;


    public User(String userName, String password,String emil , String phone) {
        this.userName = userName;
        this.password = password;
        this.emil =  emil;
        this.phone = phone;
      messages = new LinkedList<>();
       tools = new LinkedList<>();
    }



    public String getUserName() {
        return userName;
    }

    public void setEmil(String emil) {
        this.emil = emil;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmil() {
        return emil;
    }

    public String getPhone() {
        return phone;
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