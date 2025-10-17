CREATE TABLE [dbo].[CMS_JOB] (
    [PKID]        BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Title]       VARCHAR (50) NOT NULL,
    [Description] TEXT         NOT NULL,
    [Experince]   VARCHAR (50) NULL,
    [Location]    VARCHAR (50) NOT NULL,
    [InsertDate]  DATE         CONSTRAINT [DF_CMS_JOB_InsertDate] DEFAULT (getdate()) NOT NULL,
    [UpdateDate]  DATE         CONSTRAINT [DF_CMS_JOB_UpdateDate] DEFAULT (getdate()) NOT NULL,
    [Status]      CHAR (2)     CONSTRAINT [DF_CMS_JOB_Status] DEFAULT ('ac') NOT NULL,
    CONSTRAINT [PK_CMS_JOB] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

