CREATE TABLE [dbo].[HotelAPIUser] (
    [Id]        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LoginId]   NVARCHAR (15)  NULL,
    [Passward]  NVARCHAR (15)  NULL,
    [IPAddress] NVARCHAR (500) NULL,
    [createdOn] DATETIME       CONSTRAINT [DF_HotelAPIUser_createdOn] DEFAULT (getdate()) NOT NULL,
    [Suppliers] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_HotelAPI_User] PRIMARY KEY CLUSTERED ([Id] ASC)
);

