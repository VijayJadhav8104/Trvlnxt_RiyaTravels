CREATE Procedure Proc_UpdataPGStatus
@Pkid Int=0,
@Status varchar(50)=''
As
Begin
 UPDATE Hotel_BookMaster Set PGStatus=@Status Where pkId=@Pkid
END