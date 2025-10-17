CREATE TABLE [dbo].[Hotel_Image_List_Master] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkHotelListId] BIGINT         NULL,
    [Image]         NVARCHAR (MAX) NULL,
    [CreateDate]    DATETIME       CONSTRAINT [DF_Hotel_Image_List_Master_CreateDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Hotel_Image_List_Master] PRIMARY KEY CLUSTERED ([Id] ASC)
);

