CREATE TABLE [dbo].[Advertisement](
	[AdvertisementID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[Title] [nvarchar](200) NULL,
	[Price] [money] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[OwnerID] [int] NOT NULL,
	[IsActive] [bit] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Advertisement] PRIMARY KEY CLUSTERED 
(
	[AdvertisementID] ASC
)
)






GO
ALTER TABLE [dbo].[Advertisement] ADD  CONSTRAINT [DF_Advertisement_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Advertisement]  WITH CHECK ADD  CONSTRAINT [FK_Advertizement_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO

ALTER TABLE [dbo].[Advertisement] CHECK CONSTRAINT [FK_Advertizement_Product]