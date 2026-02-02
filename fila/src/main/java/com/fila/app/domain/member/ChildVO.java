package com.fila.app.domain.member;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ChildVO {
	private String childName;
    private String childBirth; // YYYYMMDD 형식
    private String childGender;
}
