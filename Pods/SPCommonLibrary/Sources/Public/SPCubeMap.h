//
//  SPCubeMap.h
//  Alamofire
//
//  Created by 黄树鹏 on 2019/8/2.
//

#ifndef SPCubeMap_h
#define SPCubeMap_h

#include <stdio.h>
typedef struct CubeMap CubeMap;

struct CubeMap {
    int length;
    float dimension;
    float *data;
};

struct CubeMap createCubeMap(float minHueAngle, float maxHueAngle);
#endif /* SPCubeMap_h */
