
/* ====================================================
Kinect Recording Project
Author: Hamed Monkaresi (Hamed.Monkaresi@Sydney.edu.au)
Date: 28-09-2011
Comments:
	win32 Console application
	It works on http protocol.
	The command structre example: 
		argv[1]= "cam:\\option[start]dir[c:\test]"

======================================================*/

//#define _WIN32_WINNT 0x0500
//#include <Windows.h>

#include "stdafx.h"
#include <time.h>
#include <string>
#include <iostream>
#include "cv.h"
#include "highgui.h"

#include <CLNUIDevice.h>


using namespace std;


//--------------------------------------------------------
// URL Decodi/Encode Functions from : 
// www.geekhideout.com/urlcode.shtml
//--------------------------------------------------------
// Converts a hex character to its integer value 
char from_hex(char ch) {
  return isdigit(ch) ? ch - '0' : tolower(ch) - 'a' + 10;
}

/* Converts an integer value to its hex character*/
char to_hex(char code) {
  static char hex[] = "0123456789abcdef";
  return hex[code & 15];
}

/* Returns a url-encoded version of str */
/* IMPORTANT: be sure to free() the returned string after use */
char *url_encode(char *str) {
  char *pstr = str, *buf = (char*) malloc(strlen(str) * 3 + 1), *pbuf = buf;
  while (*pstr) {
    if (isalnum(*pstr) || *pstr == '-' || *pstr == '_' || *pstr == '.' || *pstr == '~') 
      *pbuf++ = *pstr;
    else if (*pstr == ' ') 
      *pbuf++ = '+';
    else 
      *pbuf++ = '%', *pbuf++ = to_hex(*pstr >> 4), *pbuf++ = to_hex(*pstr & 15);
    pstr++;
  }
  *pbuf = '\0';
  return buf;
}

/* Returns a url-decoded version of str */
/* IMPORTANT: be sure to free() the returned string after use */
char * url_decode(char *str) {
  char *pstr = str, *buf;
  buf= (char*)malloc(strlen(str) + 1);
  char *pbuf = buf;
  while (*pstr) {
    if (*pstr == '%') {
      if (pstr[1] && pstr[2]) {
        *pbuf++ = from_hex(pstr[1]) << 4 | from_hex(pstr[2]);
        pstr += 2;
      }
    } else if (*pstr == '+') { 
      *pbuf++ = ' ';
    } else {
      *pbuf++ = *pstr;
    }
    pstr++;
  }
  *pbuf = '\0';
  return buf;
}


//-------------------------------------------------------


int main(int argc, char** argv  )
{

	// Hide Console Window
	HWND hWnd = GetConsoleWindow();
    ShowWindow( hWnd, SW_HIDE );
	
	int recFPS;
	int waitKey;   // in milisecond 
	// Init time and Output Video fileName
	time_t rawtime;
	struct tm * timeinfo;
	char fileName [80] ;
	string videoFileAddString;
	string depthFileAddString;
	string flagFileAddStr;
	time ( &rawtime );
	timeinfo = localtime ( &rawtime );
	strftime (fileName,80,"%d-%m-%Y_%H-%M-%S_Video.avi",timeinfo);
	string VideoFileNameString(fileName);
	strftime (fileName,80,"%d-%m-%Y_%H-%M-%S_Depth.avi",timeinfo);
	string DepthFileNameString(fileName);
	string flagFileStr("FlagFile.txt");


try{	
	// Process Argv command -----------------------------------------------------------
	// The command structre example: argv[1]= "cam:\\option[start]dir[c:\test]"
	size_t optionIndex;
	size_t dirIndex;
	size_t l;
	int optionSize;
	int dirSize;
	char option[10];
	char outFolder[80];
	string optionStr="empty";

	if(argv[1] !=NULL){

		string commandStr=url_decode(argv[1]);
		optionIndex=commandStr.find("option[")+7;
		if(optionIndex==string::npos)
			throw 1;
		optionSize=commandStr.find("]dir[")-optionIndex;
		dirIndex=commandStr.find("dir[")+4;
		if(dirIndex==string::npos)
			throw 1;
		dirSize=commandStr.find("]",dirIndex+1)-dirIndex;
		l=commandStr.copy(option,optionSize,optionIndex);
		option[l]='\0';
		optionStr=string(option);
		l=commandStr.copy(outFolder,dirSize,dirIndex);
		outFolder[l]='\0';

		// Create Output files Addrese
		string folderString(outFolder);
		videoFileAddString=folderString+VideoFileNameString;
		flagFileAddStr=folderString+flagFileStr;
	}
	else{
		videoFileAddString=VideoFileNameString;
		depthFileAddString=DepthFileNameString;
		flagFileAddStr=flagFileStr;

	}
	// videoFileAdd  and depthFileAdd
	char videoFileAdd [150];
    strcpy_s(videoFileAdd, videoFileAddString.c_str());
	char depthFileAdd [150];
    strcpy_s(depthFileAdd, depthFileAddString.c_str());
	char flagFileAdd[150];
	strcpy_s(flagFileAdd, flagFileAddStr.c_str());
	//char *flagFileAdd="c:\\test\\flag2.txt";
	

	// --------------------------------------------------------------------
	// Stop Option  :------------------------------------------------------
	// --------------------------------------------------------------------
	if(optionStr.compare("stop")==0){
		FILE * myFile;
		myFile=fopen(flagFileAdd,"w");
		fprintf (myFile, "%s \n","0");
		fclose(myFile);
		return 0;
	}

	// --------------------------------------------------------------------
	// Start Option (Recording Rate):------------------------------------------------------
	// --------------------------------------------------------------------
	if(optionStr.compare("empty")==0)
		recFPS=15;
	else if(optionStr.compare("start")==0){
		recFPS=15;
		waitKey=67;
	}
	else if(optionStr.compare("start30")==0){
		recFPS=30;
		waitKey=33;
	}
	else if(optionStr.compare("start15")==0){
		recFPS=15;
		waitKey=67;
	}
	else if(optionStr.compare("startCodec")==0){
		recFPS=30;
		waitKey=33;
	}
	else
		throw 1;

	//Creat flag File	
	FILE * myFile;
	int c;
	myFile=fopen(flagFileAdd,"r");
	if(myFile!=NULL){
		c =  fgetc (myFile);
		if (c == '1') return 0;
		fclose(myFile);
	}
	
	// Caption font
	CvFont font;
	cvInitFont(&font, CV_FONT_HERSHEY_SIMPLEX, 0.6, 0.6, 0.5, 1, 8);
	char caption[50];

	//------------------------------------------------------------ Init Kinect
	// -----------------------------------------------------------------------
    PBYTE rgb24_data = (PBYTE) malloc(640*480*3);
	PDWORD depth32_data = (PDWORD) malloc(640*480*4);
    //CLNUICamera cam = CreateNUICamera(GetNUIDeviceSerial(0));
    //CLNUIMotor motor = CreateNUIMotor(GetNUIDeviceSerial(0));
	CLNUICamera cam = CreateNUICamera();
	CLNUIMotor motor = CreateNUIMotor();
    StartNUICamera(cam);
	   
	IplImage *frame = cvCreateImageHeader(cvSize(640, 480), 8, 3);
	IplImage *depth24Frame;
    IplImage *depth32Frame = cvCreateImageHeader(cvSize(640, 480), 8, 4);
	// -----------------------------------------------------------------------
	// -----------------------------------------------------------------------

	IplImage* showFrame;
	showFrame = cvCreateImage(cvSize(160,120),frame->depth,frame->nChannels);

	RECT rc;
    GetWindowRect(GetDesktopWindow(), &rc);
	rc.bottom;
	// Always check 
	if (!frame)
	{
		printf("Cannot retrieve frame from camera!");
		return 1;
	}
	
	//Write in flag file

	myFile=fopen(flagFileAdd,"w");
	if (myFile==NULL)
	{
		throw 2;
	}
	fprintf (myFile, "%s \n","1");
	fclose(myFile);
	CvVideoWriter* writer1;
	CvVideoWriter* writer2;

	// Select Codec by User or not! 
	if(optionStr.compare("startCodec")==0){
		writer1 = cvCreateVideoWriter(videoFileAdd,-1,recFPS,cvGetSize(frame),1 ); 
		writer2 = cvCreateVideoWriter(depthFileAdd,-1,recFPS,cvGetSize(frame),1 ); 
	}

	else{
		
		// Create video writer for Video
		writer1 = cvCreateVideoWriter(videoFileAdd,
		CV_FOURCC('M','P','4','2'),
		//CV_FOURCC('X','V','I','D'),
		recFPS,cvGetSize(frame), 1 );

		// Create video writer for Depth 
		writer2 = cvCreateVideoWriter(depthFileAdd,
		CV_FOURCC('M','P','4','2'),
		//CV_FOURCC('X','V','I','D'),
		//-1,
		recFPS,cvGetSize(frame), 1 );
	}
	

	// Always check 
	if (!writer1)
	{
		myFile=fopen(flagFileAdd,"w");
		fprintf (myFile, "%s \n","0");
		fclose(myFile);
		printf("Cannot create video writer!");
		return 1;
	}

	// Init show window
	cvNamedWindow("video",CV_WINDOW_AUTOSIZE);
	cvMoveWindow( "video", rc.right-180, rc.bottom-190 );
	//cvResizeWindow( "video", 320, 240);

	// ---------------------------------------------- Main Loop
	// --------------------------------------------------------
	myFile=fopen(flagFileAdd,"r");
	while(1)
	{
		c =  fgetc (myFile);
		if (c != '1') break;
		rewind (myFile);

		// ----------------------------------------------------- Get images from Kinect
		// ----------------------------------------------------------------------------
		// Get next frame
		GetNUICameraColorFrameRGB24(cam, rgb24_data);
        GetNUICameraDepthFrameRGB32(cam, depth32_data);
		
        frame = cvCreateImageHeader(cvSize(640,480), 8, 3);
		depth32Frame = cvCreateImageHeader(cvSize(640, 480), 8, 4);
		depth24Frame=cvCreateImage(cvSize(640, 480), 8, 3);

		cvSetData(frame, rgb24_data, frame->widthStep);
		cvSetData(depth32Frame, depth32_data, depth32Frame->widthStep);
		// covert to RGB24
        cvCvtColor(depth32Frame, depth24Frame, CV_RGBA2RGB);
		// ---------------------------------------------------------------------------
		// ----------------------------------------------------------------------------

		// Print time on frames
		time ( &rawtime );
		//cvPutText(frame, ctime (&rawtime) , cvPoint(10, 20), &font, cvScalar(255, 255, 255));
		timeinfo = localtime ( &rawtime );
		strftime (caption,50,"%d-%m-%Y  %H:%M:%S",timeinfo);
		cvPutText(frame, caption , cvPoint(10, 35), &font, cvScalar(255, 255, 255));
		cvPutText(depth24Frame, caption , cvPoint(10, 35), &font, cvScalar(255, 255, 255));
		
		// Always check 
		if (!frame)
			break;

		// Also display the video 
		cvResize(frame, showFrame);
		cvShowImage("video", showFrame);
		
		// ----------------------------------------------------------- Save to file 
		// Video
		cvWriteFrame(writer1, frame);
		// Depth
		cvWriteFrame(writer2, depth24Frame);
		// ------------------------------------------------------------------------
		// Exit if user press ESC 
		if (cvWaitKey(1) == 27)
			break;
		cvReleaseImageHeader(&frame);
        cvReleaseImage(&depth24Frame);
        cvReleaseImageHeader(&depth32Frame);
	}

	fclose(myFile);
	myFile=fopen(flagFileAdd,"w");
	fprintf (myFile, "%s \n","0");
	fclose(myFile);
	// Be tidy 
	cvDestroyAllWindows();
	cvReleaseVideoWriter(&writer1);
	cvReleaseVideoWriter(&writer2);
	// ------------------------------------------------- Free Kinect
	free(rgb24_data);
    free(depth32_data);

    StopNUICamera(cam);
    DestroyNUIMotor(motor);
    DestroyNUICamera(cam);
	// -------------------------------------------------------------
	return 0;
	}
	catch(int e){
		if(e==1){
			cout<<argv[1]<<" Unknown command !";
		}
		if( e==2){
			cout<<argv[1]<<"couldn not open flag file";
		}
		cout<<argv[1];
		return 0;
	}
}

