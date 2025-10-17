CREATE TABLE [Hotel].[HotelBookingModifyDetails] (
    [id]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [book_fk_id]     INT            NULL,
    [room_fk_id]     INT            NULL,
    [pax_fk_id]      INT            NULL,
    [Title]          NCHAR (10)     NULL,
    [FName]          VARCHAR (500)  NULL,
    [LName]          VARCHAR (500)  NULL,
    [RoomType]       VARCHAR (500)  NULL,
    [RoomMealBasis]  VARCHAR (500)  NULL,
    [IsActive]       INT            NULL,
    [ModifiedBy]     INT            NULL,
    [ModifiedByName] VARCHAR (500)  NULL,
    [ModifiedOn]     DATETIME       CONSTRAINT [DF__HotelBook__Modif__2EDEEF04] DEFAULT (getdate()) NULL,
    [IsLeadPax]      BIT            NULL,
    [RoomInclusion]  NVARCHAR (700) NULL,
    CONSTRAINT [PK__HotelBoo__3213E83F7CD79EE2] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-composit_Index]
    ON [Hotel].[HotelBookingModifyDetails]([book_fk_id] ASC, [room_fk_id] ASC, [pax_fk_id] ASC, [IsActive] ASC, [IsLeadPax] ASC)
    INCLUDE([id]) WITH (FILLFACTOR = 90);

