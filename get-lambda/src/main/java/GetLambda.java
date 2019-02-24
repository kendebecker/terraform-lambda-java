import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import lambda.LambdaExecutionResponse;
import lombok.extern.slf4j.Slf4j;
import model.CodingTip;
import persistence.CodingTipsRepository;

import java.util.List;
import java.util.Optional;


@Slf4j
public class GetLambda implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

    private CodingTipsRepository codingTipsRepository;

    public GetLambda() {
        codingTipsRepository = new CodingTipsRepository();
    }

    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent event, Context context) {
        log.info("Handling get request");

        LambdaExecutionResponse response = getTips();

        log.info("Succesfully executed getTips");

        return response.toAPIGatewayProxyResponseEvent();
    }

    private LambdaExecutionResponse getTips(){
        Optional<List<CodingTip>> codingTips = codingTipsRepository.scanCodingTips();

        if(!codingTips.isPresent()){
            return LambdaExecutionResponse.badRequest();
        }

        return LambdaExecutionResponse.ok().withBody(codingTips.get());
    }
}