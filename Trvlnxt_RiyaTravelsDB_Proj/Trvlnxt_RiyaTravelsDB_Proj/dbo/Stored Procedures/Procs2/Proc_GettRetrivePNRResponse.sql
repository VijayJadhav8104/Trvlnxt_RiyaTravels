Create Procedure Proc_GettRetrivePNRResponse
@PNRNumber varchar(50)=null
As
Begin
	Select RetrivePNRResponse from Hotel_RetrivePNRAPIResponse Where PNRNumber=@PNRNumber order by InsertedDate desc
End