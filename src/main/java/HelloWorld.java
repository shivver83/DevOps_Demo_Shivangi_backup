import spark.servlet.SparkApplication;
import static spark.Spark.get;

public class HelloWorld implements SparkApplication {
	public static void main(String[] args) {
		new HelloWorld().init();
	}

	@Override
	public void init() {
		get("/", (req, res) -> " WELCOME to devopsarea v-1.0  - Demo by Shivangi Gupta ");
	}
}
