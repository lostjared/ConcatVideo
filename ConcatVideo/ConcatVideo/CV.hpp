/*
 
 Written by Jared Bruni - http://github.com/lostjared
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
 
*/


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

extern std::vector<AC_VideoCapture *> video_files;

#endif
