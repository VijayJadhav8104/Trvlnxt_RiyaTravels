
CREATE proc [dbo].[spInsertErrorLog]
 @ErrMsg varchar(max)
 ,@ErrDetails varchar(5000)
 ,@jsonObj varchar(max)=null
 ,@Country varchar(2)=null
as
begin

  insert into [dbo].[tblExceptionLog]([ErrMsg],[ErrDetails],Country) values(@ErrMsg,@ErrDetails,@Country);

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertErrorLog] TO [rt_read]
    AS [dbo];

