import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.google.gson.Gson;
import lambda.LambdaExecutionResponse;
import lombok.extern.slf4j.Slf4j;
import model.CodingTip;
import persistence.CodingTipsRepository;

@Slf4j
public class PostLambda implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

    private Gson gson;
    private CodingTipsRepository codingTipsRepository;


    public PostLambda(){
        gson = new Gson();
        codingTipsRepository = new CodingTipsRepository();
    }

    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent event, Context context) {
        log.info("Received post event");

        String body = event.getBody();

        log.info("Body is [{}]", body);

        CodingTip tip = gson.fromJson(body, CodingTip.class);

        log.info(tip.toString());

        postTip(tip);

        return LambdaExecutionResponse.ok().toAPIGatewayProxyResponseEvent();

    }

    private void postTip(CodingTip tip){
        log.info("Posting tip [{}]", tip.toString());
        codingTipsRepository.postTip(tip);
        log.info("Posted tip");
    }
}
