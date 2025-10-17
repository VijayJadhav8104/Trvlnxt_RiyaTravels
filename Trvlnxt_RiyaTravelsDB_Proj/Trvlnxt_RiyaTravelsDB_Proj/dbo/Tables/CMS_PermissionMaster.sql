CREATE TABLE [dbo].[CMS_PermissionMaster] (
    [PKID_int]           BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [menuname_vc]        VARCHAR (50) NOT NULL,
    [path_vc]            VARCHAR (50) NULL,
    [parentid_int]       INT          NULL,
    [orderby_int]        INT          CONSTRAINT [DF_Menu_orderby_int] DEFAULT ((0)) NULL,
    [inserteddate_dt]    DATE         CONSTRAINT [DF_Menu_inserteddate_dt] DEFAULT (getdate()) NOT NULL,
    [lastupdateddate_dt] NCHAR (10)   CONSTRAINT [DF_Menu_lastupdateddate_dt] DEFAULT (getdate()) NOT NULL,
    [status_ch]          CHAR (2)     CONSTRAINT [DF_Menu_status_ch] DEFAULT ('ac') NOT NULL,
    CONSTRAINT [PK_CMS_PermissionMaster] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);

