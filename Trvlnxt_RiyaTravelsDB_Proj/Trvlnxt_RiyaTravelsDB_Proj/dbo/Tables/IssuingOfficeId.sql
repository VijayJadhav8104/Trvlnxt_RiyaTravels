CREATE TABLE [dbo].[IssuingOfficeId] (
    [pk_id]    BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [officeId] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PCCoffice1] PRIMARY KEY CLUSTERED ([pk_id] ASC)
);

