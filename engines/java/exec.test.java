// Test file for exec mode - the public class name (ExecTest) must match
// the filename so javac can compile it.
public class ExecTest {
    public static void main(String[] args) {
        System.out.println("EXEC_MODE_TEST_PASSED");
        if (args.length > 0) {
            System.out.println("ARGS: " + String.join(" ", args));
        }
    }
}
