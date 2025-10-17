CREATE PROCEDURE ss.ssProc_Hotel_Update_InquiryNo_BookMaster      
@pkId bigint,      
@FileNo VARCHAR(50)=NULL,      
@OBTNo VARCHAR(50)=NULL,      
@InquiryNo VARCHAR(50)=NULL,      
@OpsRemark VARCHAR(50)=NULL,      
@AcctsRemark VARCHAR(50)=NULL      
AS      
BEGIN      
 UPDATE ss.SS_BookingMaster SET FileNo=@FileNo,OBTCNumber=@OBTNo,InquiryNo=@InquiryNo,OpsRemark=@OpsRemark,AccRemark=@AcctsRemark WHERE BookingId=@pkId      
      
 SELECT 1      
END 