
/* 
IMPORTANT:
For this Project CLNUI Platform version 1.0.0.1121 was used. 
In order to run in win XP.
*/


#include "stdafx.h"

#include "cv.h"
#include "highgui.h"

#include <CLNUIDevice.h>
/*

using namespace std;

void displayKinectImage();

int _tmain(int argc, _TCHAR* argv[])
{
    displayKinectImage();
}

void displayKinectImage() {
    PDWORD rgb32_data = (PDWORD) malloc(640*480*4);
    PDWORD depth32_data = (PDWORD) malloc(640*480*4);

    //CLNUICamera cam = CreateNUICamera(GetNUIDeviceSerial(0));
    //CLNUIMotor motor = CreateNUIMotor(GetNUIDeviceSerial(0));
	CLNUICamera cam = CreateNUICamera();
	CLNUIMotor motor = CreateNUIMotor();

    StartNUICamera(cam);

    cvNamedWindow("Image", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("Depth", CV_WINDOW_AUTOSIZE);
    cvNamedWindow("Grey", CV_WINDOW_AUTOSIZE);

    IplImage *rgb32 = cvCreateImageHeader(cvSize(640, 480), 8, 4);
    IplImage *grey;
    IplImage *depth32 = cvCreateImageHeader(cvSize(640, 480), 8, 4);;

    do {
        GetNUICameraColorFrameRGB32(cam, rgb32_data);
        GetNUICameraDepthFrameRGB32(cam, depth32_data);

        rgb32 = cvCreateImageHeader(cvSize(640,480), 8, 4);
        grey = cvCreateImage(cvSize(640, 480), 8, 1);
        depth32 = cvCreateImageHeader(cvSize(640, 480), 8, 4);

        cvSetData(rgb32, rgb32_data, rgb32->widthStep);
        cvSetData(depth32, depth32_data, depth32->widthStep);

        // Convert RGB32 to greyscale
        cvCvtColor(depth32, grey, CV_RGB2GRAY);

        cvShowImage("Image", rgb32);
        cvShowImage("Grey", grey);
        cvShowImage("Depth", depth32);

        cvReleaseImageHeader(&rgb32);
        cvReleaseImage(&grey);
        cvReleaseImageHeader(&depth32);

        cvWaitKey(1);

    } while (!GetAsyncKeyState(0x50));


    free(rgb32_data);
    free(depth32_data);

    StopNUICamera(cam);
    DestroyNUIMotor(motor);
    DestroyNUICamera(cam);

} 

*/