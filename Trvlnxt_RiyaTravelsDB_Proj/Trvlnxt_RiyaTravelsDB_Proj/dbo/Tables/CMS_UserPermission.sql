CREATE TABLE [dbo].[CMS_UserPermission] (
    [PKID_int]           BIGINT   IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKmenuID_int]       BIGINT   NOT NULL,
    [FKUserID_int]       BIGINT   NOT NULL,
    [inserteddate_dt]    DATE     CONSTRAINT [DF_CMS_UserPermission_inserteddate_dt] DEFAULT (getdate()) NOT NULL,
    [lastupdateddate_dt] DATE     CONSTRAINT [DF_CMS_UserPermission_lastupdateddate_dt] DEFAULT (getdate()) NOT NULL,
    [status_ch]          CHAR (2) CONSTRAINT [DF_CMS_UserPermission_status_ch] DEFAULT ('ac') NOT NULL,
    CONSTRAINT [PK_CMS_UserPermission] PRIMARY KEY CLUSTERED ([PKID_int] ASC),
    CONSTRAINT [FK_CMS_UserPermission_Menu] FOREIGN KEY ([FKmenuID_int]) REFERENCES [dbo].[CMS_PermissionMaster] ([PKID_int]),
    CONSTRAINT [FK_CMS_UserPermission_usermaster] FOREIGN KEY ([FKUserID_int]) REFERENCES [dbo].[CMS_UserMaster] ([PKID_int])
);

