Create proc [dbo].[spInsertSearchTimeAPI] 
            @airline varchar(100)='',
			@SearchTimeID INT = ''
           ,@RequestDateTime varchar(255)=''
           ,@ResponseDateTime varchar(255)=''
          
as
begin
INSERT INTO [dbo].[SearchTimeAPI]
           (VendorName
		  ,SearchId
		  ,RequestDateTime
		  ,ResponseDateTime)
     VALUES
           (@airline
		   ,@SearchTimeID
		   ,@RequestDateTime
		   ,@ResponseDateTime
		 )
	
  select SCOPE_IDENTITY();
	  
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertSearchTimeAPI] TO [rt_read]
    AS [dbo];

