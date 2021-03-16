-- Create FlagTypes Entry
		IF NOT EXISTS (
					SELECT *
					FROM FlagTypes
					WHERE FlagType = 'Treatment Plan Due'
						AND Active = 'Y'
					)
			BEGIN
				INSERT INTO FlagTypes (
					FlagType
					,Active
					,PermissionedFlag
					,DoNotDisplayFlag
					,NeverPopup
					,SortOrder
					,Bitmap
					,BitmapImage
					,Comments
					,DefaultWorkGroup
					,FlagLinkTo
					,DocumentCodeId
					,ActionId
					)
				VALUES (
					'Treatment Plan Due'
					,'Y'
					,'N'
					,'N'
					,'Y'
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					)
			END