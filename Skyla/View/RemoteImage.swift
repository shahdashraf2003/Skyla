//
//  RemoteImage.swift
//  Skyla
//
//  Created by Shahudaa on 27/05/2026.
//

import SwiftUI
import Kingfisher

struct RemoteImage: View {

	let url: URL?

	var body: some View {

		KFImage(url)

			.placeholder {

				Image(.weather).resizable()
			}

			.retry(maxCount: 3, interval: .seconds(2))
			.fade(duration: 0.25)
			.downsampling(size: CGSize(width: 120, height: 120))
			.cacheOriginalImage()
			.resizable()
			.scaledToFit()
	}
}
