      
--==================================================================================================================================      
-- Author: Akash Singh          
-- Create date: 17 Feb 2025          
-- Description: TO Update The LFS Check Record for each booking with certain Details.          
-- EXEC Hotel.[UpdateLFSDetails]     
--     
--==================================================================================================================================      
      
CREATE Proc Hotel.[UpdateLFSDetails]      
      
@BookingId Varchar(250)='',      
@PKID int=0,      
@Remark varchar(max)=null,      
@MethodCheck varchar(100)=null,    
@Rate varchar(100)=null,    
@SupplierName varchar(100)=null,    
@IsCompatible bit=0,
--@PreviousRate varchar(100)=null,    
@Profit decimal(18,2)=0,
@LfSToken varchar(300)=null
  
AS      
      
BEGIN      
    IF Exists(SELECT * from  Hotel.LFSDetails where PKID=@PKID)      
  BEGIN      
    Declare @Count int   
 Declare @PreviousAmt varchar(250)   
   
    Select @Count=TotalCheckCount,@PreviousAmt=PreviousRate  from  Hotel.LFSDetails where PKID=@PKID      
      
 if(@IsCompatible=1)  
 Begin  
      update Hotel.LFSDetails set      
           Remark=@Remark,      
           LastCheckDate=GETDATE(),      
           TotalCheckCount =@Count+1,      
           MethodCheck=@MethodCheck,    
           SupplierName=@SupplierName,    
           PreviousRate=@Rate,--CheapestRate  
        Rate=@Rate,  
           IsRateCompatible=@IsCompatible,    
     Profit= @Profit,
	 @LfSToken=LFSToken
    Where  PKID=@PKID       
      and  BookingId=@BookingId      
 End  
 else   
   Begin  
   update Hotel.LFSDetails set      
           Remark=@Remark,      
           LastCheckDate=GETDATE(),      
           TotalCheckCount =@Count+1,      
           MethodCheck=@MethodCheck,    
           SupplierName=@SupplierName,    
           PreviousRate=@PreviousAmt,--CheapestRate  
        Rate=@Rate,  
           IsRateCompatible=@IsCompatible,    
     Profit= @Profit ,
	 @LfSToken=LFSToken
      Where  PKID=@PKID       
      and  BookingId=@BookingId      
   End  
      
  --update          
  END      
 ELSE      
  BEGIN      
        if(@IsCompatible=1)      
    
  BEGIN  
         INSERT INTO Hotel.LFSDetails(PKID,LastCheckDate,BookingId,Remark,MethodCheck,TotalCheckCount,SupplierName,Rate,IsRateCompatible,Profit,PreviousRate,LFSToken)      
         Values(@PKID,GETDATE(),@BookingId,@Remark,@MethodCheck,1,@SupplierName,@Rate,@IsCompatible,@Profit,@Rate,@LfSToken);      
        End  
  
  ELSE  
  
  BEGIN  
   INSERT INTO Hotel.LFSDetails(PKID,LastCheckDate,BookingId,Remark,MethodCheck,TotalCheckCount,SupplierName,Rate,IsRateCompatible,Profit,PreviousRate,LFSToken)      
         Values(@PKID,GETDATE(),@BookingId,@Remark,@MethodCheck,1,@SupplierName,@Rate,@IsCompatible,@Profit,@Rate,@LfSToken);       
  END  
 END      
END      