CREATE TABLE [dbo].[tblTrvlnxtDailyReportEmailIds] (
    [Id]        BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EmailTo]   VARCHAR (50) NULL,
    [EmailCC]   VARCHAR (50) NULL,
    [Date]      DATETIME     CONSTRAINT [DF_tblTrvlnxtDailyReportEmailIds_Date] DEFAULT (getdate()) NULL,
    [Status]    BIT          CONSTRAINT [DF_tblTrvlnxtDailyReportEmailIds_Status] DEFAULT ((1)) NULL,
    [EmailType] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblTrvlnxtDailyReportEmailIds] PRIMARY KEY CLUSTERED ([Id] ASC)
);

