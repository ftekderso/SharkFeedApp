//
//  Constants.h
//  Sharkfeed
//
//  Created by Fikirte  Derso on 2/6/18.
//  Copyright © 2018 Fikirte  Derso. All rights reserved.
//


//URL FOR PHOTO AND INFO
#define SEARCH_PHOTOS_URL @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=949e98778755d1982f537d56236bbb42&text=shark&format=json&nojsoncallback=1&page=1&extras=url_t,url_c,url_l,url_o"

#define GET_PHOTO_URL @"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=949e98778755d1982f537d56236bbb42&"


//URL Parameter Keys
#define PHOTO_ID_KEY @"photo_id="
#define FORMAT_KEY @"&format="
#define CALLBACK_KEY @"&nojsoncallback="

//URL parameter values
#define FORMAT_VALUE @"json"
#define CALLBACK_VALUE @"1"


//Alert Message keys
#define PHOTO_SAVE_SUCESS_MESSAGE @"Photo has been saved to library"
#define PHOTO_SAVE_FAILED_MESSAGE @"Failed to save photo to library"
#define PHOTO_SAVE_TITLE @"Save Photo"





