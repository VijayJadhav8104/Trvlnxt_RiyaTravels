-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [Hotel].AmadeusPnrPreNightInsert_130625  
 @pnr nvarchar(100)=null,  
	@priAmount nvarchar(100)=null,  
 @priDate nvarchar(100)=null,  
 @isActive bit = null,  
 @insertedDate datetime = null  
AS  
BEGIN  
if(exists(select 1 from [hotel].AmsdeusPnrPerNightRate where PNR=@pnr and priDate= @priDate and priAmount=@priAmount and isActive =1))
begin
 update [hotel].AmsdeusPnrPerNightRate
 set isActive=0
 where 
 PNR=@pnr and priDate= @priDate and priAmount=@priAmount and isActive =1
END 
insert into [hotel].AmsdeusPnrPerNightRate 
(PNR,priAmount,priDate,isActive,InsertedDate) 
values(@pnr,@priAmount,@priDate,@isActive,@insertedDate)    
END 