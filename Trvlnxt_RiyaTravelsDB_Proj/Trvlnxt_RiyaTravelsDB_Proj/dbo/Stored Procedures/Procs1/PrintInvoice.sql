--sp_helptext PrintInvoice                          
                          
-- =============================================                                  
-- Author:  <Author,,Name>                                  
-- Create date: <Create Date,,>                                  
-- Description: <Description,,>                                  
-- =============================================                                  
CREATE PROCEDURE PrintInvoice -- PrintInvoice 1249                               
                                   
 @Id int                                  
                                  
AS                                  
BEGIN                                  
                                   
 select                                   
 -- ROW_NUMBER() OVER (ORDER BY pkId) SrNo                                  
 --  ,PM.Salutation+' '+PM.FirstName as TravellerName                                  
  distinct HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName as TravellerName                            
  -- ,ROUND(Cast((cast(RoEB.Rate as float) * cast(isnull((HB.DisplayDiscountRate - BC.RiyaCommission),1) as float)) as float),2) AS [SubTotalAmoun]                 
 ,(HB.DisplayDiscountRate -CEILING(ISNULL(BC.EarningAmount,'0.0'))) as [SubTotalAmoun]                
 -- ,ROW_NUMBER() OVER (ORDER BY HB.pkId) SrNo                                 
  ,ISNULL(HB.HotelAddress1,'')as HotelAddress1                                  
  ,ISNULL(HB.CountryName,'')as CountryName                                  
  ,ISNULL(HB.AgentRefNo,'')as AgentRefNo                                  
  ,ISNULL(HB.HotelPhone ,'')as HotelPhone                                   
  ,ISNULL(FORMAT(HB.inserteddate,'dd/MM/yyyy'),'')as inserteddate                                  
  ,ISNULL(HB.BookingReference,'')as BookingReference                                  
  ,ISNULL(FORMAT(HB.CheckInDate,'dd/MM/yyyy'),'')as CheckInDate                                  
  ,ISNULL(FORMAT(HB.CheckOutDate,'dd/MM/yyyy'),'')as CheckOutDate                                  
  ,ISNULL(HB.SelectedNights,0)as SelectedNights                                  
  ,ISNULL(HB.HotelName,'')as HotelName                               
  ,ISNULL(HB.cityName,'')as HotelCity                               
  ,HB.LeaderTitle+' '+HB.LeaderFirstName +' '+hb.LeaderLastName as Leader                                  
  ,ISNULL(HB.VoucherNumber,'')as VoucherNumber                                  
  ,ISNULL(HR.RoomTypeDescription,'')as RoomType                                  
  ,ISNULL(HB.TotalRooms,0) as Room                                  
  ,'' as RateBreakup                                  
  ,'' as Amount                          
  ,ISNULL(BM.TotalCommission,'0.0') as PaymentGatewayCharges                            
  ,ISNULL(HB.MarkupCurrency,'') as CurrencyCode                                  
 --,ISNULL(HB.TotalDiscount,'0.0') as TotalDiscount                            
 -- ,cast(ISNULL(BC.EarningAmount,'0.0')as Int) as TotalDiscount       
  ,CEILING(ISNULL(BC.EarningAmount,'0.0')) as TotalDiscount                           
     
  ,ISNULL(BC.TDSDeductedAmount,'0.0') as TDSAmount                   
  --,ROUND(Cast((cast(RoEB.Rate as float) * cast(isnull((BC.TDSDeductedAmount),'0.0') as float)) as float),2)  as TDSAmount                
                 
  ,ISNULL(BR.AgencyName,'')as AgentName                                
  ,ISNULL(BR.AddrAddressLocation,'') as AgentAddress              
  ,isnull(BR.Icast,'')+ ISNULL(+'-'+Al2.FirstName,'') as AgentIcast  --akash  Icust - SubagentIdName        
  --,'0' as SubTotalAmoun                           
                            
                                    
 --,HB.AppliedAgentCharges as TotalAmount                                     
 ,HB.DisplayDiscountRate as TotalAmount              
              
 -- ,ROUND(Cast((cast(RoEB.Rate as float) * cast(isnull((HB.DisplayDiscountRate),1) as float)) as float),2) as TotalAmount,                                
  ,ISNULL(MU.FullName , '') as ConsultantName                
  ,'' as BankName                                  
  ,'' as AccountName                           
  ,'' as AccountNumber                                  
  ,'' as AccountType                                  
  ,'' as IFSC                                  
  ,'' as Branch             
  ,AGL.City                              
  ,AGL.country                              
  ,Br.AgencyName          
  ,HB.HotelConfNumber as 'HotelConfirmationNumber'  
  ,AGL.FirstName as 'User'  
        
 from Hotel_BookMaster HB                                  
  join Hotel_Pax_master PM on HB.pkId=PM.book_fk_id                     
  join Hotel_Room_master HR on HB.pkId=HR.book_fk_id                                  
  join AgentLogin AGL on HB.RiyaAgentID=AGL.UserID                                
 join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                 
  left join Hotel_CountryMaster CM on HB.CountryName=Cm.ID                              
  left join muser MU on HB.MainAgentID=MU.ID                           
 left join B2BHotel_Commission BC on HB.pkId = BC.Fk_BookId                          
 left JOIN B2BMakepaymentCommission BM on HB.pkId=BM.FkBookId                         
 left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId 
 left  join agentLogin Al2 on Al2.UserID=HB.SubAgentId 

 where HB.pkId=@Id                                 
                                  
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[PrintInvoice] TO [rt_read]
    AS [dbo];

