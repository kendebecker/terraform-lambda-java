import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import exceptions.ValidationException;
import lambda.LambdaResponse;
import lombok.extern.slf4j.Slf4j;
import model.CodingTip;
import persistence.CodingTipsRepository;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@Slf4j
public class PostLambda implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {
    private Gson gson;

    private CodingTipsRepository codingTipsRepository;


    public PostLambda() {
        gson = new Gson();
        codingTipsRepository = new CodingTipsRepository();
    }

    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent event, Context context) {

        log.info("Received post event");

        String body = event.getBody();

        log.info("Body is [{}]", body.replace(System.getProperty("line.separator"), ""));
        Map<String, Object> bodyAsMap = new Gson().fromJson(body, new TypeToken<HashMap<String, Object>>() {
        }.getType());

        if (!bodyIsValid(bodyAsMap)) {
            return LambdaResponse.badRequest().withBody("Bam, bad request! Correct the data.").toAPIGatewayProxyResponseEvent();
        }

        CodingTip tip = gson.fromJson(body, CodingTip.class);
        tip.setDate(Instant.now().toEpochMilli());

        postTip(tip);


        return LambdaResponse.created().withBody("Tip was successfully added!").toAPIGatewayProxyResponseEvent();
    }

    boolean bodyIsValid(Map<String, Object> map) {
        boolean valid = false;
        // typically you validate against the dto's generated from the swagger
        if (!map.containsKey("author") || !map.containsKey("tip")) {
            log.info("body was invalid");
            return false;
//            throw new ValidationException("Body was invalid");
        }
        valid = true;
        return valid;
    }

    private void postTip(CodingTip tip) {
        codingTipsRepository.postTip(tip);
    }
}
