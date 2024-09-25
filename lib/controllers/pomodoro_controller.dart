import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PomodoroController extends GetxController {
  // Default times in seconds (25 mins for Pomodoro, 5 for Short Break, 15 for Long Break)
  RxInt pomodoroTime = 1500.obs; // Default: 25 minutes (1500 seconds)
  RxInt shortBreakTime = 300.obs; // Default: 5 minutes (300 seconds)
  RxInt longBreakTime = 900.obs; // Default: 15 minutes (900 seconds)

  RxInt timeInSeconds =
      1500.obs; // The actual timer value, initialized with pomodoroTime
  RxString currentMode =
      "pomodoro".obs; // Current mode: pomodoro, short break, long break
  RxBool isRunning = false.obs;
  late RxString formattedTime;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
    formattedTime = _formatTime(timeInSeconds.value).obs;
  }

  void startTimer() {
    if (isRunning.value)
      return; // Prevent starting the timer again if already running
    isRunning.value = true;
    _runTimer();
  }

  void pauseTimer() {
    isRunning.value = false; // Stop the timer but allow it to resume
  }

  void resetTimer() {
    timeInSeconds.value = getInitialTime(currentMode.value);
    formattedTime.value = _formatTime(timeInSeconds.value);
    stopTimer(); // Resets also stop the timer
  }

  void stopTimer() {
    isRunning.value = false;
  }

  void _runTimer() {
    if (isRunning.value) {
      Future.delayed(Duration(seconds: 1), () {
        if (timeInSeconds.value > 0) {
          // Decrement the timer
          timeInSeconds.value--;
          formattedTime.value = _formatTime(timeInSeconds.value);

          // Recursively call _runTimer to keep the timer running
          _runTimer();
        } else {
          // Timer reached zero, stop the timer and play sound
          stopTimer();
          _playAlertSound();

          // Show popup after the timer ends
          Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Color(0xFF3FA2F6),
              contentPadding: const EdgeInsets.all(20),
              title: Text(
                "Time's Up!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your session has ended. Would you like to stop the sound?",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background tombol putih
                      foregroundColor: Color(0xFF3FA2F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    child: Text(
                      "Stop Sound",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      stopAlertSound(); // Stop the sound
                      Get.back(); // Close the popup
                    },
                  ),
                ],
              ),
            ),
            barrierDismissible: false, // Prevent dismiss by clicking outside
          );

          // Auto-switch to short break when Pomodoro ends
          if (currentMode.value == "pomodoro") {
            changeMode("short break");
          }
        }
      });
    }
  }

  void changeMode(String mode) {
    currentMode.value = mode;
    resetTimer(); // Resets the timer when mode changes
  }

  void stopAlertSound() async {
    await _audioPlayer.stop();
  }

  // This method fetches the initial time based on the current mode
  int getInitialTime(String mode) {
    if (mode == "pomodoro") {
      return pomodoroTime.value; // Use the customizable Pomodoro time
    } else if (mode == "short break") {
      return shortBreakTime.value; // Use the customizable Short Break time
    } else {
      return longBreakTime.value; // Use the customizable Long Break time
    }
  }

  // This method formats the time as MM:SS for the UI
  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Method to play the alert sound when time is up
  void _playAlertSound() async {
    await _audioPlayer.play(AssetSource('alert.mp3'));
  }

  // Method to update Pomodoro time from the settings page
  void updatePomodoroTime(int minutes) {
    pomodoroTime.value = minutes * 60; // Convert minutes to seconds
    if (currentMode.value == "pomodoro") {
      resetTimer(); // Reset the timer if the mode is Pomodoro
    }
  }

  // Method to update Short Break time from the settings page
  void updateShortBreakTime(int minutes) {
    shortBreakTime.value = minutes * 60; // Convert minutes to seconds
    if (currentMode.value == "short break") {
      resetTimer(); // Reset the timer if the mode is Short Break
    }
  }

  // Method to update Long Break time from the settings page
  void updateLongBreakTime(int minutes) {
    longBreakTime.value = minutes * 60; // Convert minutes to seconds
    if (currentMode.value == "long break") {
      resetTimer(); // Reset the timer if the mode is Long Break
    }
  }
}
