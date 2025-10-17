
CREATE Proc Hotel.RecoRptAccessHistory  
  
@LoginUser int,  
@Exception varchar(2000),
@UserAction varchar(50)
  
as  
begin  
  
insert into Hotel.tblRecoRptAccessHistory  (LoginUser,CreatedDate,Exception,Action)   
values (@LoginUser,GETDATE(),@Exception,@UserAction)  
end