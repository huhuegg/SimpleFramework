//
//  SimpleKeyframeAnimation.swift
//  SimpleFramework
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit

class SimpleKeyframeAnimation: CAKeyframeAnimation {
    class func tabBarAnimation()->CAKeyframeAnimation {
        //需要实现的帧动画,这里根据需求自定义
        let animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1, 1.3, 0.9, 1.15, 0.95, 1.02, 1]
        animation.duration = 1
        /*
         kCAAnimationLinear calculationMode的默认值,表示当关键帧为座标点的时候,关键帧之间直接直线相连进行插值计算;
         kCAAnimationDiscrete 离散的,就是不进行插值计算,所有关键帧直接逐个进行显示;
         kCAAnimationPaced 使得动画均匀进行,而不是按keyTimes设置的或者按关键帧平分时间,此时keyTimes和timingFunctions无效;
         kCAAnimationCubic 对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算,对于曲线的形状还可以通过tensionValues,continuityValues,biasValues来进行调整自定义,这里的主要目的是使得运行的轨迹变得圆滑;
         kCAAnimationCubicPaced 看这个名字就知道和kCAAnimationCubic有一定联系,其实就是在kCAAnimationCubic的基础上使得动画运行变得均匀,就是系统时间内运动的距离相同,此时keyTimes以及timingFunctions也是无效的.
         */
        animation.calculationMode = kCAAnimationCubic
        
        return animation
    }
}
