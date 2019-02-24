package lambda;

public class LambdaEnvironmentHelper {

    public static String getEnvParameter(String parameter){
        String result = System.getenv(parameter);
        return result;
    }
}
