Create proc [dbo].[spUpdateSearchTime] 
            @Id varchar(50)=''
		   ,@ResponseDateTime varchar(50)=''			
as
begin
Update [dbo].[SearchTime] SET [ResponseDateTime] = @ResponseDateTime Where [ID] = @Id  
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdateSearchTime] TO [rt_read]
    AS [dbo];

