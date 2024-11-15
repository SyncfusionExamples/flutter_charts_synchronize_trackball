import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(const SynchronizedTrackball());

class SynchronizedTrackball extends StatelessWidget {
  const SynchronizedTrackball({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Synchronized Trackball',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                'Flutter chart Trackball synchronization',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(child: FirstChart()),
            const Expanded(child: SecondChart()),
          ],
        ),
      ),
    );
  }
}

TrackballBehavior? _trackBall1;
TrackballBehavior? _trackBall2;

ChartSeriesController? _secondChartController;
ChartSeriesController? _firstChartController;

Offset? _firstPosition;
Offset? _secondPosition;

List<ChartData> _getChartData() {
  return <ChartData>[
    ChartData('Jan', 28),
    ChartData('Feb', 32),
    ChartData('Mar', 45),
    ChartData('Apr', 50),
    ChartData('May', 65),
    ChartData('Jun', 48),
    ChartData('Jul', 52),
    ChartData('Aug', 60),
    ChartData('Sep', 55),
    ChartData('Oct', 70),
    ChartData('Nov', 62),
    ChartData('Dec', 75),
  ];
}

TrackballBehavior _getTrackballBehavior() {
  return TrackballBehavior(
    enable: true,
    activationMode: ActivationMode.singleTap,
    lineColor: Colors.orange,
    lineWidth: 1.5,
    markerSettings: const TrackballMarkerSettings(
      markerVisibility: TrackballVisibilityMode.visible,
    ),
    tooltipSettings: InteractiveTooltip(
      enable: true,
      color: Colors.blueGrey[700],
      textStyle: const TextStyle(color: Colors.white),
    ),
  );
}

class FirstChart extends StatefulWidget {
  const FirstChart({super.key});

  @override
  State<StatefulWidget> createState() {
    return FirstChartState();
  }
}

class FirstChartState extends State<FirstChart> {
  late List<ChartData> _chartData;

  bool _isInteractive = false;

  @override
  void initState() {
    super.initState();
    _chartData = _getChartData();
    _trackBall1 = _getTrackballBehavior();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(
        text: 'Chart 1',
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
        _isInteractive = true;
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
        _isInteractive = false;
        _trackBall2!.hide();
      },
      onTrackballPositionChanging: (TrackballArgs trackballArgs) {
        if (_isInteractive) {
          _secondPosition = _firstChartController!.pointToPixel(
            trackballArgs.chartPointInfo.chartPoint!,
          );
          _trackBall2!.show(_secondPosition!.dx, _secondPosition!.dy, 'pixel');
        }
      },
      backgroundColor: Colors.white,
      plotAreaBorderColor: Colors.grey,
      plotAreaBorderWidth: 1,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: Colors.grey[300],
        ),
      ),
      trackballBehavior: _trackBall1,
      series: _buildSeries(),
    );
  }

  List<LineSeries<ChartData, String>> _buildSeries() {
    return <LineSeries<ChartData, String>>[
      LineSeries<ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartData data, int index) => data.x,
        yValueMapper: (ChartData data, int index) => data.y,
        width: 2.5,
        onRendererCreated: (ChartSeriesController controller) {
          _firstChartController = controller;
        },
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    _firstChartController = null;
    super.dispose();
  }
}

class SecondChart extends StatefulWidget {
  const SecondChart({super.key});

  @override
  State<StatefulWidget> createState() {
    return SecondChartState();
  }
}

class SecondChartState extends State<SecondChart> {
  late List<ChartData> _chartData;

  bool _isInteractive = false;

  @override
  void initState() {
    super.initState();
    _chartData = _getChartData();
    _trackBall2 = _getTrackballBehavior();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(
        text: 'Chart 2',
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      onChartTouchInteractionDown: (ChartTouchInteractionArgs tapArgs) {
        _isInteractive = true;
      },
      onChartTouchInteractionUp: (ChartTouchInteractionArgs tapArgs) {
        _isInteractive = false;
        _trackBall1!.hide();
      },
      onTrackballPositionChanging: (TrackballArgs trackballArgs) {
        if (_isInteractive) {
          _firstPosition = _secondChartController!.pointToPixel(
            trackballArgs.chartPointInfo.chartPoint!,
          );
          _trackBall1!.show(_firstPosition!.dx, _firstPosition!.dy, 'pixel');
        }
      },
      backgroundColor: Colors.white,
      plotAreaBorderColor: Colors.grey,
      plotAreaBorderWidth: 1,
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.grey[300],
        ),
      ),
      trackballBehavior: _trackBall2,
      series: _buildSeries(),
    );
  }

  List<LineSeries<ChartData, String>> _buildSeries() {
    return <LineSeries<ChartData, String>>[
      LineSeries<ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartData data, int index) => data.x,
        yValueMapper: (ChartData data, int index) => data.y,
        width: 2.5,
        onRendererCreated: (ChartSeriesController controller) {
          _secondChartController = controller;
        },
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    _secondChartController = null;
    super.dispose();
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
