

CREATE PROCEDURE [dbo].[Sp_BindROEData] 
	@Type varchar(20),
	@Country varchar(max)=null,
	@StateId varchar(max)=null,
	@Branch varchar(max)=null,
	@userType int=null

AS
BEGIN
	IF(@Type='COUNTRY')
	BEGIN
		IF(@Country='IN')	--WILL RETURN STATES
		BEGIN 
			--SELECT * FROM mState WHERE status=1

			SELECT distinct id,StateName FROM mState S
			inner join B2BRegistration B on b.StateID=s.ID
			inner join agentLogin A on A.UserID=B.FKUserID
			WHERE s.status=1 AND A.userTypeID=@userType

		END
		ELSE	--WILL RETURN BRANCH
		BEGIN
			SELECT DISTINCT  R.BranchCode AS Branch,B.BranchCode FROM B2BRegistration R
			--INNER JOIN mstate S ON S.ID=R.STATEID
			INNER JOIN mBranch B ON B.BranchCode=R.BranchCode
			INNER JOIN agentLogin AL on AL.UserID=R.FKUserID
			WHERE AL.BookingCountry=@Country AND AL.userTypeID=@userType
		END
	END

	ELSE IF(@Type='STATE')	-- WILL RETURN BRANCH
	BEGIN
		IF(@StateId='ALL')
		BEGIN
			select DISTINCT R.BranchCode AS Branch,B.BranchCode,Name as BranchName,b.Name+' ['+b.BranchCode+']' as 'CodeName' from B2BRegistration R
			inner join mstate S ON S.ID=R.STATEID
	
		INNER JOIN mBranch B ON B.BranchCode=R.BranchCode
			inner join agentLogin AL on AL.UserID=R.FKUserID
			WHERE AL.BookingCountry= 'IN' AND AL.userTypeID=@userType
		END
		ELSE
		BEGIN
			select DISTINCT  R.BranchCode AS Branch,B.BranchCode,Name as BranchName,b.Name+' ['+b.BranchCode+']' as 'CodeName' from B2BRegistration R
			inner join mstate S ON S.ID=R.STATEID
			INNER JOIN mBranch B ON B.BranchCode=R.BranchCode
			inner join agentLogin AL on AL.UserID=R.FKUserID
			WHERE R.Stateid IN (select DATA from sample_split(@StateId,',')) AND AL.userTypeID=@userType
		END
	END

	ELSE IF(@Type='BRANCH')	--WILL RETURN AGENCY
	BEGIN
	  IF (@userType!=4)
		BEGIN
			SELECT PKID, Icast, AgencyName, al.UserID, Icast+' - '+AgencyName as IcustWithAgencyName FROM B2BRegistration b
			inner join agentLogin al on al.UserID = b.FKUserID
			where al.BookingCountry = @Country AND AgentApproved=1 
			and b.BranchCode IN (select DATA from sample_split(@Branch,','))  -- earlier was commnted due to which large  data was loaded and page get hang
			and UserTypeID=@userType
		END
	   ELSE if(@userType=4 and @Country<>'US')
		BEGIN
			SELECT PKID, Icast, AgencyName, al.UserID, Icast+' - '+AgencyName as IcustWithAgencyName FROM B2BRegistration b
			inner join agentLogin al on al.UserID = b.FKUserID
			where al.BookingCountry = @Country AND AgentApproved=1 
			--And B.StateID IN (select DATA from sample_split(@StateId,','))
			and UserTypeID=@userType
		END
		else
		BEGIN
			SELECT PKID, Icast, AgencyName, al.UserID, Icast+' - '+AgencyName as IcustWithAgencyName FROM B2BRegistration b
			inner join agentLogin al on al.UserID = b.FKUserID
			where al.BookingCountry = @Country AND AgentApproved=1 
			--and b.BranchCode IN (select DATA from sample_split(@Branch,','))
			and UserTypeID=@userType
		END
	 END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_BindROEData] TO [rt_read]
    AS [dbo];

