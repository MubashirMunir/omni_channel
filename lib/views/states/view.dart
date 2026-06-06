import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';
import '../../../theme/theme.dart';
import '../../responsive/sizes.dart';
import '../../widgets/text_widget.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 14.w : 24.w),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Statistics Dashboard",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Text(
                      "Monitor your social media performance and customer engagement.",

                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: isMobile ? 10 : 14,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                _dateFilter(context),
              ],
            ),

            SizedBox(height: 10.h),

            GridView.count(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: isMobile
                  ? 1
                  : isTablet
                  ? 2
                  : 4,

              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,

              childAspectRatio: isMobile ? 2.5 : 2.1,

              children: [
                _statCard(
                  context,

                  title: "Total Messages",
                  value: "24.8K",
                  growth: "+12%",
                  icon: Icons.message,
                  color: Colors.blue,
                ),

                _statCard(
                  context,
                  title: "Active Users",
                  value: "3.2K",
                  growth: "+8%",
                  icon: Icons.people_alt_outlined,
                  color: Colors.green,
                ),

                _statCard(
                  context,

                  title: "Avg Response",
                  value: "2.4m",
                  growth: "-18%",
                  icon: Icons.flash_on_outlined,
                  color: Colors.orange,
                ),

                _statCard(
                  context,

                  title: "Conversion Rate",
                  value: "74%",
                  growth: "+4%",
                  icon: Icons.bar_chart,
                  color: Colors.purple,
                ),
              ],
            ),

            SizedBox(height: 15.h),

            /// =====================================
            /// CHARTS
            /// =====================================
            isMobile
                ? Column(
                    children: [
                      _lineChartCard(context, isMobile),

                      SizedBox(height: 15.h),

                      _pieChartCard(context, isMobile),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        flex: 3,
                        child: _lineChartCard(context, isMobile),
                      ),

                      SizedBox(width: 16.w),

                      Expanded(
                        flex: 2,
                        child: _pieChartCard(context, isMobile),
                      ),
                    ],
                  ),

            SizedBox(height: 15.h),

            /// =====================================
            /// BOTTOM CARDS
            /// =====================================
            isMobile
                ? Column(
                    children: [
                      _bottomCard(
                        context,
                        title: "Top Performing Agent",
                        subtitle: "Sarah Wilson",
                        value: "1.8K replies",
                        icon: Icons.workspace_premium,
                        color: Colors.amber,
                      ),

                      SizedBox(height: 15.h),

                      _bottomCard(
                        context,
                        title: "Customer Satisfaction",
                        subtitle: "Excellent",
                        value: "94% Positive",
                        icon: Icons.favorite,
                        color: Colors.red,
                      ),

                      SizedBox(height: 15.h),
                      _bottomCard(
                        context,
                        title: "Peak Activity",
                        subtitle: "7PM - 10PM",
                        value: "Highest Engagement",
                        icon: Icons.access_time,
                        color: Colors.blue,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _bottomCard(
                          context,
                          title: "Top Performing Agent",
                          subtitle: "Sarah Wilson",
                          value: "1.8K replies",
                          icon: Icons.workspace_premium,
                          color: Colors.amber,
                        ),
                      ),

                      SizedBox(width: 15.w),

                      Expanded(
                        child: _bottomCard(
                          context,
                          title: "Customer Satisfaction",
                          subtitle: "Excellent",
                          value: "94% Positive",
                          icon: Icons.favorite,
                          color: Colors.red,
                        ),
                      ),

                      SizedBox(width: 15.w),

                      Expanded(
                        child: _bottomCard(
                          context,
                          title: "Peak Activity",
                          subtitle: "7PM - 10PM",
                          value: "Highest Engagement",
                          icon: Icons.access_time,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  /// =====================================
  /// DATE FILTER
  /// =====================================

  Widget _dateFilter(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),

      decoration: _cardDecoration(),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(Icons.calendar_month, color: AppTheme.primaryColor),

          SizedBox(width: 10.w),

          Text(
            "Last 30 Days",

            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// LINE CHART
  /// =====================================

  Widget _lineChartCard(BuildContext context, bool isMobile) {
    return Container(
      height: isMobile ? 230.h : 350.h,

      padding: EdgeInsets.all(15.w),

      decoration: _cardDecoration(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              TextWidget(
                "Messages Analytics",

                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),

                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.08),

                  borderRadius: BorderRadius.circular(30.r),
                ),

                child: Text(
                  "Weekly Report",
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),

                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];

                        return Padding(
                          padding: EdgeInsets.only(top: 10.h),

                          child: TextWidget(
                            days[value.toInt()],
                            style: TextStyle(fontSize: 11.sp),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,

                    color: AppTheme.primaryColor,

                    barWidth: 4,

                    belowBarData: BarAreaData(
                      show: true,

                      color: AppTheme.primaryColor.withOpacity(0.1),
                    ),

                    spots: const [
                      FlSpot(0, 30),
                      FlSpot(1, 60),
                      FlSpot(2, 45),
                      FlSpot(3, 90),
                      FlSpot(4, 70),
                      FlSpot(5, 110),
                      FlSpot(6, 85),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// PIE CHART
  /// =====================================

  Widget _pieChartCard(BuildContext context, isMobile) {
    return Container(
      height: isMobile ? 230.h : 350.h,

      padding: EdgeInsets.all(15.w),

      decoration: _cardDecoration(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "Traffic Sources",

            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.black),
          ),

          // SizedBox(height: 80.h),
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 50,

                sectionsSpace: 4,

                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: 40,
                    title: "40%",
                    radius: 40,
                  ),

                  PieChartSectionData(
                    color: Colors.pink,
                    value: 25,
                    title: "25%",
                    radius: 40,
                  ),

                  PieChartSectionData(
                    color: Colors.blue,
                    value: 20,
                    title: "20%",
                    radius: 40,
                  ),

                  PieChartSectionData(
                    color: Colors.orange,
                    value: 15,
                    title: "15%",
                    radius: 40,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 15.w),
          Row(
            children: [
              _legend(context, color: Colors.green, text: "WhatsApp"),

              SizedBox(height: 15.w),

              _legend(context, color: Colors.pink, text: "Instagram"),

              SizedBox(height: 15.w),

              _legend(context, color: Colors.blue, text: "Messenger"),

              SizedBox(height: 15.w),

              _legend(context, color: Colors.orange, text: "Email"),
            ],
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// STAT CARD
  /// =====================================

  Widget _statCard(
    context, {
    required String title,
    required String value,
    required String growth,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(15),

      decoration: _cardDecoration(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),

                  borderRadius: BorderRadius.circular(
                    AppTheme.radiusSM(context),
                  ),
                ),

                child: Icon(icon, color: color),
              ),

              const Spacer(),

              TextWidget(
                growth,

                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: growth.contains('-') ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),

          const Spacer(),

          TextWidget(
            value,

            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.black),
          ),

          SizedBox(height: 6.h),

          TextWidget(title, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  /// =====================================
  /// LEGEND
  /// =====================================

  Widget _legend(context, {required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 14.w,
          height: 14.w,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        SizedBox(width: 10.w),

        Text(
          text,

          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  /// =====================================
  /// BOTTOM CARD
  /// =====================================

  Widget _bottomCard(
    context, {
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 200.h,

      padding: EdgeInsets.all(15.w),

      decoration: _cardDecoration(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),

                  borderRadius: BorderRadius.circular(16.r),
                ),

                child: Icon(icon, color: color),
              ),
              Text(
                value,

                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.textColor)

              ),
            ],
          ),

          Spacer(),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.grey),
          ),

          SizedBox(height: 6.h),

          Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// CARD DECORATION
  /// =====================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(24.r),

      border: Border.all(color: Colors.grey.withOpacity(0.08)),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
