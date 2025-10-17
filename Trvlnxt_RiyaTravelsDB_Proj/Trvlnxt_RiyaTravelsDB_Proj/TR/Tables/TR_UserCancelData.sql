CREATE TABLE [TR].[TR_UserCancelData] (
    [Id]             INT          NULL,
    [fk_pkid]        BIGINT       NULL,
    [cancelledflag]  INT          NULL,
    [CancelledRefId] VARCHAR (50) NULL,
    [EmailId]        VARCHAR (50) NULL,
    [MethodName]     VARCHAR (50) NULL
);

