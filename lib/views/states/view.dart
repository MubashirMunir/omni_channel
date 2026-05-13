import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';
import '../../../theme/theme.dart';
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
            /// =====================================
            /// HEADER
            /// =====================================
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      TextWidget(
                        "Statistics Dashboard",

                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: Colors.black),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        "Monitor your social media performance and engagement.",

                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.sp,
                        ),
                      ),

                      SizedBox(height: 18.h),

                      _dateFilter(context),
                    ],
                  )
                : Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Statistics Dashboard",

                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 6.h),

                          Text(
                            "Monitor your social media performance and customer engagement.",

                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      _dateFilter(context),
                    ],
                  ),

            SizedBox(height: 20.h),

            /// =====================================
            /// STATS GRID
            /// =====================================
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

            SizedBox(height: 24.h),

            /// =====================================
            /// CHARTS
            /// =====================================
            isMobile
                ? Column(
                    children: [
                      _lineChartCard(context, isMobile),

                      SizedBox(height: 20.h),

                      _pieChartCard(context),
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

                      Expanded(flex: 2, child: _pieChartCard(context)),
                    ],
                  ),

            SizedBox(height: 24.h),

            /// =====================================
            /// BOTTOM CARDS
            /// =====================================
            isMobile
                ? Column(
                    children: [
                      _bottomCard(context,
                        title: "Top Performing Agent",
                        subtitle: "Sarah Wilson",
                        value: "1.8K replies",
                        icon: Icons.workspace_premium,
                        color: Colors.amber,
                      ),

                      SizedBox(height: 18.h),

                      _bottomCard(context,
                        title: "Customer Satisfaction",
                        subtitle: "Excellent",
                        value: "94% Positive",
                        icon: Icons.favorite,
                        color: Colors.red,
                      ),

                      SizedBox(height: 18.h),

                      _bottomCard(context,
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
                        child: _bottomCard(context,
                          title: "Top Performing Agent",
                          subtitle: "Sarah Wilson",
                          value: "1.8K replies",
                          icon: Icons.workspace_premium,
                          color: Colors.amber,
                        ),
                      ),

                      SizedBox(width: 18.w),

                      Expanded(
                        child: _bottomCard(context,
                          title: "Customer Satisfaction",
                          subtitle: "Excellent",
                          value: "94% Positive",
                          icon: Icons.favorite,
                          color: Colors.red,
                        ),
                      ),

                      SizedBox(width: 18.w),

                      Expanded(
                        child: _bottomCard(context,
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
            ).textTheme.labelSmall?.copyWith(color: Colors.grey),
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
      height: isMobile ? 340.h : 380.h,

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

          SizedBox(height: 30.h),

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

                          child: Text(
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

  Widget _pieChartCard(BuildContext context) {
    return Container(
      height: 380.h,

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

          SizedBox(height: 100.h),

          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 80,

                sectionsSpace: 4,

                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: 40,
                    title: "40%",
                    radius: 60,
                  ),

                  PieChartSectionData(
                    color: Colors.pink,
                    value: 25,
                    title: "25%",
                    radius: 60,
                  ),

                  PieChartSectionData(
                    color: Colors.blue,
                    value: 20,
                    title: "20%",
                    radius: 60,
                  ),

                  PieChartSectionData(
                    color: Colors.orange,
                    value: 15,
                    title: "15%",
                    radius: 60,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          _legend(context, color: Colors.green, text: "WhatsApp"),

          SizedBox(height: 10.h),

          _legend(context, color: Colors.pink, text: "Instagram"),

          SizedBox(height: 10.h),

          _legend(context, color: Colors.blue, text: "Messenger"),

          SizedBox(height: 10.h),

          _legend(context, color: Colors.orange, text: "Email"),
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
      padding: EdgeInsets.all(15.w),

      decoration: _cardDecoration(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,

                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),

                  borderRadius: BorderRadius.circular(15.r),
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
          ).textTheme.labelSmall?.copyWith(color: Colors.black),
        ),
      ],
    );
  }

  /// =====================================
  /// BOTTOM CARD
  /// =====================================

  Widget _bottomCard(context,{
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 240.h,

      padding: EdgeInsets.all(15.w),

      decoration: _cardDecoration(),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

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

          const Spacer(),

          Text(
            title,

            style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
          ),

          SizedBox(height: 8.h),

          Text(
            subtitle,

            style: Theme.of(context).textTheme.labelSmall,
          ),

          SizedBox(height: 6.h),

          Text(
            value,

            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
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
