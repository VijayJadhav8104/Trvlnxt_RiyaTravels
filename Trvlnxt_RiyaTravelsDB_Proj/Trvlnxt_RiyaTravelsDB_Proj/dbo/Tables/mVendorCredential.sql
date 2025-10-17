CREATE TABLE [dbo].[mVendorCredential] (
    [ID]         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VendorId]   INT            NOT NULL,
    [OfficeId]   VARCHAR (50)   NULL,
    [FieldName]  VARCHAR (50)   NULL,
    [Value]      VARCHAR (1000) NULL,
    [CreatedOn]  DATETIME2 (7)  CONSTRAINT [DF_mVendorCredential_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  INT            NOT NULL,
    [ModifiedOn] DATETIME2 (7)  NULL,
    [ModifiedBy] INT            NULL,
    [IsActive]   BIT            CONSTRAINT [DF_mVendorCredential_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mVendorCredential] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [mVendorCredential_OfficeId]
    ON [dbo].[mVendorCredential]([OfficeId] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-FieldName]
    ON [dbo].[mVendorCredential]([FieldName] ASC);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_INDEX_2]
    ON [dbo].[mVendorCredential]([VendorId] ASC, [IsActive] ASC)
    INCLUDE([OfficeId], [FieldName], [Value]);

