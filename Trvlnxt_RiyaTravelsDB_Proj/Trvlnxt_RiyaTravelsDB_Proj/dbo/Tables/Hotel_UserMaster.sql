CREATE TABLE [dbo].[Hotel_UserMaster] (
    [PkId]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserName]   VARCHAR (50) NULL,
    [UserID]     VARCHAR (50) NULL,
    [Passward]   VARCHAR (50) NULL,
    [InsertDate] DATE         NULL,
    [Status]     BIT          NULL,
    CONSTRAINT [PK_Hotel_UserMaster] PRIMARY KEY CLUSTERED ([PkId] ASC)
);

