

CREATE proc [Hotel].GetRoeValue  -- [Hotel].GetRoeValue 'INR','USD' 
 @FromCurr varchar(20)=''
,@ToCurr Varchar(20)=''

AS

BEGIN 
  
    Select top 1 id,FromCur,ToCur,Roe,IsActive from ROE where FromCur=@FromCurr and ToCur=@ToCurr and IsActive=1

END