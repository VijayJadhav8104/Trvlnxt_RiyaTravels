                                                
CREATE procedure [dbo].[API_RiyaPNRDetails] -- API_HoldPNRDetails 'TNA8MO4FA9'                                                
@RiyaPNR varchar(50) = ''                                                
                                                
as begin                                                
                                                
                                        
Select b.OfficeID ,CASE WHEN Lower(b.VendorName) ='sabre' THEN b.ValidatingCarrier else b.JourneySellKey END as ValidatingCarrier, b.GDSPNR,b.orderId,b.AgentID,b.VendorName,b.ROE,b.Country,b.AgentCurrency,p.amount        
,b.B2BMarkup,b.IsBooked,b.BookingStatus,BookingType,CalculationType,DisplayType, b.APITrackID,b.totalFare, b.TFBookingRef, b.JourneySellKey,b.pkId,b.riyaPNR,b.returnFlag,b.AgentROE                  
,(select top 1 Airlinepnr from tblBookItenary where orderId = b.orderId  and airlinePNR != 'null' and airlinePNR != '') as Airlinepnr                  
,(select Sum(SSR_Amount) From tblSSRDetails where tblSSRDetails.fkBookMaster = b.pkId and tblSSRDetails.SSR_Code != 'null' and tblSSRDetails.SSR_Code != '') as SSRTotalFare                  
from tblBookMaster as b WITH (NOLOCK) inner join Paymentmaster as p on b.orderId = p.order_id                                                
where b.riyaPNR = @RiyaPNR and totalFare > 0 and BookingStatus != 18 and BookingStatus != 20 --bookingStatus = 18 means Reissue                                
                                                    
Select pid,ISNULL(paxFName,'') as 'paxFName',ISNULL(paxLName,'') as 'paxLName',ISNULL(paxType,'') as 'paxType',TicketNumber,ticketNum,isReturn,totalFare,B2bMarkup,Markup,ServiceFee,GST,VendorServiceFee      
,IATACommission,PLBCommission,DropnetCommission,MarkupOnTaxFare,fkBookMaster,ParentB2BMarkup                       
from tblPassengerBookDetails       
where fkBookMaster IN (select pkId from tblBookMaster where riyaPNR = @RiyaPNR and BookingStatus != 18 and BookingStatus != 20)                                                       
                                        
select ROW_NUMBER() OVER (ORDER BY Itenary.pkId) - 1 as ID,Itenary.pkId,Itenary.fkBookMaster,Itenary.airlinePNR,Itenary.orderId,Itenary.frmSector,Itenary.toSector, Itenary.isReturnJourney                                    
from tblBookItenary as Itenary                                    
where Itenary.fkBookMaster IN (select pkId from tblBookMaster where riyaPNR = @RiyaPNR and BookingStatus != 18 and BookingStatus != 20)                                     

select SSRDetails.pkid,SSRDetails.fkBookMaster,SSRDetails.fkItenary,SSRDetails.fkPassengerid,SSRDetails.SSR_Code,SSRDetails.SSR_Amount
from tblSSRDetails as SSRDetails
where SSRDetails.fkBookMaster IN (select pkId from tblBookMaster where riyaPNR = @RiyaPNR and BookingStatus != 18 and BookingStatus != 20)  
                          
end 