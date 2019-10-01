import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.amazonaws.xray.AWSXRay;
import com.amazonaws.xray.entities.Subsegment;
import exceptions.ValidationException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class TipsStreamListenerLambda implements RequestHandler<DynamodbEvent, Void> {


    public TipsStreamListenerLambda() {
    }

    @Override
    public Void handleRequest(DynamodbEvent dynamodbEvent, Context context) {

            for (DynamodbEvent.DynamodbStreamRecord record : dynamodbEvent.getRecords()) {

                if (record == null) {
                    continue;
                }
                handleRecord(record);
                log.info("Received a new stream record");
                log.info(record.toString());
            }

            return null;

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
