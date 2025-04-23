import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:taskhub/dashboard/dashboard_screen.dart';
import 'package:taskhub/dashboard/profile/profile_screen.dart';
import 'package:taskhub/dashboard/tasks/tasks_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 2; // Timer tab is index 2
  bool _isStopwatchRunning = false;
  bool _isCountdownRunning = false;
  Duration _stopwatchElapsed = Duration.zero;
  Duration _countdownDuration = const Duration(minutes: 25);
  Duration _countdownRemaining = const Duration(minutes: 25);
  late AnimationController _animationController;
  final Stopwatch _stopwatch = Stopwatch();
  late DateTime _countdownEndTime;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  void _toggleStopwatch() {
    setState(() {
      if (_isStopwatchRunning) {
        _stopwatch.stop();
        _animationController.stop();
      } else {
        _stopwatch.start();
        _animationController.repeat();
      }
      _isStopwatchRunning = !_isStopwatchRunning;
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _stopwatchElapsed = Duration.zero;
      if (_isStopwatchRunning) {
        _stopwatch.start();
      }
    });
  }

  void _toggleCountdown() {
    setState(() {
      if (_isCountdownRunning) {
        _animationController.stop();
      } else {
        _countdownEndTime = DateTime.now().add(_countdownRemaining);
        _animationController.repeat();
      }
      _isCountdownRunning = !_isCountdownRunning;
    });
  }

  void _resetCountdown() {
    setState(() {
      _countdownRemaining = _countdownDuration;
      _isCountdownRunning = false;
      _animationController.reset();
    });
  }

  void _updateCountdownDuration(Duration duration) {
    setState(() {
      _countdownDuration = duration;
      if (!_isCountdownRunning) {
        _countdownRemaining = duration;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Timer', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: TabBar(
                indicatorColor: const Color(0xFFFF0B55),
                labelColor: const Color(0xFFFF0B55),
                unselectedLabelColor: const Color(0xFF6C7A89),
                tabs: const [Tab(text: 'Stopwatch'), Tab(text: 'Countdown')],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [_buildStopwatchTab(), _buildCountdownTab()],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildStopwatchTab() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        if (_isStopwatchRunning) {
          _stopwatchElapsed = _stopwatch.elapsed;
        }
        final hours = _stopwatchElapsed.inHours;
        final minutes = _stopwatchElapsed.inMinutes % 60;
        final seconds = _stopwatchElapsed.inSeconds % 60;
        final milliseconds = _stopwatchElapsed.inMilliseconds % 1000 ~/ 10;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 120,
                lineWidth: 12,
                percent: _stopwatchElapsed.inMilliseconds / 3600000 % 1,
                progressColor: const Color(0xFFFF0B55),
                backgroundColor: const Color(0xFF333333),
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  '${hours.toString().padLeft(2, '0')}:'
                  '${minutes.toString().padLeft(2, '0')}:'
                  '${seconds.toString().padLeft(2, '0')}.'
                  '${milliseconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                animation: true,
                animateFromLastPercent: true,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isStopwatchRunning)
                    _buildTimerButton(
                      icon: Icons.play_arrow,
                      onPressed: _toggleStopwatch,
                    ),
                  if (_isStopwatchRunning)
                    _buildTimerButton(
                      icon: Icons.pause,
                      onPressed: _toggleStopwatch,
                    ),
                  const SizedBox(width: 20),
                  _buildTimerButton(
                    icon: Icons.stop,
                    onPressed: _resetStopwatch,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountdownTab() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        if (_isCountdownRunning) {
          final now = DateTime.now();
          if (now.isAfter(_countdownEndTime)) {
            _countdownRemaining = Duration.zero;
            _isCountdownRunning = false;
            _animationController.reset();
          } else {
            _countdownRemaining = _countdownEndTime.difference(now);
          }
        }

        final minutes = _countdownRemaining.inMinutes;
        final seconds = _countdownRemaining.inSeconds % 60;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 120,
                lineWidth: 12,
                percent:
                    _countdownRemaining.inSeconds /
                    _countdownDuration.inSeconds,
                progressColor: const Color(0xFFFF0B55),
                backgroundColor: const Color(0xFF333333),
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  '${minutes.toString().padLeft(2, '0')}:'
                  '${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                animation: true,
                animateFromLastPercent: true,
              ),
              const SizedBox(height: 20),
              _buildDurationSelector(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isCountdownRunning)
                    _buildTimerButton(
                      icon: Icons.play_arrow,
                      onPressed: _toggleCountdown,
                    ),
                  if (_isCountdownRunning)
                    _buildTimerButton(
                      icon: Icons.pause,
                      onPressed: _toggleCountdown,
                    ),
                  const SizedBox(width: 20),
                  _buildTimerButton(
                    icon: Icons.stop,
                    onPressed: _resetCountdown,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDurationSelector() {
    const durations = [
      Duration(minutes: 1),
      Duration(minutes: 5),
      Duration(minutes: 10),
      Duration(minutes: 25),
      Duration(minutes: 30),
      Duration(minutes: 60),
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: durations.length,
        itemBuilder: (context, index) {
          final duration = durations[index];
          final minutes = duration.inMinutes;
          final isSelected = duration == _countdownDuration;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text('$minutes min'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _updateCountdownDuration(duration);
                }
              },
              selectedColor: const Color(0xFFFF0B55),
              backgroundColor: const Color(0xFF333333),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6C7A89),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimerButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 32),
        color: const Color(0xFFFF0B55),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabIndex,
      onTap: (index) {
        if (index == _currentTabIndex) return;

        setState(() => _currentTabIndex = index);

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const DashboardScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const TasksScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const ProfileScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        }
      },
      backgroundColor: Colors.black,
      selectedItemColor: const Color(0xFFFF0B55),
      unselectedItemColor: const Color(0xFF6C7A89),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Today',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
