package model;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBRangeKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;
import lombok.Generated;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@DynamoDBTable(tableName = "CodingTips-java-dynamodb")
public class CodingTip {

    @DynamoDBHashKey(attributeName = "Author")
    private String author;
    @DynamoDBRangeKey(attributeName = "Date")
    private Long date;
    @DynamoDBAttribute(attributeName = "Tip")
    private String tip;
}
