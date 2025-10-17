CREATE TABLE [dbo].[Taxdetails] (
    [Pk_Id]        BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TaxType]      VARCHAR (50)    NULL,
    [taxPercent]   DECIMAL (10, 1) NULL,
    [insert_date]  DATE            NULL,
    [userId]       INT             NULL,
    [modifiedDate] DATE            NULL,
    [Status]       VARCHAR (5)     CONSTRAINT [DF__Taxdetail__Statu__534D60F1] DEFAULT ('A') NULL,
    [ModifiedBy]   INT             NULL,
    CONSTRAINT [PK_Taxdetails] PRIMARY KEY CLUSTERED ([Pk_Id] ASC)
);

