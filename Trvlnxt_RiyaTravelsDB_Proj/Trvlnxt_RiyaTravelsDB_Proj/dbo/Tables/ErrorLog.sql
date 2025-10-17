CREATE TABLE [dbo].[ErrorLog] (
    [pageID_int]      BIGINT         NOT NULL,
    [pagename_vc]     VARCHAR (50)   NOT NULL,
    [classname_vc]    VARCHAR (50)   NULL,
    [methodname_vc]   VARCHAR (50)   NULL,
    [error_vc]        VARCHAR (1000) NOT NULL,
    [inserteddate_dt] DATETIME       CONSTRAINT [DF_ErrorLog_inserteddate_dt] DEFAULT (getdate()) NOT NULL,
    [status_ch]       CHAR (2)       CONSTRAINT [DF_ErrorLog_status_ch] DEFAULT ('ac') NOT NULL,
    CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED ([pageID_int] ASC)
);

