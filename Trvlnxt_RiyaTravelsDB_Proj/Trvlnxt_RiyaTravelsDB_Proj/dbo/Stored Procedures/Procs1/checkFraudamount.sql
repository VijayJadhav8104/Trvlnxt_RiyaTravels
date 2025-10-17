
CREATE procedure [dbo].[checkFraudamount]
@orderid varchar(50)
as

begin
SELECT (totalFare-TotalDiscount) as totalFare  FROM tblBookMaster
where orderId=@orderid
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[checkFraudamount] TO [rt_read]
    AS [dbo];

