CREATE TABLE [dbo].[tbl_commonmaster] (
    [pkid]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Category]      VARCHAR (100) NULL,
    [CategoryValue] VARCHAR (100) NULL,
    [Mapping]       INT           NULL,
    [Country]       VARCHAR (2)   NULL,
    [Currency]      VARCHAR (3)   NULL,
    [UserTypeID]    INT           NULL,
    [DisplayText]   VARCHAR (100) NULL,
    [DefaultFlag]   INT           NULL,
    [CRSName]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_tbl_commonmaster] PRIMARY KEY CLUSTERED ([pkid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tbl_commonmaster_CategoryValue]
    ON [dbo].[tbl_commonmaster]([CategoryValue] ASC);

