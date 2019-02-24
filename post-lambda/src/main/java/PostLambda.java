import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.google.gson.Gson;
import lambda.LambdaExecutionResponse;
import lombok.extern.slf4j.Slf4j;
import model.CodingTip;

@Slf4j
public class PostLambda implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

    private Gson gson;

    public PostLambda(){
        gson = new Gson();
    }

    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent event, Context context) {
        log.info("Received post event");

        String body = event.getBody();

        log.info("Body is [{}]", body);

        CodingTip tip = gson.fromJson(body, CodingTip.class);

        log.info(tip.toString());

        return LambdaExecutionResponse.ok().toAPIGatewayProxyResponseEvent();

    }
}
