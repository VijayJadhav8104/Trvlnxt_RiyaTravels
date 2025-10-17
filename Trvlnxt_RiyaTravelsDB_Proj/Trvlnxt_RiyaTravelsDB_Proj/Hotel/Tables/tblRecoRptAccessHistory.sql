CREATE TABLE [Hotel].[tblRecoRptAccessHistory] (
    [PkId]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LoginUser]   INT            NULL,
    [CreatedDate] DATETIME       NULL,
    [Exception]   VARCHAR (2000) NULL,
    [Action]      VARCHAR (50)   NULL,
    CONSTRAINT [PK_tblRecoRptAccessHistory] PRIMARY KEY CLUSTERED ([PkId] ASC)
);

