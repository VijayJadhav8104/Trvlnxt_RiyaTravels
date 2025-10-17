
Create Proc UpdateSequenceAPIBookId
@num int=0
AS
BEGIN 
  Update [Hotel].[Hotel_orders_sequence] set API_Sequence_No=@num Where id=1
END
