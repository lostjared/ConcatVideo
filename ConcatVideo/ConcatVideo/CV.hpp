
#ifndef __CV__H__HPP__
#define __CV__H__HPP__

#include<opencv2/videoio.hpp>
#include<opencv2/imgproc.hpp>
#include<opencv2/highgui.hpp>
#include<iostream>
#include<string>
#include<vector>

cv::Mat resizeKeepAspectRatio(const cv::Mat &input, const cv::Size &dstSize, const cv::Scalar &bgcolor);

// Resize X variable
inline int AC_GetFX(int oldw,int x, int nw) {
    float xp = (float)x * (float)oldw / (float)nw;
    return (int)xp;
}
// Resize Y Variable
inline int AC_GetFZ(int oldh, int y, int nh) {
    float yp = (float)y * (float)oldh / (float)nh;
    return (int)yp;
}


class AC_VideoCapture {
public:
    AC_VideoCapture() = default;
    
    bool openVideo() {
        capture.open(name);
        if(capture.isOpened())
            return true;
        return false;
    }
    
    void setVideo(std::string filename) {
        name = filename;
    }
    
    bool getFrame(cv::Mat &frame) {
        return capture.read(frame);
    }
    
    cv::VideoCapture capture;
    std::string name;
};

enum class AddType { AT_ADD, AT_ADD_SCALE, AT_XOR, AT_AND, AT_OR };
extern std::vector<AC_VideoCapture *> video_files;
extern AddType add_type;
#endif
