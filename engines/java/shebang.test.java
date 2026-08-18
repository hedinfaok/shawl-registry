// Test file for shebang mode - the public class name (ShebangTest) must match
// the filename so javac can compile it.
public class ShebangTest {
    public static void main(String[] args) {
        System.out.println("SHEBANG_MODE_TEST_PASSED");
        if (args.length > 0) {
            System.out.println("ARGS: " + String.join(" ", args));
        }
    }
}
