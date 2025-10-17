  
--EXEC IsRiyaPNRExits '2A90FR'   
CREATE PROC IsRiyaPNRExits  
@RiyaPNR varchar(12) = null  
As   
Begin   
if exists(select pkid from tblBookMaster where riyaPNR=@RiyaPNR)  
begin  
select 1 as riyaPNRcount   
end  
else  
begin  
select 0 as riyaPNRcount  
END  
  
end  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[IsRiyaPNRExits] TO [rt_read]
    AS [dbo];

