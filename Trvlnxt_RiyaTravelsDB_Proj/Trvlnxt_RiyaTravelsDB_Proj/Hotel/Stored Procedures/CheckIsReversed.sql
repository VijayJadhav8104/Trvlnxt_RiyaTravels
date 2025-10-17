CREATE Proc [hotel].CheckIsReversed  
@OrderID varchar(100)='',  
@PaymentMode varchar(100)='',  
@TransectionType varchar(50)=''  
AS  
BEGIN  
  
Declare @IsExist int=0  
 --For Agent Balance Check  
 if(@PaymentMode='2')  
 Begin  
    select @IsExist=Count(*) from tblAgentBalance where BookingRef=@OrderID and TransactionType=@TransectionType  
 if(@IsExist != 0)  
 begin  
    select 'No' as status  
    --means already has a credit entry not need to do again.  
 end  
 else  
 begin  
    select 'Yes'as status  
    --no logs for credit has been found proceed to  insert new logs   
 end  
 End  
  
  
  --For Agent Balance Check  
 else if(@PaymentMode='4')  
 Begin  
      select @IsExist=Count(*) from tblSelfBalance where BookingRef=@OrderID and TransactionType=@TransectionType  
 if(@IsExist != 0)  
 begin  
    select 'No' as status  
 end  
 else  
 begin  
    select 'Yes' as status  
 end  
 End  
  
END  
  
  
  




