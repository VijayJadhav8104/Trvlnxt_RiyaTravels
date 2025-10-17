CREATE Proc InsertROEDataASPerGDS            
@fromcountry VARCHAR(10),            
@ToCountry VARCHAR(10),            
@ROEId INT,            
@OLDROE DECIMAL(18,10),            
@NEWROE DECIMAL(18,10),            
@Request VARCHAR(50),            
@Response VARCHAR(MAX) ,          
@MarkupType VARCHAR(20),        
@IsAddSubtract INT,        
@MarkupData DECIMAL(18,10)        
,@IsROEMarkup int        
AS             
BEGIN            
DECLARE @FinalROE DECIMAL(18,10),@Markupvalue DECIMAL(18,10)          
--Getdata          
--select top 1 @MarkupType=MarkupType,@MarkupData=MarkupData,@IsAddSubtract=IsAddSubtract           
--from ROEWithMarkupAndFlat where FromCurrency =@fromcountry          
--and ToCurrency=@ToCountry and UserTypeId=@userTypeId           
--and Products like '%Air%' and IsActive=1 order by id desc          
--GetData       
    
          
if exists(select ru.ID from mROEUpdation ru     
inner join mROEAgencyMapping rm on rm.ROEId=ru.ID and IsAllAgency=0    
inner join B2BRegistration b on b.PKID=rm.AgencyId    
inner join agentLogin a on a.UserID=b.FKUserID    
where ru.UserTypeId=5 and ProductId=224     
and (a.GroupId=4 or a.GroupId=5 or a.GroupId=18 or a.GroupId=16) and ru.ID=@ROEId)    
begin    
set @NEWROE= CONVERT(decimal(18,4),@NEWROE)     
end    
    
    
          
--Set VendorROE          
IF UPPER(@MarkupType)='PERCENTAGE'          
BEGIN          
SET @Markupvalue=(@NEWROE*@MarkupData)/100          
END         
ELSE IF UPPER(@MarkupType)='FLAT'          
BEGIN           
SET @Markupvalue=@MarkupData          
END         
        
IF @IsAddSubtract=1          
BEGIN           
SET @FinalROE=@NEWROE+@Markupvalue          
END          
ELSE          
BEGIN           
SET @FinalROE=@NEWROE - @Markupvalue          
END          
--SetVendorROE          
          
          
 INSERT INTO mROEHistoryAir(fromCountry,ToCountry,ROEId,OldROE,NewROE,Request,Response)            
 VALUES (@fromcountry,@ToCountry,@ROEId,@OLDROE,@NEWROE,@Request,@Response)           
 IF @IsROEMarkup=1        
 BEGIN        
  UPDATE mROEUpdation         
  SET ROE=@FinalROE,        
  VendorROE=@NEWROE,        
  MarkupAmount=@Markupvalue         
  WHERE ID=@ROEId        
  END        
  ELSE        
  BEGIN         
 UPDATE mROEUpdation         
 SET ROE=@NEWROE,        
 VendorROE=@NEWROE         
 WHERE ID=@ROEId        
 END        
END 