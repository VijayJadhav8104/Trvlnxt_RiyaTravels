      
CREATE proc Hotel.SupplierErrorMapping_Console      
      
@Action varchar(200)='',    
@Suppliername varchar(200)=''    
as      
      
begin      
      
    
if(@Action='GetData')    
Begin    
select       
id as Pkid,      
iSNULL(Provider,'NA')        as 'Provider',      
iSNULL(ProviderMessage,'')   as 'ProviderError',  
Isnull(MethodName,'NA')      as MethodName ,  
ISNULL(ErrorMessage,'')      as 'CurrentDisplayError',      
ISNULL(BookingReference,'NA') AS BookingReference,      
ISNULL(ActualErrorMessage,'NA') as 'ActualErrortoShow',      
ISNULL(CorrelationId,'NA')      AS CorrelationId,      
UpdatedDate,      
UpdatedBy,      
InsertedDate      
 from  Hotel.SupplierErrorMapping      
 order by InsertedDate desc    
end    
else if(@Action='FilterData')    
Begin    
    
       
select    
id as Pkid,      
iSNULL(Provider,'NA')        as 'Provider',   
Isnull(MethodName,'NA')      as MethodName ,  
iSNULL(ProviderMessage,'')   as 'ProviderError',      
ISNULL(ErrorMessage,'')      as 'CurrentDisplayError',      
ISNULL(SE.BookingReference,'NA') AS BookingReference,      
ISNULL(ActualErrorMessage,'NA') as 'ActualErrortoShow',      
ISNULL(CorrelationId,'NA')      AS CorrelationId,      
UpdatedDate,      
UpdatedBy,      
SE.InsertedDate      
 from  Hotel.SupplierErrorMapping SE  With(nolock)    
 where   
 --SE.[Provider]=@Suppliername  
 ( ( @Suppliername ='') or (SE.[Provider] IN  (select Data from sample_split(@Suppliername,',') )))   
    
end    
    
    
end  
  
  
--select * from Hotel.SupplierErrorMapping 