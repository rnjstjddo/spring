package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component //인스턴스 생성
public class FileCheckTask {

//	@Scheduled(cron="0 * * * * *")
//	public void checkFiles() throws Exception{
//		
//		log.warn("파일체크테스크 동작");
//		log.warn("==================================");
//			
//	}
	
	
	@Setter(onMethod_ =@Autowired)
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		
		SimpleDateFormat sdf =new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance(); //오늘날짜
		//cal.add(Calendar.DATE, -1); //SQL문에서 sysdate -1 했기에 해당코드는 삭제.
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
		
	}
	
	@Scheduled(cron="0 0 2 * * *")
	public void checkFiles() throws Exception{
		
		log.warn("파일체크태스크 동작");
		log.warn(new Date());
		
		List<BoardAttachVO> fileList =attachMapper.getOldFiles();
		
		
		//DB와 폴더의 파일체크를 시작한다.
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid()+"_"+vo.getFileName()))
				.collect(Collectors.toList());
		
		//이미지파일은 섬네일 파일도 가진다.
		fileList.stream().filter(vo -> vo.isFileType() ==true)
			.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_"+vo.getUuid()+"_"+vo.getFileName()))
			.forEach(p->fileListPaths.add(p));	
		
		log.warn("=======================================");
		
		fileListPaths.forEach(p-> log.warn(p));
		
		//어제폴더에 들어있는 파일들
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		
		File [] removeFiles =targetDir.listFiles(file -> fileListPaths.contains(file.toPath())==false);
	
		log.warn("==========================================");

		
		for(File file : removeFiles) {
			
			log.warn(file.getAbsolutePath());
			file.delete();
		}
		
	}	
	
}
