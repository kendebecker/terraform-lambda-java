import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
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
        return true;
    }
}
