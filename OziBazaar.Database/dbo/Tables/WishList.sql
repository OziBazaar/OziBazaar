CREATE TABLE [dbo].[WishList](
	[WishListID] [int] IDENTITY(1,1) NOT NULL,
	[AdvertizementID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_WishList] PRIMARY KEY CLUSTERED 
(
	[WishListID] ASC
)
)


GO
ALTER TABLE [dbo].[WishList]  WITH CHECK ADD  CONSTRAINT [FK_WishList_Advertisement] FOREIGN KEY([AdvertizementID])
REFERENCES [dbo].[Advertisement] ([AdvertisementID])
GO

ALTER TABLE [dbo].[WishList] CHECK CONSTRAINT [FK_WishList_Advertisement]