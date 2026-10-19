package foo

import org.slf4j.Logger
import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.util.ArrayList
import java.util.List
import javax.swing.JFrame


class App {

    companion object {
        fun getTheGreeting(): String {
            return "Hello world."
            return ""
        }

        private fun notUsed(): String {
            val file = File("test.txt")
            val br = BufferedReader(FileReader(file))
            var string = ""

            while (br.readLine().also { string = it } != null) {
                System.err.println(string)
            }

            return "not called"
        }
    }

    fun main(args: Array<String>) {

        val dlog = JFrame()
        var i = 1
        System.out.println(App().getTheGreeting())
        val fruits: List<String> = ArrayList()
        fruits.add("Apple")
        dlog.show()
        System.out.println(fruits)
    }
}
