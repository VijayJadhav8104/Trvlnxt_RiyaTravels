CREATE Procedure Proc_UpdateManageBookingData  
@BookingPkId int=0,  
@AgentId int=0,  
@RiyaUserId int=0,  
@BookingId varchar(150)='',  
@BookingStatus varchar(100)='',  
@TotalBookingAmount float=0,  
@BookBy varchar(200)='',  
@ProductName varchar(100)=''  
AS  
Begin  
 update TrvlNxt_ManageBookingMaster Set BookingStatus=@BookingStatus,TotalBookingAmount=@TotalBookingAmount Where   
 BookingPkId=@BookingPkId and BookingId=@BookingId and ProductName=@ProductName  
END