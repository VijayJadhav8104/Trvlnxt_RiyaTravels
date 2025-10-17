CREATE TABLE [dbo].[Hotel_Profile_Matser] (
    [ProfileId]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProfileName] NVARCHAR (50) NULL,
    [Currency]    VARCHAR (20)  NULL,
    CONSTRAINT [PK_HotelDiscount] PRIMARY KEY CLUSTERED ([ProfileId] ASC)
);

