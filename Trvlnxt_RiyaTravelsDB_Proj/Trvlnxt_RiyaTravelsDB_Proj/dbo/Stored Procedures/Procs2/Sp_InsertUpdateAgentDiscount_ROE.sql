-- =============================================    
-- Author:  Bhavika kawa    
-- Description: Add/Update Agent ROE    
-- =============================================    
CREATE PROCEDURE [dbo].[Sp_InsertUpdateAgentDiscount_ROE]    
 @Type varchar(20),    
 @ID int=null,    
 @UserID int,    
 @AgencyID varchar(MAX)=null,    
 @AgencyNames varchar(MAX)=null,    
 @UserType varchar(50)=null,    
 @Country varchar(10)=null,    
 @Currency varchar(50)=null,    
 @ROE decimal(18,16)=null,    
 @IsActive bit=null,    
 @ERROR VARCHAR(50) OUT    
AS    
BEGIN    
set @ERROR=''    
    
if(@Type='Add')    
begin    
     
 insert into mAgentROE(UserType,Country,AgencyID,AgencyNames,Currency,ROE,CreatedBy)     
 values(@UserType,@Country,@AgencyID,@AgencyNames,@Currency,@ROE,@UserID)    
 set @ERROR=  cast(@@identity as varchar(50))    
     
end    
else if(@Type='Update')    
begin    
insert into mAgentROE_ConsoleHistory([Action],UserType,  
 Country,AgencyID ,AgencyNames,Currency,ROE,    
 CreatedBy, CreatedOn,IsActive,IsDeleted) select @Type,UserType,  
 Country,AgencyID ,AgencyNames,Currency,ROE,    
 @UserID, Getdate(),IsActive,IsDeleted from mAgentROE  
 where ID=@ID  
  
  
 update mAgentROE set    
 UserType=@UserType,    
 Country=@Country,    
 AgencyID=@AgencyID,    
 AgencyNames=@AgencyNames,    
 Currency=@Currency,    
 ROE=@ROE,    
 ModifiedBy=@UserID,    
 ModifiedOn=GETDATE()    
 where ID=@ID     
     
end    
else if(@Type='Active') OR (@Type = 'DeActive')  
begin    
if (@ID >0)    
 begin    
 insert into mAgentROE_ConsoleHistory([Action],UserType,  
 Country,AgencyID ,AgencyNames,Currency,ROE,    
 CreatedBy, CreatedOn,IsActive,IsDeleted) select @Type,UserType,  
 Country,AgencyID ,AgencyNames,Currency,ROE,    
 @UserID, Getdate(),IsActive,IsDeleted from mAgentROE  
 where ID=@ID  
  
  update mAgentROE set IsActive=@IsActive, ModifiedBy=@UserID, ModifiedOn=GETDATE() where ID=@ID    
 end    
 else    
 begin   
  update mAgentROE    
  set IsActive=@IsActive, ModifiedBy=@UserID, ModifiedOn=GETDATE()    
  where Country in (select C.CountryCode  from mUserCountryMapping UM    
    INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@UserID  AND IsActive=1)    
 end    
     
end    
else if(@Type='Delete')    
begin    
 if (@ID >0)    
 begin   
  insert into mAgentROE_ConsoleHistory([Action],UserType,  
 Country,AgencyID ,AgencyNames,Currency,ROE,    
 CreatedBy, CreatedOn,IsActive,IsDeleted) select @Type,UserType,  
 Country,AgencyID ,AgencyNames,Currency,ROE,    
 @UserID, Getdate(),IsActive,IsDeleted from mAgentROE  
 where ID=@ID  
  
  update mAgentROE set IsDeleted=1, ModifiedBy=@UserID, ModifiedOn=GETDATE() where ID=@ID    
 end    
 else    
 begin    
  update mAgentROE    
  set IsDeleted=1, ModifiedBy=@UserID, ModifiedOn=GETDATE()    
  where Country in (select C.CountryCode  from mUserCountryMapping UM    
    INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@UserID  AND IsActive=1)    
 end    
end    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_InsertUpdateAgentDiscount_ROE] TO [rt_read]
    AS [dbo];

