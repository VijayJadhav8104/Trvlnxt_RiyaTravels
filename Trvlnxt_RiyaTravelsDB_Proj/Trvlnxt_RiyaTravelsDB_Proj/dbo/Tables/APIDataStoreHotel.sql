CREATE TABLE [dbo].[APIDataStoreHotel] (
    [ID]                INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [APIOrderID]        NVARCHAR (50)  NULL,
    [apidata]           NVARCHAR (MAX) NULL,
    [portal]            VARCHAR (10)   NULL,
    [HotelMergeModel]   NVARCHAR (MAX) NULL,
    [TypeOfExec]        NVARCHAR (50)  NULL,
    [FL]                NVARCHAR (MAX) NULL,
    [CreatedDate]       DATETIME       NULL,
    [EncryptReqPayment] NVARCHAR (MAX) NULL,
    [DecryptReqPay]     NVARCHAR (MAX) NULL,
    [EncryptResPayment] NVARCHAR (MAX) NULL,
    [DecryptResPay]     NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

