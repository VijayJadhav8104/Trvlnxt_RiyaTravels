-- ============================================= 
-- Author:     
-- Create date:  
-- Description:   
-- ============================================= 
CREATE PROCEDURE [dbo].[VisaAssurance] -- [VisaAssurance] null,'uiy','uyi','567' 
  @Id            INT = NULL, 
  @Name          VARCHAR(200) = NULL, 
  @Email         NVARCHAR(500) = NULL, 
  @Mobile        NVARCHAR(20) = NULL, 
  @State         INT = NULL, 
  @Branch        INT = NULL, 
  @ApplicantNo   INT = NULL, 
  @CouponCode    NVARCHAR(20) = NULL, 
  @IP            NVARCHAR(20) = NULL, 
  @Device        VARCHAR(200) = NULL, 
  @StateId       INT = NULL, 
  @ActualAmt     INT = NULL, 
  @DiscountedAmt INT = NULL, 
  @Action        VARCHAR(200) = 'Create', 
  @OrderId       NVARCHAR(50) = NULL, 
  @Status        SMALLINT=0
AS 
  BEGIN 
      -- SET NOCOUNT ON added to prevent extra result sets from 
      -- interfering with SELECT statements. 
      DECLARE @invSeqNo VARCHAR(10) 
      DECLARE @invoiceNo NVARCHAR(50) 

      SET nocount ON; 

      -- Insert statements for procedure here 
      IF( @Action = 'Create' ) 
        BEGIN 
            SET @invSeqNo='1'  + (SELECT TOP 1 Isnull(invseqno, 0) FROM   tblvisaassurance ORDER  BY 1 DESC) 
            SET @invSeqNo=Isnull(@invSeqNo, 001) 

            SELECT @invoiceNo = Concat('VA-', Cast(Format(Getdate(), 'ddMM') AS NVARCHAR), 
			CASE WHEN Len(@invSeqNo) = 1 THEN Concat('00', @invSeqNo) 
                 WHEN Len(@invSeqNo) = 2 THEN Concat('0', @invSeqNo) 
                 ELSE @invSeqNo END) 

            INSERT INTO tblvisaassurance(
						 NAME, 
                         email, 
                         mobile, 
                         state, 
                         branch, 
                         visaapplicantno, 
                         couponcode, 
                         ip, 
                         device, 
                         orderid, 
                         [status], 
                         actualamt, 
                         discountedamt, 
                         invseqno, 
                         invoiceno) 
            VALUES      (@Name, 
                         @Email, 
                         @Mobile, 
                         @State, 
                         @Branch, 
                         @ApplicantNo, 
                         @CouponCode, 
                         @IP, 
                         @Device, 
                         @OrderId, 
                         @Status, 
                         @ActualAmt, 
                         @DiscountedAmt, 
                         @invSeqNo, 
                         @invoiceNo) 

            SELECT Scope_identity() 
        END 

      IF( @Action = 'Status' ) 
        BEGIN 
            UPDATE tblvisaassurance 
            SET    [status] = @Status 
            WHERE  id = @Id 
        END 

      IF( @Action = 'Update' ) 
        BEGIN 
            UPDATE tblvisaassurance 
            SET    NAME = @Name, 
                   email = @Email, 
                   mobile = @Mobile, 
                   [state] = @State, 
                   branch = @Branch, 
                   visaapplicantno = @ApplicantNo, 
                   couponcode = @CouponCode, 
                   ip = @IP, 
                   device = @Device, 
                   actualamt = @ActualAmt, 
                   discountedamt = @DiscountedAmt 
            WHERE  id = @Id 
        END 

      IF( @Action = 'GetState' ) 
        BEGIN 
            SELECT distinct SC.id, 
                   SC.state 
            FROM   tblstatecode SC where id not in(8,40)
        END 

      IF( @Action = 'GetBranch' ) 
        BEGIN 
		select id,CONCAT(Branch,' (',[State],')~',[Address]) as 'Branch' from VisaAssuranceBranch where IsActive=1 order by [state]
--            --select '','*Nearest Riya Branch' 
--            --union 
--            IF EXISTS(SELECT TOP 1 bd.id, 
--                                   bd.branchlocation AS Branch 
--                      FROM   tblbranchdimension bd 
--INNER JOIN tblstatecode sc 
--                                     ON bd.stateid = sc.id 
--                      WHERE  sc.id = @StateId) 
--              BEGIN 
--                  SELECT bd.id, 
--                         bd.branchlocation AS Branch 
--                  FROM   tblbranchdimension bd 
--                         INNER JOIN tblstatecode sc 
--                                 ON bd.stateid = sc.id 
--                  WHERE  sc.id = @StateId --order by bd.BranchLocation asc 
--              END 
--            ELSE 
--              BEGIN 
--                  SELECT bd.id, 
--                         Concat(sc.[state], '-', bd.branchlocation) AS Branch 
--                  FROM   tblbranchdimension bd 
--                         INNER JOIN tblstatecode sc 
--                                 ON bd.stateid = sc.id 
--              END 
        END 
  END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[VisaAssurance] TO [rt_read]
    AS [dbo];

