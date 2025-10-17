CREATE PROCEDURE [dbo].[sp_Get_Ins_Planname]            
  @Plantype Varchar(50),
  @Planname Varchar(max)=null,
  @Areaname Varchar (100)=null, 
  @Age decimal(18,2)=null,
  @AMTNoofDays varchar(10)=null,
  @NoofDays varchar(10)=null,
  @Flag Varchar(10)
AS  
BEGIN  
	if(@Flag='PLANNAME')
	BEGIN
		
		if(@Plantype='Annual' and @AMTNoofDays='45')
		begin
			Select distinct A.planName from Ins_planName(nolock) A
			join Ins_planDetails(nolock) B on A.planName=B.planName 
			where A.planType=@Plantype and B.areaName=@Areaname and  b.minAge<=@Age and @Age<=b.maxAge
			and A.planName like '%per trip limit of '+@AMTNoofDays+'%' or A.planName in ('Corporate Elite Lite','Corporate Elite Plus')
		end
		else if (@Plantype='Annual')
		begin
			Select distinct A.planName from Ins_planName(nolock) A
			join Ins_planDetails(nolock) B on A.planName=B.planName 
			where A.planType=@Plantype and B.areaName=@Areaname and  b.minAge<=@Age and @Age<=b.maxAge
			and A.planName like '%per trip limit of '+@AMTNoofDays+'%' 
		end
		else
		begin
			Select distinct A.planName from Ins_planName(nolock) A
			join Ins_planDetails(nolock) B on A.planName=B.planName 
			where A.planType=@Plantype and B.areaName=@Areaname and b.minAge<=@Age and @Age<=b.maxAge
			-- and b.minDays<=@NoofDays and @NoofDays<=b.maxDays 
		end
		--begin
		--	Select distinct A.planName from Ins_planName(nolock) A
		--	join Ins_planDetails(nolock) B on A.planName=B.planName 
		--	where A.planType=@Plantype and B.areaName=@Areaname and b.minAge>=@Age and @Age<=b.maxAge
		--end

		--if(@Areaname='Schengen')
		--begin
		--	Select planName from Ins_planName(nolock) where areaName='Schengen' 
		--end
		--else if(@Areaname='Asia Excluding Japan')
		--begin
		--	Select planName from Ins_planName(nolock) where areaName='Asia Excluding Japan'
		--end
		--else
		--begin
		--	--Select planName from Ins_planName(nolock)
		--	if(@Plantype='Annual' and @AMTNoofDays='45')
		--	begin
		--		Select planName from Ins_planName(nolock) where planName like '%per trip limit of '+@AMTNoofDays+'%' or planName in ('Corporate Elite Lite','Corporate Elite Plus') 
		--		and planType = 'Annual'
		--	end
		--	else if (@Plantype='Annual')
		--	begin
		--		Select planName from Ins_planName(nolock) where planName like '%per trip limit of '+@AMTNoofDays+'%' 
		--		and planType = 'Annual'
		--	end
		--	else if (@Plantype='Family')
		--	begin
		--		Select planName from Ins_planName(nolock) where planType = 'Family'
		--	end
		--	else if (@Plantype='Student')
		--	begin
		--		Select planName from Ins_planName(nolock) where planType = 'Student'
		--	end
		--	else if (@Plantype='Individual')
		--	begin
		--		if(@Age >= 71)
		--		begin
		--			Select planName from Ins_planName(nolock) where planType = 'Individual' 
		--			and isnull(areaName,'') not in ('Schengen','Asia Excluding Japan')
		--			AND (CONVERT(INT,(SUBSTRING(ageLimit,CHARINDEX('-',ageLimit)+1,LEN(ageLimit))))) >= @Age
		--			AND (CONVERT(INT,(SUBSTRING(ageLimit,0,CHARINDEX('-',ageLimit))))) <= @Age
		--		end
		--		else
		--		begin
		--			Select planName from Ins_planName(nolock) where planType = 'Individual' 
		--			and isnull(areaName,'') not in ('Schengen','Asia Excluding Japan') and ageLimit is null
		--		end
		--	end
		--end
	END
	Else if(@Flag='FETCH')
		BEGIN
			Select [planID],[planName],[areaName],[minDays],[maxDays],[minAge],[maxAge],[benefits],[deductible],[limits],[updatedDate],[insurerName] 
			from Ins_planDetails(nolock) where planName=@Planname and areaName=@Areaname
		END
	Else
		BEGIN
			Select [planID],[planName],[areaName],[minDays],[maxDays],[minAge],[maxAge],[benefits],[deductible],[limits],[updatedDate],[insurerName] 
			from Ins_planDetails(nolock) where planName=@Planname and areaName=@Areaname
		END
 
END
