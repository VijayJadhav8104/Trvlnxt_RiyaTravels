CREATE Procedure Proc_InserBookingCancelPolicies
--'62147','Check-in between 12:00 PM - anytime','Check-in','0',null,'0','{01-01-0001 00:00:00','01-01-0001 00:00:00','Booking Policies'          
@FKBookingId int,          
@PolicyText varchar(max)=null,          
@PolicyType varchar(200)=null,          
@CPvalue Float(30)=0,          
@CPValueType varchar(200)=null,          
@CPEstimatedValue  Float(30)=0,          
@CPStardDate datetime=null,          
@CPEndDate  datetime=null,          
@GroupName varchar(200)=null,         
@FkRoomId int,      
@RoomType varchar(400)=null,      
@Roomid int=0,    
@Text varchar(max)=null,    
@RefundText varchar(100)=null    
As          
Begin          
 Insert into[Hotel].HotelCancelBookPolicies          
 (FKBookingId,          
 PolicyText,          
 PolicyType,          
 CPvalue,          
 CPValueType,          
 CPEstimatedValue,          
 CPStardDate,          
 CPEndDate,          
 GroupName,        
 FKRoomId,      
 RoomType,      
 Roomid,    
 Text,    
 RefundText)          
 Values(@FKBookingId,          
 @PolicyText,          
 @PolicyType,          
 @CPvalue,          
 @CPValueType,          
 @CPEstimatedValue,          
 @CPStardDate,          
 @CPEndDate,          
 @GroupName,        
 @FkRoomId,      
 @RoomType,      
 @Roomid,    
 @Text,    
 @RefundText)          
End