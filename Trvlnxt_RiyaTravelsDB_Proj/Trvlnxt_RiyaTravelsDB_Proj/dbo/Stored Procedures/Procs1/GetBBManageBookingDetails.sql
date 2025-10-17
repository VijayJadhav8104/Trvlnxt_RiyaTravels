-- =============================================                                                                  
-- Author:  <Author,,Name>                                                                  
-- Create date: <Create Date,,>                                                                  
-- Description: <Description,,>                                                                  
-- execute [GetBBManageBookingDetails] '31337','830','2023-02-01','2023-02-20','','','','','0','','','' ,'','',''                                                              
-- =============================================                                                                  
CREATE PROCEDURE [dbo].[GetBBManageBookingDetails]                                                                  
 -- Add the parameters for the stored procedure here                                                                  
    --Last Modified by Gaurav for User Filter 28/03/22                                                      
                                                           
 @AgentId varchar(10) = '' ,                                                          
 @MainAgentId varchar(max) = '' ,                                                               
 @BookingFromDate varchar(50) ='', -- mm dd yyyy                                                                  
 @BookingTodate varchar(50) ='',                                                          
 @CheckInFromDate datetime ='',                                                          
 @CheckInTodate datetime ='',                                                          
 @DeadLineFromDate datetime ='',                                                               
 @DeadLineTodate datetime ='',                                                             
 @BookingStatus varchar(200)='',                                                          
 @BookingNo varchar(50)='',                                                  
@StateId int=0,                                
@RiyaAgentId varchar (50) = '',                             
@SubMainAgentId varchar (50) = '',                            
@PassengerPhone varchar (50) = '' ,                
@PassengerEmail varchar (50)='',                
@PassengerName varchar (50)='' ,            
@DisplayDiscountRate int ='',            
@cityName varchar (50) = ''            
            
                                                           
                                                                
AS                                                                  
BEGIN                                                                  
                                                            
  if @BookingTodate in ('',NULL)                                                          
set @BookingTodate = DATEADD(DAY,1,@BookingFromDate)                                                          
else set @BookingTodate = DATEADD(DAY,1,@BookingTodate)                                                          
                                                          
                                                          
if @CheckInTodate in ('',NULL)                                                          
set @CheckInTodate = DATEADD(DAY,1,@CheckInFromDate)                                                          
else set @CheckInTodate = DATEADD(DAY,1,@CheckInTodate)                                                          
                                                          
                                                          
if @DeadLineTodate in ('',NULL)                                                          
set @DeadLineTodate = DATEADD(DAY,1,@DeadLineFromDate)                                                          
else set @DeadLineTodate = DATEADD(DAY,1,@DeadLineTodate)       
    
if @BookingStatus in ('0',NULL)                                                          
set @BookingStatus = ''                         
    
                                                          
                  
if(@MainAgentId='0' or @MainAgentId='')                                                          
Begin                                                          
                                         
  select distinct HB.pkId  ,hb.RiyaAgentID,hb.MainAgentID                                                              ,convert(varchar, HB.inserteddate, 100) as inserteddate,                                
    --,BR.AgencyName as 'AgentName'                        
 case                
 when HB.SubagentId >0                
 THEN                
    BR.AgencyName + '  '  + ' ( ' + isnull(BR1.FirstName,'')  + ' ) '                 
                 
 ELSE                
  BR.AgencyName                
  END as 'AgentName'                
    ,BR.CustomerCOde as 'CustId'                                 
     -- , '' as BookedBy                                                                  
             ,HB.BookingReference                                                                  
    ,HM.Status                                                                  
    ,HB.HotelName                                                                 
             
   ,HB.DisplayDiscountRate  as 'DisplayDiscountRate'             
  ,HB.DisplayDiscountRate +' '+HB.MarkupCurrency as 'Amount'               
  ,HB.cityName as 'cityName'              
 --  ,case                                             
 --   When Hb.BookingCountry ='AE' then ROUND(Cast((cast(RoEB.Rate as float) * cast(isnull(HB.DisplayDiscountRate,1) as float)) as float),2)                                            
 --else HB.DisplayDiscountRate                                             
 --   end as 'Amount'                                             
   --,ROUND(Cast((cast(RoEB.Rate as float) * cast(isnull(HB.DisplayDiscountRate,1) as float)) as float),0) as 'Amount'                                          
    ,convert(varchar, HB.CheckInDate, 106) as CheckInDate                                                                  
    ,convert(varchar, HB.CheckOutDate, 106) as CheckOutDate                                                                  
  --  ,convert(varchar, HB.ExpirationDate, 106) as ExpirationDate                                     
 ,convert(varchar, isnull(HB.CancellationDeadLine,HB.canceldate), 106) as ExpirationDate                                     
    ,HB.PassengerEmail as 'Email'                                                                  
    ,HB.PassengerPhone as 'Mobile'                                                                 
 ,HB.LeaderTitle+' '+ HB.LeaderFirstName +' '+HB.LeaderLastName as 'TravellerName'                                                                
    ,case                                              
        when HB.B2BPaymentMode =1 then 'Hold'                                                                  
        when HB.B2BPaymentMode =2 then 'Credit Limit'                                                                  
        when HB.B2BPaymentMode =3 then 'Make Payment'                                                                  
        when HB.B2BPaymentMode =4 then 'Self Balance'                                                                  
        end as Payment                                                              
       ,HB.riyaPNR                                                                          
  from Hotel_BookMaster HB                                                                  
  join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId                                              
  join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                  
  join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                 
  left join AgentLogin BR1 on HB.SubAgentId = BR1.UserId                
  left join muser HU on HU.ID=HB.MainAgentID                                                
  left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId --added by akash to show booking amount in AEd for Dubai Agent Booking 12/01/2022                                               
                                              
                                            
                                                                
     where HB.RiyaAgentID=@AgentId         
     and HB.RiyaAgentID is not null                                                          
  -- and (HB.MainAgentID=0 or HB.MainAgentID is null)          
 --    and HB.BookingReference is not null                                                                   
     and HH.IsActive=1            
                                                                   
     and ((Convert(date,HB.inserteddate) >= Convert(date,@BookingFromDate) and Convert(date,HB.inserteddate) < @BookingTodate) or @BookingFromDate='')                                                          
  and ((Convert(date,HB.CheckInDate) >= Convert(date,@CheckInFromDate) and Convert(date,HB.CheckInDate) < @CheckInTodate ) or @CheckInFromDate='')                                                          
     and ((Convert(date,HB.ExpirationDate) >= Convert(date,@DeadLineFromDate) and Convert(date,HB.ExpirationDate) < @DeadLineTodate ) or @DeadLineFromDate='')                                                          
  and (HH.FkStatusId in(select cAst(Item as int) FROM dbo.SplitString(@BookingStatus,',') )   or @BookingStatus = '' )                                                             
   and (HB.BookingReference=@BookingNo or @BookingNo = '')                
  and (HB.PassengerPhone=@PassengerPhone  or @PassengerPhone  = '')                 
  and (HB.PassengerEmail=@PassengerEmail  or @PassengerEmail  = '')                  
                                                               
 and (HB.LeaderFirstName=@PassengerName  or @PassengerName  = '')                                                          
                                                               
  and  HB.BookingPortal='Qtech'                                 
     order by pkId desc                                                             
End                                                          
                                                          
if(@MainAgentId != '0')                                
                                
Begin                                                          
--set @RiyaAgentId= (SELECT Riyaagentid from Hotel_BookMaster where Bookingreference = @BookingNo)                                
set @StateId=(SELECT distinct StateID from B2BRegistration where FKUserID=@AgentId)                                              
                                              
select distinct HB.pkId ,hb.RiyaAgentID ,HB.MainAgentID                                                                
    ,convert(varchar, HB.inserteddate, 100) as inserteddate                                                                  
    --,BR.AgencyName as 'AgentName'                             
 ,CASE WHEN  HU1.FullName IS NOT NULL THEN                            
    BR.AgencyName + ' '  + ' - ' + isnull(HU.FullName,'') + ' '  + ' ( ' + isnull(HU1.FullName,'')  + ' ) '                              
   ELSE   BR.AgencyName + ' '  + ' - ' + isnull(HU.FullName,'') END  as 'AgentName'                             
    ,BR.CustomerCOde as 'CustId'                                                                  
     -- , '' as BookedBy                                                                  
             ,HB.BookingReference                                                                  
    ,HM.Status                                                                  
    ,HB.HotelName                                                           
                
   ,HB.DisplayDiscountRate as 'DisplayDiscountRate'              
  ,HB.DisplayDiscountRate +' '+HB.MarkupCurrency as 'Amount'               
  ,HB.cityName as 'cityName'              
   ,HB.SuBMainAgentID                             
                                              
 --  ,case                                             
 --   When Hb.BookingCountry ='AE' then ROUND(Cast((cast(RoEB.Rate as float) * cast(isnull(HB.DisplayDiscountRate,1) as float)) as float),2)                                            
 --else HB.DisplayDiscountRate                                        
 --   end as 'Amount'                                             
   -- ,ROUND(Cast((cast(RoEB.Rate as float) * cast(isnull(HB.DisplayDiscountRate,1) as float)) as float),0)  as 'Amount'                                            
    ,convert(varchar, HB.CheckInDate, 106) as CheckInDate                                                                  
    ,convert(varchar, HB.CheckOutDate, 106) as CheckOutDate                                                         
  --  ,convert(varchar, HB.ExpirationDate, 100) as ExpirationDate                                      
    ,convert(varchar, isnull(HB.CancellationDeadLine,HB.canceldate), 106) as ExpirationDate                                                                  
                                      
    ,HB.PassengerEmail as 'Email'                                            
    ,HB.PassengerPhone as 'Mobile'                                                                 
    ,HB.LeaderTitle+' '+ HB.LeaderFirstName +' '+HB.LeaderLastName as 'TravellerName'                                                                
    ,case                                                                   
        when HB.B2BPaymentMode =1 then 'Hold'                                                                  
        when HB.B2BPaymentMode =2 then 'Credit Limit'                                                                  
        when HB.B2BPaymentMode =3 then 'Make Payment'                                                                  
        when HB.B2BPaymentMode =4 then 'Self Balance'                                 
        end as Payment                                                                        
    ,HB.riyaPNR                                                                          
  from Hotel_BookMaster HB                                                                  
  join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId                                                               
  join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                  
  join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                          
  left join muser HU on HU.ID=HB.MainAgentID                             
  left join muser HU1 on HU1.ID=HB.SuBMainAgentID                                                      
                              
  left join Hotel_ROE_Booking_History RoEB on RoEB.FkBookId=HB.pkId                       
                      
     where (HB.MainAgentID in(select cAst(Item as int) FROM dbo.SplitString(@MainAgentId,',')  ) )                         
                                                
  and  HB.MainAgentID is not null   
  -- and (HB.AgentID in(select cAst(Item as int) FROM dbo.SplitString(@AgentID,',')  ) )                         
                                                
  --and  HB.AgentID is not null    
                                                                 
      and HH.IsActive=1                           
                         
  and ((HB.MainAgentID in(select cAst(Item as int) FROM dbo.SplitString(@MainAgentId,',')  )  or HB.SuBMainAgentID in(select cAst(Item as int) FROM dbo.SplitString(@MainAgentId,',')  ) ))                          
                                                                     
     and ((Convert(date,HB.inserteddate) >= Convert(date,@BookingFromDate) and Convert(date,HB.inserteddate) < @BookingTodate) or @BookingFromDate='')                      
                      
  and ((Convert(date,HB.CheckInDate) >= Convert(date,@CheckInFromDate) and Convert(date,HB.CheckInDate) < @CheckInTodate ) or @CheckInFromDate='')                      
                      
     and ((Convert(date,HB.ExpirationDate) >= Convert(date,@DeadLineFromDate) and Convert(date,HB.ExpirationDate) < @DeadLineTodate ) or @DeadLineFromDate='')                    
                      
                    
  and  (HH.FkStatusId in(select cAst(Item as int) FROM dbo.SplitString(@BookingStatus,',') )   or @BookingStatus = '' )                     
                      
          and (HB.BookingReference=@BookingNo or @BookingNo = '')                
  and (HB.PassengerPhone=@PassengerPhone  or @PassengerPhone  = '')                 
  and (HB.PassengerEmail=@PassengerEmail  or @PassengerEmail  = '')                  
                                                               
 and (HB.LeaderFirstName=@PassengerName  or @PassengerName  = '')      
 
 and HB.BookingPortal='Qtech'
                                                                     
     order by pkId desc                                        
                                  
                                
                                  
End                                             
                                                                          
                    
                    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBBManageBookingDetails] TO [rt_read]
    AS [dbo];

