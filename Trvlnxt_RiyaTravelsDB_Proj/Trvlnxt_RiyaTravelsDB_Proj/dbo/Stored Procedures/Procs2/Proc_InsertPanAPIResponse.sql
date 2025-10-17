create Procedure Proc_InsertPanAPIResponse
@PanAPIRespone varchar(max)=''
as
Begin
	Insert into HotelPanAPIResponseData(PanAPIResponse,InsertedDate) values(@PanAPIRespone,GETDATE())
END