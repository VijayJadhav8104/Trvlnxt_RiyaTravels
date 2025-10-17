CREATE TABLE [dbo].[tblCustomerCreationlog] (
    [PKID]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ICUST]     VARCHAR (100) NULL,
    [Status]    VARCHAR (MAX) NULL,
    [EntryDate] DATETIME      NULL,
    CONSTRAINT [PK_tblCustomerCreationlog] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

