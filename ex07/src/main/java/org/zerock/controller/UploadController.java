package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	

	/*
	 * @GetMapping("/uploadForm") public void uploadForm() {
	 * log.info("upload form"); }
	 */
	/*
	 * @PostMapping("/uploadFormAction") public void uploadFormPost(MultipartFile[]
	 * uploadFile,Model model) {
	 * 
	 * String uploadFolder="C:\\upload";
	 * 
	 * for(MultipartFile multipartFile:uploadFile) { log.info("-----------------");
	 * log.info("업로드 파일 이름:"+multipartFile.getOriginalFilename());
	 * log.info("업로드 파일 크기:"+multipartFile.getSize());
	 * 
	 * File saveFile=new File(uploadFolder,multipartFile.getOriginalFilename());
	 * //파일쓰기 //앞 파일경로, 파일이름 try { multipartFile.transferTo(saveFile);
	 * }catch(Exception e) { log.error(e.getMessage()); } } }
	 */



	@GetMapping("/uploadAjax") public void upload() {
		log.info("업로드 Ajax");
	}

//	@PostMapping("/uploadAjaxAction")
//	public void uploadAjaxPost(MultipartFile[] uploadFile,Model model) {
//		log.info("Ajax 전송.....");
//		
//		String uploadFolder="C:\\upload";
//		
//		for(MultipartFile multipartFile:uploadFile) {
//			log.info("-----------------");
//			log.info("업로드 파일 이름:"+multipartFile.getOriginalFilename());
//			log.info("업로드 파일 크기:"+multipartFile.getSize());
//			
//			
//			//c:\\upload\\ 파일이름
//			File saveFile=new File(uploadFolder,multipartFile.getOriginalFilename());
//			try {
//				multipartFile.transferTo(saveFile);
//			}catch(Exception e) {
//				log.error(e.getMessage());
//			}
//		}
//	} //uploadAjaxAction PostMapping
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		String str = sdf.format(date);
		
		return str.replace("-", File.separator);
		
	}
	
//	@PostMapping("/uploadAjaxAction")
//	public void uploadAjaxPost(MultipartFile[] uploadFile) {
//		
//		String uploadFolder ="C:\\upload";
//		
//		File uploadPath = new File(uploadFolder, getFolder());
//		log.info("업로드 경로: "+ uploadPath);
//		
//		if(uploadPath.exists() ==false){
//			uploadPath.mkdirs(); //폴더경로만들기
//		}
//		
//		for(MultipartFile multipartFile : uploadFile) {
//			log.info("=========================================");
//			log.info("업로드파일이름: "+ multipartFile.getOriginalFilename());
//			log.info("업로드파일크기: "+ multipartFile.getSize());
//			
//			String uploadFileName = multipartFile.getOriginalFilename();
//			
//			//IE 브라우저파일 Path
//			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
//			
//			log.info("파일이름 : "+uploadFileName);
//			
//			UUID uuid = UUID.randomUUID();
//			uploadFileName =uuid.toString()+"_"+uploadFileName;
//			
//			File saveFile = new File(uploadPath, uploadFileName);
//			
//			try {
//				multipartFile.transferTo(saveFile);
//			}catch(Exception e) {
//				log.error(e.getMessage());	
//			} //catch문
//		} //for문
//	} //uploadAjaxAction PostMapping
	
	
//	@PostMapping("/uploadAjaxAction")
//	public void uploadAjaxPost(MultipartFile [] uploadFile) {
//		
//		String uploadFolder = "C:\\upload";
//		
//		File uploadPath = new File(uploadFolder, getFolder());
//		log.info("업로드 경로: "+ uploadPath);
//		
//		if(uploadPath.exists() == false) {
//			uploadPath.mkdirs();
//		}
//		
//		for(MultipartFile multipartFile : uploadFile) {
//			
//			log.info("======================================");
//			log.info("업로드 파일명: "+multipartFile.getOriginalFilename());
//			log.info("업로드 파일크기: "+ multipartFile.getSize());
//			
//			String uploadFileName =multipartFile.getOriginalFilename();
//			
//			uploadFileName =uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
//			
//			log.info("파일명: "+ uploadFileName);
//			
//			UUID uuid = UUID.randomUUID();
//			
//			uploadFileName = uuid.toString()+"_"+uploadFileName;
//			
//			try {
//				File saveFile = new File(uploadPath, uploadFileName);
//				multipartFile.transferTo(saveFile);
//				
//				if(checkImageType(saveFile)) {
//					FileOutputStream thumbnail = new FileOutputStream
//							(new File(uploadPath, "s"+uploadFileName));
//					
//					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
//					thumbnail.close();
//				}
//			}catch(Exception e) {
//				e.printStackTrace();
//			}//catch문
//		}//for문
//	
//	}
	
	private boolean checkImageType(File file) {
		try {
			String contentType =Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		}catch(IOException e) {
			e.printStackTrace();	
		}
		return false;
	}
	
	//서버쪽에서도 어노테이션을 이용해서 업로드시 보안확인
	@PreAuthorize("isAuthenticated()")		
	@PostMapping(value="/uploadAjaxAction",
			produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile, Model model) {
		//register.jsp 자바스크립트의 uploadFile 배열로 받아온다.
		log.info("Ajax 전송.....");
		
		List<AttachFileDTO> list=new ArrayList<>();
		String uploadFolder="C:\\upload";
		
		//폴더 경로 만들기
		String uploadFolderPath=getFolder();
		File uploadPath=new File(uploadFolder,uploadFolderPath);
		
		log.info("upload path:"+uploadPath);
		
		if(uploadPath.exists()==false) {
			uploadPath.mkdirs();	//폴더 생성
		}
		
		for(MultipartFile multipartFile:uploadFile) {
			AttachFileDTO attachDTO=new AttachFileDTO();
			
			log.info("-----------------");
			log.info("업로드 파일 이름:"+multipartFile.getOriginalFilename());
			log.info("업로드 파일 크기:"+multipartFile.getSize());
			
			String uploadFileName=multipartFile.getOriginalFilename();
			log.info("crome과 IE file name 비교:"+uploadFileName);
			
			//IE 브라우저 파일 path
			uploadFileName=uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
			log.info("only file name:"+uploadFileName);
			
			attachDTO.setFileName(uploadFileName);
			
			UUID uuid=UUID.randomUUID();
			
			uploadFileName=uuid.toString()+"_"+uploadFileName;
			
//			File saveFile=new File(uploadFolder,multipartFile.getOriginalFilename());
			File saveFile=new File(uploadPath,uploadFileName);
			try {
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					
					FileOutputStream thumbnail=new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail,100,100);
					
					thumbnail.close();
				}
				list.add(attachDTO);
				
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
		return new ResponseEntity<>(list,HttpStatus.OK);
	}
	
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		//문자열로 파일의 경로로 포함된 fileName을 파라미터로 받는다. byte[] 전송.
		log.info("파일명 : "+fileName); //날짜폴더 제외한 파일명
		
		File file = new File("c:\\upload\\"+fileName);
		
		log.info("파일: "+file);
		ResponseEntity<byte []> result =null;
		try {
			HttpHeaders header = new HttpHeaders();
			
			header.add("Content-Type", Files.probeContentType(file.toPath()));//이미지여부판별
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),
					//이미지를 찾아서 바이트로 이미지파일전송.
					header, HttpStatus.OK);
		}catch(IOException e) {
			e.printStackTrace();
		}
		return result;
	} //@GetMappling("/display")
	
	
//	@GetMapping(value="/download", produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
//	@ResponseBody
//	public ResponseEntity<Resource> downloadFile(String fileName){
//		log.info("다운로드 파일 :"+  fileName);
//		
//		Resource resource = new FileSystemResource("c:\\upload\\"+ fileName);
//		log.info("리소스 :"+ resource);
//
//		String resourceName = resource.getFilename();
//		
//		HttpHeaders headers = new HttpHeaders();
//		try {
//			headers.add("Content-Disposition", "attachment; filename="
//					+new String(resourceName.getBytes("UTF-8"),"ISO-8859-1"));
//		}catch(UnsupportedEncodingException e) {
//			e.printStackTrace();
//			
//		}
//		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
//	}
	
	
	@GetMapping(value="/download", produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		Resource resource = new FileSystemResource("c:\\upload\\"+fileName);
		
		if(resource.exists() ==false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);		
		}
		
		String resourceName = resource.getFilename();
		//UUID 제거
		String resourceOriginalName = resourceName.substring(resourceName.lastIndexOf("_")+1);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName =null;
			if(userAgent.contains("Trident")) {
				
				log.info("IE 브라우저");
				
				downloadName = URLEncoder.encode(resourceName,"UTF-8").replaceAll("\\+", "");
			}else if(userAgent.contains("Edge")) {
				
				log.info("Edge 브라우저");
				downloadName =URLEncoder.encode(resourceName, "UTF-8");
				log.info("Edge명 : "+downloadName);
			}else {
				log.info("크롬브라우저");
				downloadName =new String(resourceName.getBytes("UTF-8"), "ISO-8859-1");
			}
				log.info("다운로드명: "+ downloadName);
				headers.add("Content-Disposition", "attachment; filename"+ downloadName);
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		
		
		log.info("삭제파일: "+ fileName);
		File file;
		
		try {
			file = new File("c:\\upload\\"+URLDecoder.decode(fileName,"UTF-8"));
			
			file.delete();
			
			if(type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("대용량파일명: "+largeFileName);
				
				file = new File(largeFileName);
				file.delete();
									
			}
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
	
	
	
	
	
	
	
	
	
}
