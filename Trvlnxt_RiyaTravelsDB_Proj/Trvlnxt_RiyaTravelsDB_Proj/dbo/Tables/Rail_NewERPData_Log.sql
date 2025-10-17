CREATE TABLE [dbo].[Rail_NewERPData_Log] (
    [ID]                 INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FK_tblbookmasterID] BIGINT        NULL,
    [Type]               NVARCHAR (50) NULL,
    [Response]           VARCHAR (MAX) NULL,
    [Request]            VARCHAR (MAX) NULL,
    [CreatedOn]          DATETIME      NULL,
    [PaymentResponse]    VARCHAR (MAX) NULL,
    [PaymentRequest]     VARCHAR (MAX) NULL,
    [PaymentType]        NVARCHAR (50) NULL
);

