-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
CREATE PROCEDURE [Hotel].AmadeusPnrPreNightInsert      
 @pnr nvarchar(100)=null,        
 @priAmount nvarchar(100)=null,        
 @priDate nvarchar(100)=null,        
 @isActive bit = null,        
 @insertedDate datetime = null        
AS        
BEGIN      
  
declare @RoomNight decimal(10,2)= 0  
declare @perRoomNight decimal(10,2)= 0  
  
select @RoomNight= RoomNight  from RiyaTravels.Hotel.tblAmedeousPnr with (nolock)  
WHERE  
Ltrim(rtrim( PnrNo ))=Ltrim(rtrim(@pnr))  
  
select @perRoomNight= Count (1) from hotel.AmsdeusPnrPerNightRate  
where Ltrim(rtrim(pnr))=Ltrim(rtrim(@pnr))--  
if(@RoomNight>@perRoomNight)  
    Begin  
insert into [hotel].AmsdeusPnrPerNightRate       
(PNR,priAmount,priDate,isActive,InsertedDate)       
values(Ltrim(rtrim(@pnr)),@priAmount,@priDate,@isActive,@insertedDate)          
END   
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[Hotel].[AmadeusPnrPreNightInsert] TO [rt_read]
    AS [DB_TEST];

