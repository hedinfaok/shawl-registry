// Test file for druid mode - the public class name (DruidTest) must match
// the filename so javac can compile it.
public class DruidTest {
    public static void main(String[] args) {
        System.out.println("DRUID_MODE_TEST_PASSED");
        if (args.length > 0) {
            System.out.println("ARGS: " + String.join(" ", args));
        }
    }
}
