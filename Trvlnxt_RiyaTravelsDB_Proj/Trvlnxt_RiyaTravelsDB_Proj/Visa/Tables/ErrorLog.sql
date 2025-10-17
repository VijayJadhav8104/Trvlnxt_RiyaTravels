CREATE TABLE [Visa].[ErrorLog] (
    [VisaErrorLogId] BIGINT         IDENTITY (1, 1) NOT NULL,
    [CreatedBy]      BIGINT         NULL,
    [CreatedDate]    DATETIME       NULL,
    [AgentID]        INT            NULL,
    [MethodName]     NVARCHAR (50)  NULL,
    [ErrorDesc]      NVARCHAR (MAX) NULL,
    CONSTRAINT [VisaErrorLogId] PRIMARY KEY CLUSTERED ([VisaErrorLogId] ASC)
);

