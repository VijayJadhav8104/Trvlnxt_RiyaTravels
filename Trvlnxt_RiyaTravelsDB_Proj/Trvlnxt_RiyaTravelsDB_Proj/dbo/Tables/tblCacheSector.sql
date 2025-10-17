CREATE TABLE [dbo].[tblCacheSector] (
    [id]         BIGINT       IDENTITY (101, 1) NOT FOR REPLICATION NOT NULL,
    [From]       VARCHAR (10) NULL,
    [To]         VARCHAR (10) NULL,
    [rtnFrom]    VARCHAR (10) NULL,
    [rtnTo]      VARCHAR (10) NULL,
    [insertedOn] DATETIME     CONSTRAINT [DF_tblCacheSector_insertedOn] DEFAULT (getdate()) NULL,
    [days]       INT          NULL,
    [hours]      INT          NULL,
    [minute]     INT          NULL,
    CONSTRAINT [PK_tblCacheSector] PRIMARY KEY CLUSTERED ([id] ASC)
);

