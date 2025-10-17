CREATE TABLE [dbo].[tblCrpticCommandAccess] (
    [PKId]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CommandName] VARCHAR (100) NULL,
    [OfficeId]    VARCHAR (50)  NULL,
    [VendorName]  VARCHAR (50)  NULL,
    [AgentId]     VARCHAR (50)  NULL,
    [IsActive]    BIT           NULL,
    CONSTRAINT [PK_tblCrpticCommandAccess] PRIMARY KEY CLUSTERED ([PKId] ASC)
);

