
CREATE PROCEDURE [dbo].[insertDiscountDetails]
	-- Add the parameters for the stored procedure here
	@airlineID varchar(20)=null,
	@fare varchar(50)=null,
	@iata  decimal(10,1)=null,
	@IataOn bit=0,
	@plbEcon decimal(10,1)=null,
	@plbPrem decimal(10,1)=null,
	@plbBusn decimal(10,1)=null,
	@plbFirst decimal(10,1)=null,
	@plbOn bit=0,
	@salesFrm date=null,
	@salesTo date=null,
	@travelFrm date=null,
	@travelTo date=null,
	@officeIDPCC varchar(50)=null,
	@remarks varchar(500)=null,
	@disID bigint,
	@adminID bigint,
	@tour varchar(50)=null,
	@FlatDiscount int=null,
	@opr int = 0,
	@excludeOn varchar(10)=null,
	@Rbd varchar(30)=null,
	@Soto tinyint=0,
	@Sector varchar(30)=null
	,
	@RbdIATA varchar(30)=null,
	@SotoIATA  tinyint=0,
	@SectorIATA varchar(30)=null,
	@CommissionType int=null,
	@OfficeID int=null,
	@Username varchar(50)=null
AS
BEGIN--1
--set nocount on;
	If(@airlineID='All')
		BEGIN --2
			create   TABLE #TT(aircode varchar(20) NULL)

			insert into #TT
			SELECT [AirlineCode] AS  [_CODE] from dbo.AirlineCode_Console
   
			INSERT INTO [dbo].[DiscountMaster]
			   ([AirCode]
			   ,[FareType]
			   ,[Iata_Percent]
			   ,IsIATAOnBasic
			   ,[Econ_PLB]
			   ,[Prem_PLB]
			   ,[Busn_PLB]
			   ,[First_PLB]
			   ,IsPLBOnBasic
			   ,[salesFrm_date]
			   ,[salesTo_date]
			   ,[travelFrm_date]
			   ,[travelTo_date]
			   ,[Issue_PCC]
			   ,[Remark]
			   ,[insertDate]
			   ,[userID]
			   ,IsActive
			   ,[tour_code]
			   ,FlatDiscount
			  --  ,[Exclude_On]
           ,Rbd_exc_PLB
           ,[Soto_exc_PLB]
           ,[Sector_exc_PLB]
		   ,Rbd_exc_IATA
           ,[Soto_exc_IATA]
           ,[Sector_exc_IATA]
			,CommissionType
			,OfficeID
			,AgentID)
			select 
				aircode   ,
				@fare ,
				@iata ,
				@IataOn ,
				@plbEcon ,
				@plbPrem ,
				@plbBusn ,
				@plbFirst ,
				@plbOn ,
				@salesFrm ,
				@salesTo ,
				@travelFrm ,
				@travelTo ,
				@officeIDPCC ,
				@remarks ,
				getdate(),
				@adminID
				,'A' 
				,@tour
				,@FlatDiscount
				--,@excludeOn 
	,@Rbd ,
	@Soto ,
	@Sector 
	,@RbdIATA ,
	@SotoIATA ,
	@SectorIATA,
	@CommissionType,
	@OfficeID ,
	@Username 
	
	 from #TT

			Update [dbo].[DiscountMaster]
			Set IsActive = 'D'
			 WHERE Pk_Id  not  IN (SELECT MIN(Pk_Id) _
				FROM [dbo].[DiscountMaster] GROUP BY [AirCode]
				   ,[FareType]
				   ,[Iata_Percent]
				   ,IsIATAOnBasic
				   ,[Econ_PLB]
				   ,[Prem_PLB]
				   ,[Busn_PLB]
				   ,[First_PLB]
				   ,IsPLBOnBasic
				   ,[salesFrm_date]
				   ,[salesTo_date]
				   ,[travelFrm_date]
				   ,[travelTo_date]
				   ,[Issue_PCC]
				   ,[tour_code]
				   ,FlatDiscount --,[Exclude_On]
           ,[Rbd_exc_PLB]
           ,[Soto_exc_PLB]
           ,[Sector_exc_PLB]
		   ,Rbd_exc_IATA
           ,[Soto_exc_IATA]
           ,[Sector_exc_IATA]
		   ,CommissionType
		   ,OfficeID
		   ,AgentID
		   )
			drop table #TT

			select 3

		END --2
	else
		BEGIN--3
			IF(@opr=0)
				BEGIN--4
					--IF NOT EXISTS(SELECT * FROM [DiscountMaster] WHERE [AirCode] = @airlineID AND [FareType] = @fare and [Iata_Percent]=@iata
					--	and  [Iata_On]=@IataOn and [Econ_PLB]=@plbEcon and [Prem_PLB]=@plbPrem and [Busn_PLB]=@plbBusn and 
					--	[First_PLB]=@plbFirst and [PLB_On]=@plbOn and [salesFrm_date]=@salesFrm and [salesTo_date]=@salesTo
					--	and [travelFrm_date]=@travelFrm and [travelTo_date]=@travelTo and [Issue_PCC]=@officeIDPCC and status='A')
					--	BEGIN--5
							IF NOT EXISTS(SELECT * FROM [DiscountMaster] WHERE [AirCode] = @airlineID AND [FareType] = @fare)
								BEGIN--7
							 		INSERT INTO [dbo].[DiscountMaster]
									   ([AirCode]
									   ,[FareType]
									   ,[Iata_Percent]
									   ,IsIATAOnBasic
									   ,[Econ_PLB]
									   ,[Prem_PLB]
									   ,[Busn_PLB]
									   ,[First_PLB]
									   ,IsPLBOnBasic
									   ,[salesFrm_date]
									   ,[salesTo_date]
									   ,[travelFrm_date]
									   ,[travelTo_date]
									   ,[Issue_PCC]
									   ,[Remark]
									   ,[insertDate]
         
									   ,[userID]
									   ,IsActive
									   ,[tour_code]
									   ,FlatDiscount--,[Exclude_On]
           ,[Rbd_exc_PLB]
           ,[Soto_exc_PLB]
           ,[Sector_exc_PLB]
		   ,Rbd_exc_IATA
           ,[Soto_exc_IATA]
           ,[Sector_exc_IATA]
		   ,CommissionType
		   ,OfficeID
		   ,AgentID
		   
		   )
								VALUES
										(@airlineID,
										@fare ,
										@iata ,
										@IataOn ,
										@plbEcon ,
										@plbPrem ,
										@plbBusn ,
										@plbFirst ,
										@plbOn ,
										@salesFrm ,
										@salesTo ,
										@travelFrm ,
										@travelTo ,
										@officeIDPCC ,
										@remarks ,
										getdate(),
										@adminID ,'A',@tour,@FlatDiscount,--@excludeOn ,
	@Rbd ,
	@Soto ,
	@Sector
	,@RbdIATA ,
	@SotoIATA ,
	@SectorIATA,
	@CommissionType,
	@OfficeID,
	@Username
	
	
	)
					
									SELECT 1;
								End--7
							ELSE
								BEGIN--8
									UPDATE [dbo].[DiscountMaster] set  IsActive='D',[modifiedDate]=getdate(),ModifiedBy = @adminID 
									WHERE [AirCode] = @airlineID AND [FareType] = @fare 
						
							 		INSERT INTO [dbo].[DiscountMaster]
									   ([AirCode]
									   ,[FareType]
									   ,[Iata_Percent]
									   ,IsIATAOnBasic
									   ,[Econ_PLB]
									   ,[Prem_PLB]
									   ,[Busn_PLB]
									   ,[First_PLB]
									   ,IsPLBOnBasic
									   ,[salesFrm_date]
									   ,[salesTo_date]
									   ,[travelFrm_date]
									   ,[travelTo_date]
									   ,[Issue_PCC]
									   ,[Remark]
									   ,[insertDate]         
									   ,[userID]
									   ,IsActive
									   ,[tour_code]
									   ,FlatDiscount--,[Exclude_On]
           ,[Rbd_exc_PLB]
           ,[Soto_exc_PLB]
           ,[Sector_exc_PLB]
		   ,Rbd_exc_IATA
           ,[Soto_exc_IATA]
           ,[Sector_exc_IATA]
		   ,CommissionType
		   ,OfficeID
		   ,AgentID
		   )
									VALUES
										(@airlineID,
										@fare ,
										@iata ,
										@IataOn ,
										@plbEcon ,
										@plbPrem ,
										@plbBusn ,
										@plbFirst ,
										@plbOn ,
										@salesFrm ,
										@salesTo ,
										@travelFrm ,
										@travelTo ,
										@officeIDPCC ,
										@remarks ,
										getdate(),
										@adminID ,'A',@tour,@FlatDiscount,--@excludeOn ,
	@Rbd ,
	@Soto ,
	@Sector
	,@RbdIATA ,
	@SotoIATA ,
	@SectorIATA,
	@CommissionType,
	@OfficeID,
	@Username
	)

									SELECT 1;
								END--8
					--	END--5
					--ELSE
					--	BEGIN--9
					--		SELECT 2;
					--	END--9

				END--4
			Else
				BEGIN--6
					UPDATE [dbo].[DiscountMaster] set  IsActive='D',modifiedDate=getdate(),ModifiedBy = @adminID
					WHERE Pk_Id=@disID
	 
					SELECT 4
				END--6
		END--3
END--1







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertDiscountDetails] TO [rt_read]
    AS [dbo];

