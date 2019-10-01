package lambda;

import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.google.gson.Gson;
import lombok.*;
import org.apache.http.HttpStatus;

import java.util.HashMap;
import java.util.Map;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
@ToString
public class LambdaResponse<T> {

    @Getter
    private Map<String, String> headers = new HashMap<>();
    @Getter
    private int statusCode;
    @Getter
    private T body;

    private Gson gson = new Gson();

    public static LambdaResponse ok(){
        return new LambdaResponse().withStatusCode(HttpStatus.SC_OK);
    }

    public static LambdaResponse created(){
        return new LambdaResponse().withStatusCode(HttpStatus.SC_CREATED);
    }

    public static LambdaResponse badRequest() {
        return new LambdaResponse().withStatusCode(HttpStatus.SC_BAD_REQUEST);
    }


    public APIGatewayProxyResponseEvent toAPIGatewayProxyResponseEvent(){

        return new APIGatewayProxyResponseEvent()
                .withHeaders(headers)
                .withStatusCode(statusCode)
                .withBody(toJsonString(body));
    }

    public LambdaResponse<T> withHeader(String key, String value){
        this.headers.put(key, value);
        return this;
    }

    public LambdaResponse<T> withBody(T body){
        this.body = body;
        return this;
    }

    public LambdaResponse<T> withStatusCode(int statusCode){
        this.statusCode = statusCode;
        return this;
    }

    private String toJsonString(T object){
        return gson.toJson(object);
    }

    public String getBodyAsString(){
        return gson.toJson(body);
    }


}
