CREATE TABLE [dbo].[state] (
    [PKID_int]      BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [name_vc]       VARCHAR (50) NOT NULL,
    [Fkcountry_int] BIGINT       NULL,
    CONSTRAINT [PK_state] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);

