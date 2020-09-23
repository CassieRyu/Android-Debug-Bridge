# Android Debug Bridge Usages

## Install / Uninstall
* reference: https://developer.android.com/studio/command-line/adb?hl=zh-cn

`$ adb devices -l`	list connected/launched devices list

`$ adb -s emulator-5555 install helloWorld.apk`	install apk   -s(&ANDROID_SERIAL) 

`$ adb -s emulator-5554 shell pm list package`		list all app packages on specific device

`$ adb -s emulator-5554 uninstall com.example.demo1`	uninstall app


## Startup Time Behavior
* Reference: https://www.cnblogs.com/suim1218/p/9365470.html

### cold start - no background running app

`$ adb logcat | grep START`	find package name and the app’s main activity

`$ adb shell am force-stop com.example.demo1`		stop app

`$ adb shell am start -W com.example.demo1/.MainActivity`   start app

`$ adb shell am start -W -S -R $count com.example.demo1/.MainActivity` 
combine above two commands, start app with $count times
 
 <img src="https://github.com/CassieRyu/Android-Debug-Bridge/blob/master/Picture1.png">

* Metrics(COLD): Total Time <= 2s
### Warm start - start app with backgound app running
`$ adb shell input keyevent 3`			press 'home' button

`$ adb shell am start -W com.example.demo1/.MainActivity`			start app

<img src="https://github.com/CassieRyu/Android-Debug-Bridge/blob/master/Picture2.png">

Metrics: total time <= 0.5s

Notes: write a shell scripts, to start multi times and get the average launch time;

## FPS (frame per sec)

In emulator: open Dev Tools -> Developer options -> Profile GPU rendenring -> In adb shell dumpsys gfxinfo

`$ adb shell dumpsys gfxinfo com.example.demo1`	get frame rendering performance from app start till now

Metrics: Janky frames rate <= 40%

<img src="https://github.com/CassieRyu/Android-Debug-Bridge/blob/master/Picture3.png">

Notes: require massive pages rendering would get more reliable values.

## Memory Stats
* reference: https://developer.android.com/studio/command-line/dumpsys?hl=zh-cn#ViewingAllocations
https://www.cnblogs.com/csj2018/p/9917142.html

Metics: (able to use CPU profiler tool)
1.	Foreground Memory Utilization <=500MB
2.	Background with Screen Bright Memory Utilization <=400MB (after background for 5 minites)
3.	Background with Screen Off Memory Utilization <= 400MB (after screen off for 1 minite)

`$ adb shell dumpsys meminfo com.example.demo1`				list current memory status
<img src="https://github.com/CassieRyu/Android-Debug-Bridge/blob/master/Picture4.png">

Notes: 
1.	The first two rows(Native and Dalvik Heap) are important, they’re memory of JNI and Java, if keep growth, might be memory leakage.
2.	Total Pss is the actual memory usage
3.	Write shell scripts to get memory status at specific TTL, and save to result file.

## CPU Stats
* use Android Studio CPU profiler tool, https://developer.android.com/studio/profile/cpu-profiler?hl=zh-cn#overview

Check app CPU utilization in Idle, Medium use, High use, make sure not too high is alright.

Metrics: 
1.	Background with Screen Bright CPU Utilization  <= 2% (after background for 5 minites)
2.	Background with Screen Off CPU Utilization <= 2% (after screen off for 5 minites)

<img src="https://github.com/CassieRyu/Android-Debug-Bridge/blob/master/Picture5.png">

## Monkey Test
* Reference: https://developer.android.com/studio/test/monkey?hl=zh-cn

```$ adb shell monkey -v --throttle 300 --pct-touch 30 --pct-motion 20 --pct-nav 20 --pct-majornav 15 --pct-appswitch 5 --pct-anyevent 5 --pct-trackball 0 --pct-syskeys 0 -p com.example.demo1 5000 > monkey.log```

Metrics: 
* Crash <= 1 per hr
* ANR <= 1 per hr

Analyze crash or ANR issue: 
1.	result monkey.log 
 *	search "ANR" in result log to check if encounter ANR issue;
 *	search “Exception” in result log to check if any error happens; (if found "NullPointerException" means there's bug)
2.	system log analyse; 
3.	use screen recorder to reproduce (reference: https://developer.android.com/studio/command-line/adb#screenrecord)



