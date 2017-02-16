/**
 * Created by qusaias on 11/17/2016.
 */
public class Tool {
    String ToolName;
    String ToolDec;
    String Tooltype;
    String ToolPrice;

    public Tool(String ToolName,String ToolDec,String Tooltype,String ToolPrice){
        this.ToolName = ToolName;
        this.ToolDec = ToolDec;
        this.Tooltype = Tooltype;
        this.ToolPrice = ToolPrice;
    }

    public String getToolDec() {
        return ToolDec;
    }

    public String getToolName() {
        return ToolName;
    }

    public String getToolPrice() {
        return ToolPrice;
    }

    public String getTooltype() {
        return Tooltype;
    }

    public void setToolDec(String toolDec) {
        ToolDec = toolDec;
    }

    public void setToolName(String toolName) {
        ToolName = toolName;
    }

    public void setToolPrice(String toolPrice) {
        ToolPrice = toolPrice;
    }

    public void setTooltype(String tooltype) {
        Tooltype = tooltype;
    }
}
