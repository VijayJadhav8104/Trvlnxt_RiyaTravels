CREATE PROCEDURE [dbo].[GetPNRRetrivalFromAudit_Test]                     
@type varchar(20) = ''            
,@OfficeIDList varchar(max)=''           
,@ticketNumber varchar(100) = ''          
,@gdspnr varchar(50) = ''          
as                                  
begin                                  
                                  
select ID,GDSPNR,OfficeID,ICust,InsertedOn,IsBookMasterInserted,IsBookMasterInsertedOn,AirLineNumber,TicketNumber,APE,LOWEST_LOGICAL_FARE_1,LOWEST_LOGICAL_FARE_2,LOWEST_LOGICAL_FARE_3,ErrorMessage,CRSType,TransactionCode,EmpID,IssueDate,QueueNo    
,passengerName,conjTicketNumber,totalFare,baseFare,ticketIssueDate,IATA_Number,Status,TaxDesc,ReasonForIssuance,PassengerType,TicketingStatus,    
GuaranteedFare,FormOfPayment,TotalTax,CommissionRate,TourCode,EquivFare,CurrencyCode,yq,[in],cpnStatus,OB,OC,WO,JN,YM,F2,G1,K3,YR,XT,Fee,Product_Type,SaveCoupon_Flag,    
CRSCode,PCCCode,CreditCardNumber,Commission_Amount,TicketType,OldTicketNo,Canfees,fop,transactionType,MainAgentId,CCExpiryDate    
from PNRRetrivalFromAudit            
where TicketNumber = @ticketNumber AND GDSPNR = @gdspnr           
and [Type] = @type              
and ((@OfficeIDList = '') or (OfficeID IN ( select Data from sample_split(@OfficeIDList,','))))   and ((ICust NOT IN ('BOMCUST000123'))  or  ICust is null)           
                                  
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPNRRetrivalFromAudit_Test] TO [rt_read]
    AS [dbo];

