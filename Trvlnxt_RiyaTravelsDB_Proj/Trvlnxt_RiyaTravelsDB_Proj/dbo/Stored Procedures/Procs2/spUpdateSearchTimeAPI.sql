CREATE proc [dbo].[spUpdateSearchTimeAPI] 
            @Id varchar(50)=''
		   ,@ResponseDateTime varchar(50)=''			
as
begin
Update [dbo].[SearchTimeAPI] SET [ResponseDateTime] = @ResponseDateTime Where Id = @Id  
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdateSearchTimeAPI] TO [rt_read]
    AS [dbo];

