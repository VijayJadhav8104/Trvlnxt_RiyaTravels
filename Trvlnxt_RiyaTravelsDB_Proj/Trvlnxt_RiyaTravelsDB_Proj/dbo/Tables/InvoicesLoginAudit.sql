CREATE TABLE [dbo].[InvoicesLoginAudit] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [EmpCode]   VARCHAR (50) NULL,
    [AgentId]   VARCHAR (50) NULL,
    [LoginDate] DATETIME     NULL
);

