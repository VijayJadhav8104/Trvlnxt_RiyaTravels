CREATE TABLE [dbo].[InvoicesPageVisitedAudit] (
    [ID]                      INT           IDENTITY (1, 1) NOT NULL,
    [FK_InvoicesLoginAuditId] INT           NULL,
    [PageVisted]              VARCHAR (500) NULL,
    [VisitedOn]               DATETIME      NULL
);

