package com.hs.houscore.dto;

import lombok.Data;

@Data
public class FileUploadDTO {
    private String imageName;
    private String type;
    private String imageBase64;
}