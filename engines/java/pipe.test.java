// Test file for pipe mode - the public class name (PipeTest) must match
// the filename so javac can compile it.
public class PipeTest {
    public static void main(String[] args) {
        System.out.println("PIPE_MODE_TEST_PASSED");
        if (args.length > 0) {
            System.out.println("ARGS: " + String.join(" ", args));
        }
    }
}
