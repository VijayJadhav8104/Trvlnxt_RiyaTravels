CREATE TABLE [dbo].[tblPassengerFareDetails] (
    [pkid]           INT             IDENTITY (1, 1) NOT NULL,
    [OrderId]        VARCHAR (100)   NULL,
    [fkBookMaster]   INT             NULL,
    [paxid]          INT             NULL,
    [BaseAmount]     DECIMAL (18, 2) NULL,
    [Commission]     DECIMAL (18, 2) NULL,
    [Discount]       DECIMAL (18, 2) NULL,
    [GrossAmount]    DECIMAL (18, 2) NULL,
    [Incentive]      DECIMAL (18, 2) NULL,
    [PLBAmount]      DECIMAL (18, 2) NULL,
    [Paxtype]        VARCHAR (50)    NULL,
    [ServiceFee]     DECIMAL (18, 2) NULL,
    [ServiceFeeGST]  DECIMAL (18, 2) NULL,
    [Servicecharge]  DECIMAL (18, 2) NULL,
    [TDS]            DECIMAL (18, 2) NULL,
    [TotalTaxAmount] DECIMAL (18, 2) NULL,
    [IsSSOUser]      BIT             NULL,
    [InsertedDate]   DATETIME        NULL,
    CONSTRAINT [PK_tblPassengerFareDetails] PRIMARY KEY CLUSTERED ([pkid] ASC)
);

