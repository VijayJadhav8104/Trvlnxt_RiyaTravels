CREATE TABLE [dbo].[tblVisaAssurance] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]            VARCHAR (200)  NULL,
    [Email]           NVARCHAR (500) NULL,
    [Mobile]          VARCHAR (200)  NULL,
    [State]           INT            NULL,
    [Branch]          INT            NULL,
    [VisaApplicantNo] INT            NULL,
    [CouponCode]      NVARCHAR (500) NULL,
    [CreatedOn]       DATETIME       CONSTRAINT [DF_tblVisaAssurance_CreatedOn] DEFAULT (getdate()) NULL,
    [IP]              NVARCHAR (500) NULL,
    [Device]          VARCHAR (200)  NULL,
    [OrderId]         NVARCHAR (50)  NULL,
    [ActualAmt]       INT            NULL,
    [DiscountedAmt]   INT            NULL,
    [InvSeqNo]        INT            NULL,
    [InvoiceNo]       NVARCHAR (50)  NULL,
    [Status]          SMALLINT       NULL,
    CONSTRAINT [PK_tblVisaAssurance] PRIMARY KEY CLUSTERED ([Id] ASC)
);

