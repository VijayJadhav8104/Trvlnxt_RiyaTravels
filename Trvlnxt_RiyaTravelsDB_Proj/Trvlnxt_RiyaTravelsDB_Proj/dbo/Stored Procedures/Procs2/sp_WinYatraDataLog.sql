-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
CREATE PROCEDURE [dbo].[sp_WinYatraDataLog]      
 @Action varchar(50),      
 @FK_tblPassengerBDId bigint =null,      
 @Type varchar(100) =null,       
 @InvoiceNo varchar(Max)=null,      
 @Error varchar(Max)=null,      
 @WYRequest varchar(Max)=null,      
 @WYResponse varchar(Max) =null,      
 @ObtcWYRequest varchar(Max)=null,      
 @ObtcWYResponse varchar(Max) =null,      
 @PasswinYatraInvoiceNo varchar(Max) =null ,
 @obtcno varchar(20)= null
AS      
BEGIN      
IF(@Action = 'Hotel')      
 BEGIN      
 If EXISTS(Select top 1 * from WinYatraDataLog Where fk_bookmasterId=@FK_tblPassengerBDId)      
  Begin      
   if(@Error is not null or @Error != null and @InvoiceNo = null or @InvoiceNo = '')      
    BEGIN      
     Update WinYatraDataLog set [type]=@Type,   
  Response=@WYResponse,  
  Request=@WYRequest ,  
  Error = @Error,CreatedOn=GETDATE()   
  ,InvoiceNo = @InvoiceNo  
     where fk_bookmasterId=@FK_tblPassengerBDId;      
     --Select @FK_tblPassengerBDId;      
  update Hotel_BookMaster set    
  winyatraError=@Error,    
winyatraInvoice=@InvoiceNo    
  where pkId=@FK_tblPassengerBDId    
    END      
     ELSE      
    BEGIN      
     Update WinYatraDataLog set [type]=@Type,   
  Response=@WYResponse,Request=@WYRequest,InvoiceNo = @InvoiceNo ,Error = @Error,CreatedOn=GETDATE()       
     where fk_bookmasterId=@FK_tblPassengerBDId;      
     --Select @FK_tblPassengerBDId;    
   update Hotel_BookMaster set    
  winyatraError=@Error,    
winyatraInvoice=@InvoiceNo    
  where pkId=@FK_tblPassengerBDId    
    END      
  End      
 ELSE      
  Begin      
   insert into WinYatraDataLog(fk_bookmasterId,[type],Request,Response,InvoiceNo,Error,CreatedOn) values(@FK_tblPassengerBDId,@Type,      
   @WYRequest,@WYResponse,@InvoiceNo,@Error,GETDATE());      
   --Select @FK_tblPassengerBDId;      
  End      
  --if (@PasswinYatraInvoiceNo is null)       
  --Begin      
  -- update tblPassengerBookDetails set WinYatraInvoice = @InvoiceNo where pid = @FK_tblPassengerBDId      
  --end      
 END      
IF(@Action = 'Air')      
 BEGIN      
 If EXISTS(Select top 1 * from WinYatraDataLog Where fk_bookmasterId=@FK_tblPassengerBDId)      
  Begin      
   Update WinYatraDataLog set [type]=@Type, Response=@WYResponse,Request=@WYRequest,InvoiceNo = @InvoiceNo ,Error = @Error,CreatedOn=GETDATE()       
   where fk_bookmasterId=@FK_tblPassengerBDId;      
   --Select @FK_tblPassengerBDId;      
  End      
 ELSE      
  Begin      
   insert into WinYatraDataLog(fk_bookmasterId,[type],Request,Response,InvoiceNo,Error,CreatedOn) values(@FK_tblPassengerBDId,@Type,      
   @WYRequest,@WYResponse,@InvoiceNo,@Error,GETDATE());      
   --Select @FK_tblPassengerBDId;      
  End      
  if (@PasswinYatraInvoiceNo is null)       
  Begin      
   update tblPassengerBookDetails set WinYatraInvoice = @InvoiceNo where pid = @FK_tblPassengerBDId      
  end      
 END      
IF(@Action = 'OBTC')      
 BEGIN      
  If EXISTS(Select top 1 * from WinYatraDataLog Where fk_bookmasterId=@FK_tblPassengerBDId)      
   Begin      
     BEGIN      
      Update WinYatraDataLog set ObtcResponse=@ObtcWYResponse,ObtcRequest=@ObtcWYRequest ,ObtcCreatedOn=GETDATE() 
	  
      where fk_bookmasterId=@FK_tblPassengerBDId; 
	  
update Hotel_BookMaster set    
  OBTCNo=@obtcno  
  where pkId=@FK_tblPassengerBDId

      --Select @FK_tblPassengerBDId;          

     END      
   END      
  ELSE      
   BEGIN      
     insert into WinYatraDataLog(fk_bookmasterId,ObtcRequest,ObtcResponse,ObtcCreatedOn) values(@FK_tblPassengerBDId,      
     @ObtcWYRequest,@ObtcWYResponse,GETDATE()); 
	 
	  update Hotel_BookMaster set    
  OBTCNo=@obtcno  
  where pkId=@FK_tblPassengerBDId   
   END      
END      
END 