  
CREATE procedure Proc_InserBookingAdditionalCharges      
@BookingId int=0,      
@Type varchar(100)=null,      
@Amount float,      
@Frequency varchar(100)=null,      
@Currency varchar(100)=null,      
@Unit varchar(100)=null,      
@Text varchar(400)=null,    
@Discription varchar(400)=null,
@RoomNo int=0
As      
Begin      
 insert into hotel.AdditionalCharges(FkBookId,Text,Type,Description,Frequency,Unit,Amount,Currency,RoomNo)      
 values(@BookingId,@Text,@Type,@Discription,@Frequency,@Unit,@Amount,@Currency,@RoomNo)      
End