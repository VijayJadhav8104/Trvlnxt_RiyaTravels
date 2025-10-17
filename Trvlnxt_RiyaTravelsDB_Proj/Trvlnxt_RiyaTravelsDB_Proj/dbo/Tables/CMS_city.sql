CREATE TABLE [dbo].[CMS_city] (
    [PKID_int]      BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name_vc]       VARCHAR (50) NOT NULL,
    [Fkstate_int]   BIGINT       NULL,
    [FKcountry_int] BIGINT       NULL,
    CONSTRAINT [PK_CMS_city] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);

