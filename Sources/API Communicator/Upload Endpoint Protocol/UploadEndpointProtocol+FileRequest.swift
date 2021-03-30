//
//  UploadEndpointProtocol+FileRequest.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import Foundation

/// Upload file request struct to hold the upload data.
public struct UploadFileRequest{
    
    /// File data object
    public let data: Data
    
    /// Parameter used for $_FILE (e.g. $_FILE['profile_photo'], 'profile_photo' is the key)
    public let parameterkey: String
    
    /// Name of the file being uploaded
    public let filename: String
    
    /// Mime type of the file being uploaded
    public let mimetype: String
    
    /// Initializing method with string mimetype
    public init(data: Data, parameterkey: String, filename: String, mimetype: String) {
        self.data = data
        self.parameterkey = parameterkey
        self.filename = filename
        self.mimetype = mimetype
    }
    
    /// Initializing method with enumerated mime type
    public init(data: Data, parameterkey: String, filename: String, uploadmimetype: UploadMimeType) {
        self.init(data: data, parameterkey: parameterkey, filename: filename, mimetype: uploadmimetype.rawValue)
    }
}

public enum UploadMimeType: String{
    case image_jpeg = "image/jpeg"
    case image_png = "image/png"
    
    // MARK: Additional mimetypes here
}
