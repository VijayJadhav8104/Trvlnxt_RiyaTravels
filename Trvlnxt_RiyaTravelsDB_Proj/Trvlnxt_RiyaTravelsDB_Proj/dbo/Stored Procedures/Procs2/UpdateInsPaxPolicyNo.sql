CREATE PROCEDURE [dbo].[UpdateInsPaxPolicyNo] 
@policyNumber varchar(50),
@orderNumber varchar(50),
@basePremium decimal(18, 2)=null,
@serviceTax decimal(18, 2)=null,
@totalFare decimal(18, 2),
@Markupamt decimal(18, 2)=null,
@MarkupPerc decimal(18, 2)=null,
@orderID varchar(50),
@BookingStatus int,
@paxID int,
@individualPolicyFulfillmentUrl nvarchar(MAX)=null

AS BEGIN
		IF(@BookingStatus = 1)
		BEGIN
			UPDATE tblInspassengerdetails SET policyNumber = @policyNumber,individualPolicyFulfillmentUrl=@individualPolicyFulfillmentUrl,orderNumber=@orderNumber,
			PaxStatus=1,BookingStatus=1,totalFare=@totalFare,ManagementMarkupAmt=@Markupamt
			WHERE pkid = @paxID and orderID =@orderID
		END
END

