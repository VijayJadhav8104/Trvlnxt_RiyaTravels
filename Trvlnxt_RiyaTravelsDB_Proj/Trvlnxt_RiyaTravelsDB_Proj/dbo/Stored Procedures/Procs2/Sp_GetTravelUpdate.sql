-- =============================================
-- Author:		bhavika kawa
-- Description:	To get travel update
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetTravelUpdate]
@JCountry varchar(50),
@RCountry varchar(50),
@T1Country varchar(50),
@T2Country varchar(50),
@UserTypeId  int,
@Country varchar(50)
	
AS
BEGIN
	if exists(select ID from mTravelUpdate where JoiningCountry=@JCountry and RepatriationCountry=@RCountry 
						and TransitCountry1=@T1Country and TransitCountry2=@T2Country and Country=@Country
						and UserTypeId=@UserTypeId and IsActive=1)
	begin
		select * from mTravelUpdate where JoiningCountry=@JCountry and RepatriationCountry=@RCountry 
						and TransitCountry1=@T1Country and TransitCountry2=@T2Country and Country=@Country
						and UserTypeId=@UserTypeId and IsActive=1
	end
	else
	begin
		if(@JCountry!='')
		begin
		select * from mTravelUpdate where JoiningCountry=@JCountry and Country=@Country
						and UserTypeId=@UserTypeId and IsActive=1
		end
		if(@RCountry!='')
		begin
		select * from mTravelUpdate where RepatriationCountry=@RCountry and Country=@Country
						and UserTypeId=@UserTypeId and IsActive=1
		end
		if(@T1Country!='')
		begin
		select * from mTravelUpdate where TransitCountry1=@T1Country and Country=@Country
						and UserTypeId=@UserTypeId and IsActive=1
		end
		if(@T2Country!='')
		begin
		select * from mTravelUpdate where TransitCountry2=@T2Country and Country=@Country
						and UserTypeId=@UserTypeId and IsActive=1
		end
	end
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetTravelUpdate] TO [rt_read]
    AS [dbo];

