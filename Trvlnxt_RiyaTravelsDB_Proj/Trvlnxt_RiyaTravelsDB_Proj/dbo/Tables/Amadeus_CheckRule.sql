CREATE TABLE [dbo].[Amadeus_CheckRule] (
    [PKID]         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Category]     INT            NULL,
    [Header]       NVARCHAR (500) NULL,
    [Description]  NVARCHAR (MAX) NULL,
    [DisplayOrder] INT            NULL,
    [VendorName]   VARCHAR (50)   NULL,
    CONSTRAINT [PK_Amadeus_CheckRule] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

