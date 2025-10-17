CREATE Procedure Proc_InsertRetrivePNRResponse  
@RetrivePNRResponse varchar(max)=null,  
@PNRNumber varchar(50)=null,  
@MethodName varchar(100)=null  
As  
Begin  
	if exists(Select top 1 * from Hotel_RetrivePNRAPIResponse Where PNRNumber=@PNRNumber order by InsertedDate desc )
	Begin
		update Hotel_RetrivePNRAPIResponse Set RetrivePNRResponse=@RetrivePNRResponse Where PNRNumber=@PNRNumber
	END
	Else
	Begin
	Insert into Hotel_RetrivePNRAPIResponse  
	(RetrivePNRResponse,  
	InsertedDate,  
	PNRNumber,  
	MethodName  
	)  
	values(  
	@RetrivePNRResponse,  
	GETDATE(),  
	@PNRNumber,  
	@MethodName  
	)  
	END

End