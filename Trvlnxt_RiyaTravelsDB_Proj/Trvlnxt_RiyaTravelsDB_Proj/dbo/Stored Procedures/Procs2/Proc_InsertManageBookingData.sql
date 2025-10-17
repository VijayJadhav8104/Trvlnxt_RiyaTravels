CREATE Procedure Proc_InsertManageBookingData  
@BookingPkId int=0,  
@AgentId int=0,  
@RiyaUserId int=0,  
@BookingId varchar(150)='',  
@BookingStatus varchar(100)='',  
@BookingInsertedDate datetime='',  
@LeadPaxName varchar(500)='',  
@AgencyName varchar(200)='',  
@StartDate datetime='',  
@EndDate datetime='',  
@TotalBookingAmount float=0,  
@BookdBy varchar(200)='',  
@ProductName varchar(100)=''  
AS  
Begin  
 Insert Into TrvlNxt_ManageBookingMaster(  
 BookingPkId,  
 AgentId,  
 RiyaUserId,  
 BookingId,  
 BookingStatus,  
 BookingInsertedDate,  
 LeadPaxName,  
 AgencyName,  
 StartDate,  
 EndDate,  
 TotalBookingAmount,  
 BookdBy,  
 ProductName)  
 Values(  
 @BookingPkId,  
 @AgentId,  
 @RiyaUserId,  
 @BookingId,  
 @BookingStatus,  
 @BookingInsertedDate,  
 @LeadPaxName,  
 @AgencyName,  
 @StartDate,  
 @EndDate,  
 @TotalBookingAmount,  
 @BookdBy,  
 @ProductName)  
END