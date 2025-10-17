CREATE PROCEDURE [dbo].[GetPNRRetrivalFromAudit_Failed]  --'TJQ','DCA1S2427,GAI1S2400','0'                          
@type varchar(20) = ''                      
,@OfficeIDList varchar(max)=''              
,@IsBookMasterInserted varchar(10) = '0'              
as                                            
begin                                            
                                            
select ID,GDSPNR,OfficeID,ICust,InsertedOn,IsBookMasterInserted,IsBookMasterInsertedOn,AirLineNumber,TicketNumber,APE,LOWEST_LOGICAL_FARE_1,LOWEST_LOGICAL_FARE_2,LOWEST_LOGICAL_FARE_3,ErrorMessage,CRSType,TransactionCode,EmpID,IssueDate,QueueNo           
  
    
                  
,passengerName,conjTicketNumber,totalFare,baseFare,ticketIssueDate,IATA_Number,Status,TaxDesc,ReasonForIssuance,PassengerType,TicketingStatus,              
GuaranteedFare,FormOfPayment,TotalTax,CommissionRate,TourCode,EquivFare,CurrencyCode,yq,[in],cpnStatus,OB,OC,WO,JN,YM,F2,G1,K3,YR,XT,Fee,Product_Type,SaveCoupon_Flag,              
CRSCode,PCCCode,CreditCardNumber,Commission_Amount,TicketType,OldTicketNo,Canfees,fop,transactionType,MainAgentId,CCExpiryDate                      
from PNRRetrivalFromAudit_Failed                      
where (IsBookMasterInserted is null OR IsBookMasterInserted = '' OR IsBookMasterInserted = @IsBookMasterInserted)                      
and [Type] = @type                        
and ((@OfficeIDList = '') or (OfficeID IN ( select Data from sample_split(@OfficeIDList,','))))          
and ISNULL((select top 1 isnull(country,'') 
from B2BRegistration where Icast = ICust),'') != 'UAE' and (( ICust != 'BOMCUST000123') or  ICust is null)    
          
end