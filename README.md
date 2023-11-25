# Task Project
it allows you to store different task with its description.

it provide following features:-
* Add New task and description with open status.
* Delete task which is created by mistake.
* Update faulty information in task.
* Once task is done you check-mark as done.
* Filter only open task to see what needs to done.

## Getting Started
You can install flutter by referring following link.
* https://docs.flutter.dev/get-started/install

To start this project on localhost. do as following:
1. Clone the project on your local system.
2. Open command prompty at project location in your system.
3. Write following command.
    1. <code> PS> flutter pub get </code>
4. Run following commands to see emulators/devices.
    1. <code> PS> flutter devices </code>
    2. <code> PS> flutter emulators</code>
5. Let's start android emulator.
    1. <code> PS> flutter emulators --launch <emulator_name> </code>
6. Once you run emulator and ready, it will shown in list of devices.
<pre>
output:-
    Found 4 connected devices:
    sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    • Android 14 (API 34) (emulator)
    Windows (desktop)            • windows       • windows-x64    • Microsoft Windows [Version 10.0.22631.2715]
    Chrome (web)                 • chrome        • web-javascript • Google Chrome 119.0.6045.160
    Edge (web)                   • edge          • web-javascript • Microsoft Edge 119.0.2151.72
</pre>
7. To run application on particular device, you need to run following command:-
    1. <code> PS> flutter run -d <DEVICE_ID_OR_DEVICE_NAME> </code>
8. If you run app on android emulator or phone, you will see following screen:-

<center><img src="snapshots/android.main.png" width="200" /> <br>
figure 1: Android Main Screen of app.</center>

9. If you run app as Windows, you will see follwing screen:-

<center><img src="snapshots/windows.main.png" width="300" /> <br>
figure 2: Windows Main Screen of app.</center>

"" Note:- While building app for windows, please enable following options in your windows menu ""

<center><img src="snapshots/windows.dev.enabled.screen.png" width="400" /> <br>
figure 3: Windows Enable Developer Mode.</center>

10. Didn't explorer IOS/Web APP build yet. 
11. Now you are done with Setup.

""" Note: Setup doesn't include how to setup Android Emulator and Windows MSVC Library, Windows SDK. """

## App Screen-Shots According to Features.

### Add Task Screen
<center>
    <img src="snapshots/android.add.task.screen.png" width="300"><br>
    Figure 4: Add to Task Screen.
</center>

<p> it will accept Task name and description and also validating the response that it shouldn't empty. </p>

### View Task Screen
<center>
    <img src="snapshots/android.view.task.screen.png" width="300"><br>
    Figure 5: View Task Details Screen.
</center>


### Edit Task Screen
<center>
    <img src="snapshots/android.edit.task.screen.png" width="300"><br>
    Figure 6: Edit Task Details Screen.
</center>


### Delete Task Screen
<center>
    <img src="snapshots/android.delete.task.screen.png" width="300"><br>
    Figure 6: Delete Task Screen.
</center>
<p> You will see following pop-up when you tap on dust-bin button in list. </p>


### To finish Task Screen
<center>
    <img src="snapshots/android.done.task.screen.png" width="300"><br>
    Figure 6: to done the Task Screen.
</center>

<p> You will see following pop-up when you tap on check-mark button and it will open confirmation page. once you done the task you will see task with double check-mark like comment was read</p>

### Not Done Filter Task Screen
<center>
    <img src="snapshots/android.not.done.filter.task.screen.png" width="300"><br>
    Figure 6: to filter not done Task Screen.
</center>

<p> You can see Not Done filter is checked mark in bottom of screen. </p>