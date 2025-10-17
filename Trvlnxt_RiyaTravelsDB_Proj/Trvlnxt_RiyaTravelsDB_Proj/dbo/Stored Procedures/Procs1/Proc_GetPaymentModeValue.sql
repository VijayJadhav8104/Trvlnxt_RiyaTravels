--  Proc_GetPaymentModeValue '173,189,196,211,220'  
CREATE Procedure Proc_GetPaymentModeValue  
@PaymentModeId Varchar(100)=''  
As  
Begin  
 Select case   
   when value='Make Payment'  then 3  
   when value='Hold'  then 1  
   when value='Self Balance'  then 4  
   when value='Check'  then 2  
  end as Id  
  ,  
  case   
  when value='Check' THEN 'Credit Limit'   
  else Value  
  end as 'Mode'  
  
  from mCommon   
 where ID in   
   (  select cast(Data as int) from sample_split(@PaymentModeId,','))  
   and Category='PaymentMode'  and Value !='Payment Gateway' and Value !='Credit Card' 
End
 