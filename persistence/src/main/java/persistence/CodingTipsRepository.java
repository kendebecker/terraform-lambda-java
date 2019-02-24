package persistence;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBScanExpression;
import lambda.LambdaEnvironmentHelper;
import lombok.extern.slf4j.Slf4j;
import model.CodingTip;

import java.util.List;
import java.util.Optional;

@Slf4j
public class CodingTipsRepository {

    private static final String REGION = LambdaEnvironmentHelper.getEnvParameter("REGION");
    private static final Integer SCANLIMIT = Integer.parseInt(LambdaEnvironmentHelper.getEnvParameter("SCANLIMIT"));

    private AmazonDynamoDB amazonDynamoDBClient;
    private DynamoDBMapper dynamoDBMapper;

    public CodingTipsRepository(){
        amazonDynamoDBClient = AmazonDynamoDBClientBuilder.standard()
                .withRegion(REGION)
                .build();
        dynamoDBMapper = new DynamoDBMapper(amazonDynamoDBClient);
    }

    public Optional<List<CodingTip>> scanCodingTips(){
        List<CodingTip> scanResult = dynamoDBMapper.scan(CodingTip.class, new DynamoDBScanExpression().withLimit(SCANLIMIT));
        return Optional.ofNullable(scanResult);
    }

    public void postTip(CodingTip tip){
        DynamoDBMapperConfig dynamoDBMapperConfig = new DynamoDBMapperConfig.Builder()
                .withConsistentReads(DynamoDBMapperConfig.ConsistentReads.CONSISTENT)
                .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.PUT)
                .build();
        log.info("Did build mapperconfig");
        dynamoDBMapper.save(tip, dynamoDBMapperConfig);
    }
}
