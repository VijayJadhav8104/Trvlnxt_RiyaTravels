CREATE TABLE [dbo].[tblERPMaster] (
    [Pkid]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Category]          NCHAR (50)    NULL,
    [CategoryValue]     NVARCHAR (50) NULL,
    [CategoryCondition] NVARCHAR (50) NULL,
    [Sector]            NCHAR (10)    NULL,
    CONSTRAINT [PK_tblERPMaster] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

