CREATE TABLE [dbo].[Mailer] (
    [PKID_in]    BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [type_ch]    CHAR (1)      NULL,
    [mainimg]    VARCHAR (100) NULL,
    [murl]       VARCHAR (200) NULL,
    [fimg]       VARCHAR (100) NULL,
    [furl]       VARCHAR (200) NULL,
    [simg]       VARCHAR (100) NULL,
    [surl]       VARCHAR (200) NULL,
    [timg]       VARCHAR (100) NULL,
    [turl]       VARCHAR (200) NULL,
    [subject]    VARCHAR (200) NULL,
    [inserteddt] DATE          CONSTRAINT [DF_Mailer_inserteddt] DEFAULT (getdate()) NOT NULL,
    [status]     CHAR (1)      CONSTRAINT [DF_Mailer_status] DEFAULT ('A') NOT NULL,
    CONSTRAINT [PK_Mailer] PRIMARY KEY CLUSTERED ([PKID_in] ASC)
);

