                
--Created On : 26/02/2025 --> get Email to send user for which through api hcn is get updated --                
        --  exec  [Hotel].[GetAUTOHCN_Email]   'TNH00279333'      
CREATE Procedure [Hotel].[GetAUTOHCN_Email]                
                
@BookingReference varchar(300)=''                
                
as                 
begin                
              
        
select  case when Hb.SupplierPkId IN(1,15,3,30,35,49) then  'gary.fernandes@riya.travel,aman.developers@riya.travel'      
else '' end as  AgencyEmail,        
 Isnull(HCN.HotelConfirmationNumber,'') as HotelConfNumber,        
case when Hb.SupplierPkId IN(1,15,3,30,35,49) then 'yes'               
else 'no' end as SupplierName,      
CASE WHEN AUTOHCNEMAILSENT=1 and HotelConfNumber='' OR  HotelConfNumber is null THEN  'no' ELSE 'yes' end as 'Emailsent'    
--CASE WHEN AUTOHCNEMAILSENT=1 and HotelConfNumber='' OR  HotelConfNumber is null THEN  'yes' ELSE 'no' end as 'Emailsent'  -- this done still next deployment of ui    
  from Hotel_BookMaster HB  WITH (NOLOCK)                
 LEFT JOIN [Hotel].[HotelAutoHCN] HCN      
        ON HB.BookingReference = HCN.BookingReference  and HCN.IsActive=1              
 where HB.BookingReference=@BookingReference  and  Hb.SupplierPkId IN(1,15,3,30,35,49)         
 and CAST(HB.inserteddate as Date)=CAST(GETDATE() as date)      
end          
    
--SELECT * FROM HOTEL.HotelAutoHCN WHERE BookingReference='TNH00279333'    
      
 --select * from B2BHotelSupplierMaster where SupplierName like '%agoda%'  
 --id in  (1,15) 