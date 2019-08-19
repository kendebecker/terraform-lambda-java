import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.amazonaws.xray.AWSXRay;
import com.amazonaws.xray.entities.Subsegment;
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


    public PostLambda(){
        gson = new Gson();
        codingTipsRepository = new CodingTipsRepository();
    }

    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent event, Context context) {
        log.info("Received post event");

        String body = event.getBody();

        log.info("Body is [{}]", body);
        Map<String, Object> bodyAsMap = new Gson().fromJson(body, new TypeToken<HashMap<String, Object>>(){}.getType());

        if(!bodyIsValid(bodyAsMap)){
            return LambdaResponse.badRequest().withBody("Bam, bad request! Correct the data.").toAPIGatewayProxyResponseEvent();
        }

        CodingTip tip = gson.fromJson(body, CodingTip.class);
        tip.setDate(Instant.now().toEpochMilli());

        postTip(tip);


        return LambdaResponse.ok().withBody("Tip was successfully added!").toAPIGatewayProxyResponseEvent();

    }

    boolean bodyIsValid(Map<String, Object> map) {
        Subsegment subsegment = AWSXRay.beginSubsegment("Validate Body");
        boolean valid = false;
        try {
            if(!map.containsKey("author") || !map.containsKey("tip")){
                log.info("body was invalid");
                throw new ValidationException("Body was invalid");
            }
            valid = true;
        } catch (ValidationException e){
            subsegment.addException(e);
        } finally {
            AWSXRay.endSubsegment();
            return valid;
        }
    }

    private void postTip(CodingTip tip){
        Subsegment subsegment = AWSXRay.beginSubsegment("CodingTips.postTip");

        subsegment.putAnnotation("Developer", "Nick");
        subsegment.putMetadata("Company", "TheNickNackjes");

        codingTipsRepository.postTip(tip);

        AWSXRay.endSubsegment();
    }
}
