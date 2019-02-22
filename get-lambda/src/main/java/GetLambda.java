import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;

import com.amazonaws.services.lambda.runtime.Context;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class GetLambda implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {


    public GetLambda() {
    }

    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent event, Context context) {

        log.info("Input: " + event.toString());
        String output = "Hello WORLD";

        log.info("Responding with body {}", output);

        LambdaExecutionResponse lambdaExecutionResponse = LambdaExecutionResponse.ok().withBody(output);

        return lambdaExecutionResponse.toAPIGatewayProxyResponseEvent();
    }
}