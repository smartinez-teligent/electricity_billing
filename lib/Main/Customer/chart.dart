import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<_SalesData> data = [
    _SalesData('July', 155),
    _SalesData('Aug', 100),
    _SalesData('Sep', 200),
    _SalesData('Oct', 123),
    _SalesData('Nov', 210)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      //Initialize the chart widget
      SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          // Chart title
          title: ChartTitle(text: 'Consumption Report as of November 2021'),
          // Enable legend
          legend: Legend(isVisible: true),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ColumnSeries<_SalesData, String>>[
            ColumnSeries<_SalesData, String>(
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'KWh',
                isVisibleInLegend: true,
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ]),
      // Expanded(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     //Initialize the spark charts widget
      //     child: SfSparkLineChart.custom(
      //       //Enable the trackball
      //       trackball: SparkChartTrackball(
      //           activationMode: SparkChartActivationMode.tap),
      //       //Enable marker
      //       marker:
      //           SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.all),
      //       //Enable data label
      //       labelDisplayMode: SparkChartLabelDisplayMode.all,
      //       xValueMapper: (int index) => data[index].year,
      //       yValueMapper: (int index) => data[index].sales,
      //       dataCount: 5,
      //     ),
      //   ),
      // )
    ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
