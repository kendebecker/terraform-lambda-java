import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.google.gson.Gson;
import lombok.*;
import org.apache.http.HttpStatus;

import java.util.HashMap;
import java.util.Map;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class LambdaExecutionResponse<T> {

    @Getter
    private Map<String, String> headers = new HashMap<>();
    @Getter
    private int statusCode;
    @Getter
    private T body;

    private Gson gson = new Gson();

    public static LambdaExecutionResponse ok(){
        return new LambdaExecutionResponse().withStatusCode(HttpStatus.SC_OK);
    }


    public APIGatewayProxyResponseEvent toAPIGatewayProxyResponseEvent(){

        return new APIGatewayProxyResponseEvent()
                .withHeaders(headers)
                .withBody(toJsonString(body));
    }

    public LambdaExecutionResponse<T> withHeader(String key, String value){
        this.headers.put(key, value);
        return this;
    }

    public LambdaExecutionResponse<T> withBody(T body){
        this.body = body;
        return this;
    }

    public LambdaExecutionResponse<T> withStatusCode(int statusCode){
        this.statusCode = statusCode;
        return this;
    }

    private String toJsonString(T object){
        return gson.toJson(object);
    }


}
