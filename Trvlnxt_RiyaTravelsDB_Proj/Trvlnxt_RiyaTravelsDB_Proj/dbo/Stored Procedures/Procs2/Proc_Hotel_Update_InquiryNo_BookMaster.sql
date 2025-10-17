CREATE PROCEDURE Proc_Hotel_Update_InquiryNo_BookMaster        
@pkId bigint,        
@FileNo VARCHAR(50)=NULL,        
@OBTNo VARCHAR(50)=NULL,        
@InquiryNo VARCHAR(50)=NULL,        
@OpsRemark VARCHAR(50)=NULL,        
@AcctsRemark VARCHAR(50)=NULL        
AS        
BEGIN     
Declare @BookingOBTC varchar(50)=''  
Declare @OldOBTCNo varchar(50)=''   
Declare @MBPageOBTCNo varchar(50)=''  
Select @BookingOBTC=OBTCNo from Hotel_BookMaster where pkId=@pkId   
Select @OldOBTCNo=MBPageOBTCNo from Hotel_BookMaster where pkId=@pkId    
 if(@BookingOBTC is NULL)  
Begin  
 UPDATE Hotel_BookMaster SET FileNo=@FileNo,OBTCNo=@OBTNo,MBPageOBTCNo=@OBTNo,InquiryNo=@InquiryNo,OpsRemark=@OpsRemark,AcctsRemark=@AcctsRemark WHERE pkId=@pkId   
End
else if(@BookingOBTC ='')
Begin
	UPDATE Hotel_BookMaster SET FileNo=@FileNo,OBTCNo=@OBTNo,MBPageOBTCNo=@OBTNo,InquiryNo=@InquiryNo,OpsRemark=@OpsRemark,AcctsRemark=@AcctsRemark WHERE pkId=@pkId   
END
  
if(@BookingOBTC !=null or @BookingOBTC!='')  
Begin  
 UPDATE Hotel_BookMaster SET FileNo=@FileNo,MBPageOBTCNo=@OBTNo,OldOBTCNo=@OldOBTCNo,InquiryNo=@InquiryNo,OpsRemark=@OpsRemark,AcctsRemark=@AcctsRemark WHERE pkId=@pkId   
End   
 SELECT 1        
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Proc_Hotel_Update_InquiryNo_BookMaster] TO [rt_read]
    AS [dbo];

