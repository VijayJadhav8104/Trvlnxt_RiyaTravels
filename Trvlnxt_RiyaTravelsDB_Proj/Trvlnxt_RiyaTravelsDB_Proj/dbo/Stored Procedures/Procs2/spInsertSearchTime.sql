CREATE proc [dbo].[spInsertSearchTime] 
            @BackendUserID varchar(50)='',
			@AgencyID varchar(50) = ''
           ,@RequestDateTime varchar(255)=''
           ,@ResponseDateTime varchar(255)=''
           ,@fromSector varchar(255)=''
           ,@ToSector varchar(255)=''
           ,@DepartureDate varchar(255)=''
		   ,@ReturnDate varchar(255)=''
		   ,@Product varchar(255)=''
as
begin
INSERT INTO [dbo].[SearchTime]
           (BackendUserID
		  ,AgencyID
		  ,RequestDateTime
		  ,ResponseDateTime
		  ,fromSector
		  ,ToSector
		  ,DepartureDate
		  ,ReturnDate
		  ,Product)
     VALUES
           (@BackendUserID
		   ,@AgencyID
		   ,@RequestDateTime
		   ,@ResponseDateTime
		   ,@fromSector
		   ,@ToSector
		   ,@DepartureDate
		   ,@ReturnDate
		   ,@Product)
	
  select SCOPE_IDENTITY();
	  
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertSearchTime] TO [rt_read]
    AS [dbo];

