import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.amazonaws.xray.AWSXRay;
import com.amazonaws.xray.entities.Subsegment;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import exceptions.ValidationException;
import io.lumigo.handlers.LumigoConfiguration;
import io.lumigo.handlers.LumigoRequestExecutor;
import lambda.LambdaResponse;
import lombok.extern.slf4j.Slf4j;
import model.CodingTip;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Supplier;

@Slf4j
public class TipsStreamListenerLambda implements RequestHandler<DynamodbEvent, Void> {

    static{
        LumigoConfiguration.builder().token("t_ca20fef8fcdf40efac743").build().init();
    }

    public TipsStreamListenerLambda() {
    }

    @Override
    public Void handleRequest(DynamodbEvent dynamodbEvent, Context context) {

        Supplier<Void> supplier = () -> {
            for (DynamodbEvent.DynamodbStreamRecord record : dynamodbEvent.getRecords()) {

                if (record == null) {
                    continue;
                }
                handleRecord(record);
                log.info("Received a new stream record");
                log.info(record.toString());
            }

            return null;
        };
        return LumigoRequestExecutor.execute(dynamodbEvent, context, supplier);


    }

    boolean handleRecord(DynamodbEvent.DynamodbStreamRecord record) {
        Subsegment subsegment = AWSXRay.beginSubsegment("handleRecord");
        boolean valid = false;
        try {
            // TODO: add logic
            subsegment.putAnnotation("Developer", "Nick");
            subsegment.putMetadata("Company", "TheNickNackjes");
            valid = true;
        } catch (ValidationException e){
            subsegment.addException(e);
        } finally {
            AWSXRay.endSubsegment();
            return valid;
        }
    }
}
