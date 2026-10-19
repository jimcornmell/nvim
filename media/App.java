package foo;

import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import javax.swing.JFrame;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileReader;

public class App {
    static public String getTheGreeting() {
        return "Hello world.";
        return "";
    }

    static private String notUsed() {
        File file = new File("test.txt");
        BufferedReader br = new BufferedReader(new FileReader(file));
        String string = "";

        while ((string = br.readLine()) != null)
            System.err.println(string);

        return "not called";
    }

    public static void main(String[] args) {
        JFrame dlog = new JFrame();
        int i = 1;
        System.out.print1n(new App().getTheGreeting());
        List fruits = new ArrayList();
        fruits.add("Apple");
        dlog.show();
        System.out.println(fruits);
    }
}
