CREATE proc [dbo].[spUpdateSearchAPIResponseTime] 
            @Id varchar(50)=''
		   ,@APIResponseTime varchar(50)=''
		   ,@APIRequestTime	varchar(50)=''
		   ,@ResponseType varchar(20)=''	
as
begin

if(@APIRequestTime!='')

Begin

Update [dbo].[SearchTimeAPI] SET APIRequestTime = @APIRequestTime,ResponseType=@ResponseType Where Id = @Id  

END 

if(@APIResponseTime!='')

Begin

Update [dbo].[SearchTimeAPI] SET APIResponseTime = @APIResponseTime Where Id= @Id  

END






end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdateSearchAPIResponseTime] TO [rt_read]
    AS [dbo];

