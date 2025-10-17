

-- =============================================
-- Author: AKASH SINGH
-- Create date: 27-Jul-2021 
-- SP_AgentSupplierMapping 'B2B', 'IN', ,'' , ,''
-- =============================================
CREATE PROCEDURE [dbo].[SP_AgentSupplierMapping] 
@UserType varchar(50)=null,
@Country varchar(50)=null,
@AgencyId  varchar(max)=null,
@AgencyName varchar(max)=null,
@Vendor varchar(max)=null,
@UserId int=null,
@Flag varchar(50)=null,
@Product varchar(50)=null,
@Id int=null
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
--SET NOCOUNT ON;

 -- Insert statements for procedure here
 if(@Flag='Insert')
 begin
  --if exists (select Id from tbl_AgentSupplierMapping where AgencyId=@AgencyId and UserType=@UserType and Country=@Country)
  -- begin
  --    update tbl_AgentSupplierMapping set
	 --  UserType=@UserType,
	 --  Country=@Country,
	 --  AgencyId=@AgencyId,
	 --  AgencyName=@AgencyName,
	 --  VendorId=@Vendor,
	 --  ModifiedBy=@UserId,
	 --  ModifiedDate=GETDATE(),
	 --  IsActive=1
	 --  where AgencyId=@AgencyId
  -- end
   if not exists(select Id from tbl_AgentSupplierMapping where AgentId=@AgencyId and UserType=@UserType and Country=@Country and IsActive=1 and  Product='Air')
   begin
	insert into tbl_AgentSupplierMapping(UserType,Country,AgentId,AgencyName,VendorId,CreatedBy,CreatedDate,Product,IsActive) 
	values(@UserType,@Country,@AgencyId,@AgencyName,@Vendor,@UserId,GETDATE(),@Product,1)
   end
 end

 if(@Flag='Update')
 begin
 update tbl_AgentSupplierMapping set
	   UserType=@UserType,
	   Country=@Country,
	   AgentId=@AgencyId,
	   AgencyName=@AgencyName,
	   VendorId=@Vendor,
	   ModifiedBy=@UserId,
	   ModifiedDate=GETDATE(),
	   IsActive=1
	   where Id=@Id
 end

 if(@Flag='Get')
 begin

 --Select  ASM.Id,UserType ,mc.ID as 'UserTypeId' ,ASM.Country, c.ID as 'CountryId',asm.AgentId,asm.AgencyName,  ASM.VendorId  ,U.username 'Created By'  ,CreatedDate 'Date/Time',
 --  u1.UserName as 'Modified By',ASM.ModifiedDate as 'Modified On'
 --  from tbl_AgentSupplierMapping ASM
 --  left join mUser U on ASM.CreatedBy=U.id
 --  join mCommon mc on mc.Value=ASM.UserType
 --  join mCountry c on c.CountryCode=ASM.Country
 --  left join mUser U1 on ASM.ModifiedBy=U1.id

 --  where ASM.isActive=1
 --  AND ((@Country = '') or (ASM.Country in (SELECT Data FROM sample_split(@Country, ','))))
 --  AND ((@UserType = '') or (ASM.UserType in (SELECT Data FROM sample_split(@UserType, ','))))

	  Select   asm.AgentId,ASM.Id,UserType ,mc.ID as 'UserTypeId' ,ASM.Country, c.ID as 'CountryId',asm.AgencyName,  ASM.VendorId  ,U.username 'Created By'  , convert (varchar ,ASM.CreatedDate, 106) 'Date/Time',
	   u1.UserName as 'Modified By',convert (varchar,ASM.ModifiedDate,106) as 'Modified On',Product,AgencyName
	   from tbl_AgentSupplierMapping ASM
	   cross apply sample_Split(asm.VendorId,',') as [Split Vendor]
	   left join mUser U on ASM.CreatedBy=U.id
	   join mCommon mc on mc.Value=ASM.UserType
	   join mCountry c on c.CountryCode=ASM.Country
	   left join mUser U1 on ASM.ModifiedBy=U1.id
	   where ASM.isActive=1 and   product='Air'
	   AND ((@Country = '') or (ASM.Country in (SELECT Data FROM sample_split(@Country, ','))))
	   AND ((@UserType = '- Select -') or (ASM.UserType in (SELECT Data FROM sample_split(@UserType, ','))))  
		AND ((@Vendor ='') or ([Split Vendor].Data IN (select Data from sample_split(@Vendor,','))))
		AND ((@Product ='') or (ASM.Product=@Product))


   union 
		 Select  distinct asm.AgentId,'' Id,UserType ,mc.ID as 'UserTypeId' ,ASM.Country, c.ID as 'CountryId',asm.AgencyName, '' AS 'VendorId'  ,U.username 'Created By'  ,convert (varchar ,ASM.CreatedDate, 106) 'Date/Time',
		   u1.UserName as 'Modified By',convert (varchar,ASM.ModifiedDate,106) as 'Modified On',Product,AgencyName
		   from tbl_AgentSupplierMapping ASM
		   cross apply sample_Split(asm.VendorId,',') as [Split Vendor]
		   left join mUser U on ASM.CreatedBy=U.id
		   join mCommon mc on mc.Value=ASM.UserType
		   join mCountry c on c.CountryCode=ASM.Country
		   left join mUser U1 on ASM.ModifiedBy=U1.id
		   where ASM.isActive=1 and   product='Hotel' and  AgentId !=0
		    AND ((@Country = '') or (ASM.Country in (SELECT Data FROM sample_split(@Country, ','))))
			AND ((@UserType = '- Select -') or (ASM.UserType in (SELECT Data FROM sample_split(@UserType, ','))))  
			--AND ((@Vendor ='') or (ASM.VendorId IN (select Data from sample_split(@Vendor,','))))
			AND ((@Vendor ='') or ([Split Vendor].Data IN (select Data from sample_split(@Vendor,','))))
			AND ((@Product ='') or (ASM.Product=@Product))


   union 

		   Select  distinct asm.AgentId,'' Id,UserType ,mc.ID as 'UserTypeId' ,ASM.Country, c.ID as 'CountryId',asm.AgencyName, '' AS 'VendorId'  ,U.username 'Created By'  ,convert (varchar ,ASM.CreatedDate, 106) 'Date/Time',
		   u1.UserName as 'Modified By',convert (varchar,ASM.ModifiedDate,106) as 'Modified On',Product,AgencyName
		   from tbl_AgentSupplierMapping ASM
		   cross apply sample_Split(asm.VendorId,',') as [Split Vendor]
		   left join mUser U on ASM.CreatedBy=U.id
		   join mCommon mc on mc.Value=ASM.UserType
		   join mCountry c on c.CountryCode=ASM.Country
		   left join mUser U1 on ASM.ModifiedBy=U1.id
  
		   where ASM.isActive=1 and   product='Hotel' and  AgentId =0

		    AND ((@Country = '') or (ASM.Country in (SELECT Data FROM sample_split(@Country, ','))))
			AND ((@UserType = '- Select -') or (ASM.UserType in (SELECT Data FROM sample_split(@UserType, ','))))  
			--AND ((@Vendor ='') or (ASM.VendorId IN (select Data from sample_split(@Vendor,','))))
			AND ((@Vendor ='') or ([Split Vendor].Data IN (select Data from sample_split(@Vendor,','))))
			AND ((@Product ='') or (ASM.Product=@Product))
 

 end

 if(@Flag='Edit')
 begin
 --   select UserType, ASM.Country, AgencyId,BR.AgencyName+'-'+br.Icast 'AgentName' ,VendorId from tbl_AgentSupplierMapping ASM join B2BRegistration br on ASM.AgencyId=Br.FKUserID
	--where ASM.Id=@Id;
	select *
	from tbl_AgentSupplierMapping 
	where Id=@Id and Product=@Product;
 end

 if(@Flag='Delete')
 begin 
  update tbl_AgentSupplierMapping set IsActive=0 where Id=@id and Product=@Product;
 end

 ----------------------Hotel 


END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_AgentSupplierMapping] TO [rt_read]
    AS [dbo];

