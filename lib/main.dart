import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:chart/chart_model.dart';
import 'package:d_chart/d_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart' as rootBundle;
import 'dart:math' as math;

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double>? chartDatas;

  Future<void> readJson() async {
    final dummy = await rootBundle.rootBundle.loadString('lib/dummy.json');
    ChartModel data = chartFromJson(dummy);

    var datas = data.data!.courseData;
    double totalAvg = datas!
        .map((expense) => expense.avgScore!)
        .fold(0, (prev, amount) => prev + amount);

    List<double> summaryChart = [
      ...data.data!.courseData!.map((e) => e.avgScore! / totalAvg * 100)
    ];

    setState(() {
      chartDatas = summaryChart;
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> color = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (chartDatas != null)
                ? PieChart(
                    data: [
                      ...chartDatas!.map(
                        (e) => PieChartData(
                            Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(1.0),
                            e),
                      )
                    ],
                    radius: 65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Top',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Job Sourcesss'),
                      ],
                    ),
                  )
                : Text("asdasdasd")
          ],
        ),
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

// this is used to pass data about chart values to the widget
class PieChartData {
  const PieChartData(this.color, this.percent);

  final Color color;
  final double percent;
}

// our pie chart widget
class PieChart extends StatelessWidget {
  PieChart({
    required this.data,
    required this.radius,
    this.strokeWidth = 20,
    this.child,
    Key? key,
  })  : // make sure sum of data is never ovr 100 percent
        assert(data.fold<double>(0, (sum, data) => sum + data.percent) <= 100),
        super(key: key);

  final List<PieChartData> data;
  // radius of chart
  final double radius;
  // width of stroke
  final double strokeWidth;
  // optional child; can be used for text for example
  final Widget? child;

  @override
  Widget build(context) {
    return CustomPaint(
      painter: _Painter(strokeWidth, data),
      size: Size.square(radius),
      child: SizedBox.square(
        // calc diameter
        dimension: radius * 2,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

// responsible for painting our chart
class _PainterData {
  const _PainterData(this.paint, this.radians);

  final Paint paint;
  final double radians;
}

class _Painter extends CustomPainter {
  _Painter(double strokeWidth, List<PieChartData> data) {
    // convert chart data to painter data
    dataList = data
        .map((e) => _PainterData(
              Paint()
                ..color = e.color
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..strokeCap = StrokeCap.round,
              // remove padding from stroke
              (e.percent - _padding) * _percentInRadians,
            ))
        .toList();
  }

  static const _percentInRadians = 0.062831853071796;
  static const _padding = 6;
  static const _paddingInRadians = _percentInRadians * _padding;
  // 0 radians is to the right, but since we want to start from the top
  // we'll use -90 degrees in radians
  static const _startAngle = -1.570796 + _paddingInRadians / 2;

  late final List<_PainterData> dataList;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // keep track of start angle for next stroke
    double startAngle = _startAngle;

    for (final data in dataList) {
      final path = Path()..addArc(rect, startAngle, data.radians);

      startAngle += data.radians + _paddingInRadians;

      canvas.drawPath(path, data.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
