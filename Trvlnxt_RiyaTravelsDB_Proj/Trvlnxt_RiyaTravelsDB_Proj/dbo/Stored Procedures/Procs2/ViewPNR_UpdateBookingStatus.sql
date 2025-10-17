CREATE PROCEDURE [dbo].[ViewPNR_UpdateBookingStatus]
    @RiyaPNR varchar(50),
    @BookedBy varchar(100),
    @flag int,
    @AmendmentRef varchar(100)
AS
BEGIN
  IF (@flag = 0)
  BEGIN
   update tbl_AmendmentRequest set IsBooked=1 , AbortedBy=@BookedBy,AbortedDate=GETDATE() where RiyaPNR=@riyaPNR and AmendmentRef=@AmendmentRef

   update tblbookmaster set bookingstatus=18 where riyaPNR=@RiyaPNR

   UPDATE PBD SET PBD.bookingstatus = 18 FROM tblPassengerBookDetails PBD
      JOIN tblBookMaster BM ON PBD.fkbookmaster = BM.pkId WHERE BM.riyaPNR = @RiyaPNR;
   END
   ELSE
   BEGIN
   update tbl_AmendmentRequest set IsBooked=0 , AbortedBy=@BookedBy where RiyaPNR=@riyaPNR and AmendmentRef=@AmendmentRef

   update tblbookmaster set bookingstatus=7 where riyaPNR=@RiyaPNR and BookingStatus != 18
   
   UPDATE PBD SET PBD.bookingstatus = 7 FROM tblPassengerBookDetails PBD
      JOIN tblBookMaster BM ON PBD.fkbookmaster = BM.pkId WHERE BM.riyaPNR = @RiyaPNR and BM.BookingStatus != 18;
   END

END