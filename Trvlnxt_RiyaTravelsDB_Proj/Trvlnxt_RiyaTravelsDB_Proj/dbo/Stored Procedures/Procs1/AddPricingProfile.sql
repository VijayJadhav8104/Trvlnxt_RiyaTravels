
CREATE PROCEDURE AddPricingProfile    
     
 @FkId int=0,    
 @ProfileName  nvarchar(500)='',    
 @DefaultProfile bit=0,    
 @Commission nvarchar(500)='',    
 @GST nvarchar(50)='',    
 @TDS nvarchar(50)='',    
 @From nvarchar(50)='',    
 @To nvarchar(500)='',    
 @Amount decimal(18,2)=0.0,    
 @Percent decimal(18,2)=0.0,    
 @Action varchar(200),    
 @ContentId int=0,    
 @RowNo int=0,    
 @DeActiveId int=0,    
 @CreatedBy int=0,    
 @ModifiedBy int=0    
    
AS    
BEGIN    
     
 if(@Action='Profile')    
 begin    
  if not exists(select ProfileName from PricingProfile where ProfileName=@ProfileName and IsActive=1)    
  begin    
      if(@DefaultProfile=1)    
   update PricingProfile set DefaultProfile=0    
    
   insert into PricingProfile(ProfileName,DefaultProfile,Commission,GST,TDS,CreatedBy)     
   values(@ProfileName,@DefaultProfile,@Commission,@GST,@TDS,@CreatedBy)    
   select SCOPE_IDENTITY();    
       
  end    
    
  if exists(select ProfileName from PricingProfile where ProfileName=@ProfileName and IsActive=1)    
  begin    
      select 0;    
  end    
 end    
    
    
 if(@Action='ProfileDetails')    
 begin    
  insert into PricingProfileDetails(FromRange,ToRange,Amount,PricePercent,FKPricingProfile,RowNo)     
  values(@From,@To,@Amount,@Percent,@FkId,@RowNo)    
      
 end    
    
 if(@Action='UpdateProfile')    
 begin    
  if exists(select ProfileName from PricingProfile where ProfileName=@ProfileName)    
  begin    
  if(@DefaultProfile =1)    
   begin    
    update PricingProfile set DefaultProfile=0     
            ,ProfileName=@ProfileName     
            ,Commission=@Commission    
               ,GST=@GST    
                ,TDS=@TDS    
            where Id=@FkId    
   end    
    
   update PricingProfile set ProfileName=@ProfileName    
                            ,DefaultProfile=@DefaultProfile    
          ,Commission=@Commission    
          ,GST=@GST    
          ,TDS=@TDS    
          ,ModifiedBy=@ModifiedBy    
          ,ModifiedOn=GETDATE()    
   where Id=@FkId    
  end    
    
  if not exists(select ProfileName from PricingProfile where ProfileName=@ProfileName)    
  begin    
    update PricingProfile set DefaultProfile=0     
            ,ProfileName=@ProfileName     
            ,Commission=@Commission    
            ,GST=@GST    
               ,TDS=@TDS    
            where Id=@FkId    
  end    
 end    
    
 if(@Action='UpdateProfileDetails')    
 begin    
  if exists(select Id from PricingProfileDetails where Id=@ContentId)    
  begin    
   update PricingProfileDetails set FromRange=@From,ToRange=@To,Amount=@Amount,PricePercent=@Percent    
   where Id=@ContentId    
  end    
  else     
   insert into PricingProfileDetails(FromRange,ToRange,Amount,PricePercent,FKPricingProfile,RowNo)     
   values(@From,@To,@Amount,@Percent,@FkId,@RowNo)    
      
 end    
    
 if(@Action='DeActiveId')    
  BEGIN    
   update PricingProfileDetails set IsActive=0     
   where Id=@DeActiveId    
  END    
    
END 



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddPricingProfile] TO [rt_read]
    AS [dbo];

